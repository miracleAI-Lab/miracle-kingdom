// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.11;

import "./libraries/SafeMath.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "./interfaces/ISharePool.sol";
import "./CallerUpgradeableMgr.sol";    

// Marketplace contract for trading NFTs
contract Marketplace is Initializable, IERC721ReceiverUpgradeable, CallerUpgradeableMgr {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.UintSet;

    // Structure to store trade details
    struct TradeDetail {
        IERC721 nft;
        uint256 id;
        uint256 tokenId;
        uint256 saleAt;
        uint256 cancelAt;
        uint256 tradeAt;
        address buyer;
        address owner;
        uint256 price;
    }

    // Enum to represent supported NFT types
    enum SupportNFTType {
        Hero,
        Equipment
    }

    address public treasury;
    uint256 public feePercent;
    uint256 public totalRecords;
    IERC20 public erc20Token;
    ISharePool private _sharePool;
    
    EnumerableSet.UintSet private _activeTradeIdSet;
    mapping(uint256 => TradeDetail) public tradeDetails;
    mapping(address => bool) public supportNFTs;
    mapping(address => SupportNFTType) public supportNFTTypes;

    // Mapping to store active trade IDs for each user
    mapping(address => EnumerableSet.UintSet) private _accountActiveTradeDetails;

    // Events for various marketplace actions
    event TradeActive(uint256 indexed _detailId, uint256 indexed tokenId, address seller, uint256 price, uint256 _type);
    event TradeCancled(uint256 indexed _detailId, uint256 indexed tokenId, uint256 nftType);
    event TradeSucceeded(uint256 indexed _detailId, uint256 indexed tokenId, address buyer, uint256 _type);
    event TradeFeeToTreasury(uint256 indexed _detailId, address indexed buyer, address indexed seller, uint256 orderPrice, uint256 fee, uint256 timestamp);

    // Initialize the marketplace contract
    function initialize(
        address[] calldata _nfts,
        IERC20 _erc20Token,
        address _treasury,
        ISharePool sharePool
    ) public initializer {
        __CallerUpgradeableMgr_init();

        treasury = _treasury;
        feePercent = 50; // 5%
        erc20Token = _erc20Token;
        _sharePool = sharePool;
        for (uint256 index = 0; index < _nfts.length; index++) {
            supportNFTs[_nfts[index]] = true;
        }
    }

    // Create a new order to sell an NFT
    function createOrder(
        IERC721 _nft,
        uint256 _tokenId,
        uint256 _price
    ) external {
        require(_price > 0, "NFT sell price must > 0");
        require(supportNFTs[address(_nft)], "NFT not support");

        address owner = msg.sender;
        _nft.safeTransferFrom(owner, address(this), _tokenId);

        totalRecords++;
        uint256 _detailId = totalRecords;

        tradeDetails[_detailId] = TradeDetail(_nft, _detailId, _tokenId, block.timestamp, 0, 0, address(0), owner, _price);
        _activeTradeIdSet.add(_detailId);
        _accountActiveTradeDetails[owner].add(_detailId);

        uint256 nftType  = uint256(supportNFTTypes[address(_nft)]);
        emit TradeActive(_detailId, _tokenId, owner, _price, nftType);
    }

    // Cancel an existing order
    function cancel(uint256 _detailId) external {
        address owner = tradeDetails[_detailId].owner;
        uint256 tokenId = tradeDetails[_detailId].tokenId;
        require(
            _detailId > 0 && tradeDetails[_detailId].id == _detailId && _activeTradeIdSet.contains(_detailId) && owner == msg.sender,
            "Trade error"
        );

        _activeTradeIdSet.remove(_detailId);
        _accountActiveTradeDetails[owner].remove(_detailId);
        tradeDetails[_detailId].nft.safeTransferFrom(address(this), owner, tokenId);

        uint256 nftType = uint256(supportNFTTypes[address(tradeDetails[_detailId].nft)]);
        emit TradeCancled(_detailId, tokenId, nftType);

        delete tradeDetails[_detailId];
    }

    // Buy an NFT from an existing order
    function buyOrder(
        uint256 _detailId,
        uint256 price
    ) external {
        require(tradeDetails[_detailId].price == price, "Price error");
        require(_detailId > 0 && tradeDetails[_detailId].id == _detailId && _activeTradeIdSet.contains(_detailId),
            "Status error"
        );

        address buyer = msg.sender;
        address owner = tradeDetails[_detailId].owner;
        uint256 orderPrice = tradeDetails[_detailId].price;
        price = orderPrice.mul(1000 - feePercent).div(1000);
        uint256 fee = orderPrice.sub(price);

        erc20Token.transferFrom(buyer, address(this), orderPrice);
        erc20Token.transfer(owner, price);
        // Transfer half of the fee to the treasury
        erc20Token.transfer(treasury, fee / 2);
        // Add the other half of the fee to the share pool
        erc20Token.approve(address(_sharePool), type(uint256).max);
        _sharePool.addRewards(fee / 2);

        uint256 tokenId = tradeDetails[_detailId].tokenId;
        _accountActiveTradeDetails[owner].remove(_detailId);
        _activeTradeIdSet.remove(_detailId);

        tradeDetails[_detailId].nft.safeTransferFrom(address(this), buyer, tokenId);

        uint256 nftType = uint256(supportNFTTypes[address(tradeDetails[_detailId].nft)]);
        emit TradeSucceeded(_detailId, tokenId, buyer, nftType);

        delete tradeDetails[_detailId];
    }

    // Get order information by detail ID
    function getOrderInfoByDetailId(uint256 _detailId) external view returns (uint256, address, address) {
        address owner = tradeDetails[_detailId].owner;
        address _buyer = msg.sender;
        uint256 orderPrice = tradeDetails[_detailId].price;

        uint256 bal = erc20Token.balanceOf(_buyer);
        require(bal >= orderPrice, "Buyer balance TIT not en");

        return (orderPrice, owner, address(erc20Token));
    }

    // Get active trade details for a specific account
    function getAccountActiveDetails(address account) external view returns (TradeDetail[] memory) {
        TradeDetail[] memory _details = new TradeDetail[](_accountActiveTradeDetails[account].length());
        for (uint256 i = 0; i < _details.length; i++) {
            _details[i] = tradeDetails[_accountActiveTradeDetails[account].at(i)];
        }
        return _details;
    }

    // Get all active trade IDs
    function getActiveTradeIds() external view returns (uint256[] memory) {
        return _activeTradeIdSet.values();
    }

    // Get all active trade details
    function getActiveTradeDetails() external view returns (TradeDetail[] memory) {
        TradeDetail[] memory _details = new TradeDetail[](_activeTradeIdSet.length());
        for (uint256 i = 0; i < _details.length; i++) {
            _details[i] = tradeDetails[_activeTradeIdSet.at(i)];
        }
        return _details;
    }

    // Implement ERC721 receiver interface
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Get trade details for a specific page
    function getTradeDetailPage(uint256 pageSize, uint256 pageIndex) external view returns (TradeDetail[] memory) {
        uint256 balance = _activeTradeIdSet.length();
        uint256 beginIndex = pageSize * pageIndex;

        if (beginIndex > balance) {
            return new TradeDetail[](0);
        }

        if (beginIndex + pageSize > balance) {
            pageSize = pageSize - (beginIndex + pageSize - balance);
        }

        TradeDetail[] memory _tradeDetails = new TradeDetail[](pageSize);

        for (uint256 i = 0; i < pageSize; i++) {
            _tradeDetails[i] = tradeDetails[_activeTradeIdSet.at(beginIndex + i)];
        }

        return _tradeDetails;
    }

    // Set the ERC20 token used for transactions
    function setERC20Token(address _erc20Token) external onlyCaller {
        erc20Token = IERC20(_erc20Token);
    }

    // Set supported NFTs
    function setSupportNFTs(address[] memory nfts, bool isSupport) external onlyCaller {
        for (uint256 index = 0; index < nfts.length; index++) {
            supportNFTs[nfts[index]] = isSupport;
        }
    }

    // Set supported NFT types
    function setSupportNFTType(address[] memory nfts, uint8[] memory _types) external onlyCaller {
        require(nfts.length == _types.length, "_types length error");

        for (uint256 index = 0; index < nfts.length; index++) {
            supportNFTTypes[nfts[index]] = SupportNFTType(_types[index]);
        }
    }

    // Get the supported NFT type for a given NFT address
    function getSupportNFTType(address _nft) public view returns (SupportNFTType) {
        return supportNFTTypes[_nft];
    }

    // Set the treasury address
    function setTreasury(address _treasury) external onlyCaller {
        treasury = _treasury;
    }

    // Set the fee percentage
    function setFeePercent(uint256 _feePercent) external onlyCaller {
        feePercent = _feePercent;
    }

    // Set the share pool address
    function setSharePool(ISharePool sharePool) external onlyCaller {
        _sharePool = sharePool;
    }
}