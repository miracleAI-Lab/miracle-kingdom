// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./libraries/GameLib.sol";
import "./libraries/ConstLib.sol";
import "./interfaces/IBackpackFactory.sol";
import "./interfaces/IGameDB.sol";
import "./interfaces/IGameDB2.sol";
import "./interfaces/IEquipmentNFT.sol";
import "./interfaces/ISharePool.sol";
import "./CallerUpgradeableMgr.sol";

// Contract for managing a trading marketplace for in-game items
contract TradeMarket is Initializable, ReentrancyGuardUpgradeable, CallerUpgradeableMgr {
    // Structure to represent a prop order
    struct PropOrder {
        uint256 propId;
        address owner;
        uint256 price;
        uint256 num;
        uint256 payType;
    }

    IERC20 public usdtToken;
    IERC20 public coreToken;
    IERC20 public pMAI3Token;
    address public treasury; // Treasury account

    uint256 public protocolFee;
    uint256 private _orderNo;

    mapping(uint256 => PropOrder) private _propOrders;
    mapping(address => address) private _gmSellAccount;

    IGameDB private _gameDB;
    IGameDB2 private _gameDB2;
    IEquipmentNFT private _equipmentNFT;
    IBackpackFactory private _backpackFactory;
    ISharePool private _sharePool; // Share pool

    // Events
    event BuyOrder(uint256 orderNo, uint256 propId, address buyer, uint256 num, uint256 payAmount, uint256 payType);
    event CreateOrder(uint256 orderNo, uint256 propId, address owner, uint256 price, uint256 num, uint256 payType);
    event CancelOrder(uint256 orderNo, address owner);
    event UpdateSellOrder(uint256 orderNo, uint256 propId, address buyer, uint256 price, uint256 num, uint256 payType);

    // Initialize the contract
    function initialize(
        IERC20 _usdtToken, 
        IERC20 _coreToken,
        IERC20 _pMAI3Token, 
        address _treasury,
        IGameDB gameDB,
        IGameDB2 gameDB2,
        IEquipmentNFT equipmentNFT,
        IBackpackFactory backpackFactory,
        ISharePool sharePool
    ) public initializer {
        usdtToken = _usdtToken;
        coreToken = _coreToken;
        pMAI3Token = _pMAI3Token;
        treasury = _treasury;
        _gameDB = gameDB;
        _gameDB2 = gameDB2;
        _equipmentNFT = equipmentNFT;
        _backpackFactory = backpackFactory;
        protocolFee = 50; // 5%
        _sharePool = sharePool;

        __CallerUpgradeableMgr_init();
    }

    // Put up items for sale
    function createOrder(
        uint256 propId, 
        uint256 price, 
        uint256 num, 
        uint256 payType
    ) public nonReentrant {
        // Validate that the payment method is only the specified method
        require(payType >= ConstLib.GOLD_COIN && payType <= ConstLib.CORE_TOKEN, "PropMarketplace: Invalid params payType");

        _orderNo++;
        _propOrders[_orderNo] = PropOrder(propId, msg.sender, price, num, payType);
        _backpackFactory.subBalance(propId, msg.sender, num);
       
        emit CreateOrder(_orderNo, propId, msg.sender, price, num, payType);
    }

    // Modify information about items for sale
    function updateSellOrder(
        uint256 orderNo,
        uint256 price, 
        uint256 num, 
        uint256 payType
    ) public nonReentrant {
        PropOrder storage order =  _propOrders[orderNo];
        require(order.owner == msg.sender, "PropMarketplace: The owner of this order does not belong to you");

        if (order.num > num) {
            _backpackFactory.addBalance(order.propId, msg.sender, order.num - num);
        } else {
            _backpackFactory.subBalance(order.propId, msg.sender, num - order.num);
        }
        _propOrders[orderNo] = PropOrder(order.propId, msg.sender, price, num, payType);

        emit UpdateSellOrder(orderNo, order.propId, msg.sender, price, num, payType);
    }

    // Cancel information about items for sale
    function cancelOrder(uint256 orderNo) public nonReentrant {
        PropOrder storage order =  _propOrders[orderNo];
        require(order.owner == msg.sender, "PropMarketplace: The owner of this order does not belong to you");

        _backpackFactory.addBalance(order.propId, order.owner, order.num);
        delete _propOrders[_orderNo];
       
        emit CancelOrder(_orderNo, msg.sender);
    }

    // User buys props
    function buyOrder(uint256 orderNo, uint256 price, uint256 num) public nonReentrant {
        PropOrder storage order =  _propOrders[orderNo];
        require(num <= order.num, "PropMarketplace: Purchase quantity exceeds maximum inventory");
        require(price == order.price, "Frontend price not match contract price!");
        
        // If the seller is official, use the account set by the GM
        address seller = _gmSellAccount[order.owner];
        if (seller == address(0)) {
            seller = order.owner;
        }

        order.num -= num;
        uint256 amount = order.price * num;
        uint256 fee = amount * protocolFee / 1000;
        address buyer = msg.sender;
        if (order.payType == ConstLib.USDT_COIN) {
            usdtToken.transferFrom(buyer, address(this), amount);
            usdtToken.transfer(seller, amount - fee);
            // Share pool and treasury
            usdtToken.transfer(address(_sharePool), fee / 2);
            usdtToken.transfer(treasury, fee / 2);
        } else if (order.payType == ConstLib.CORE_TOKEN) {
            coreToken.transferFrom(buyer, address(this), amount);
            coreToken.transfer(seller, amount - fee);
            // Share pool and treasury
            coreToken.transfer(treasury, fee / 2);
            coreToken.approve(address(_sharePool), type(uint256).max);
            _sharePool.addRewards(fee / 2);
        } else if (order.payType == ConstLib.GOLD_COIN) {
            _backpackFactory.subBalance(order.payType, buyer, amount);
            _backpackFactory.addBalance(order.payType, seller, amount - fee);
            // Gold coins are destroyed directly
            _backpackFactory.addBalance(order.payType, address(0), fee);
        } else {
            revert("Invalid payType");
        }

        // Buyer's wallet balance increases by the number of items
        _backpackFactory.addBalance(order.propId, buyer, num);

        // If the order inventory is 0, delete the order
        if (order.num == 0) {
            delete _propOrders[_orderNo];
        }

        emit BuyOrder(orderNo, order.propId, buyer, num, amount, order.payType);
    }

    // Making equipment
    function makeEquipment(uint256 equipId, uint256[] memory gemstones) public {
        pMAI3Token.transferFrom(msg.sender, address(this), _gameDB2.getEquipment(equipId).fee);
        pMAI3Token.approve(address(_equipmentNFT), type(uint256).max);
        _equipmentNFT.mint(equipId, gemstones, msg.sender);
    }

    // Casting gold coins
    function makeGold(uint256 tokenId, uint256 num) public {
        address owner = msg.sender;
        if (tokenId == ConstLib.GOLD_SILVE_STONE) {
            _backpackFactory.addBalance(ConstLib.GOLD_COIN, owner, num * 2);
        } else if (tokenId == ConstLib.GOLD_ORE) {
            _backpackFactory.addBalance(ConstLib.GOLD_COIN, owner, num);
        } else if (tokenId == ConstLib.SILVER_ORE) {
            _backpackFactory.addBalance(ConstLib.GOLD_COIN, owner, num / 2);
        } else if (tokenId == ConstLib.COPPER_ORE) {
            _backpackFactory.addBalance(ConstLib.GOLD_COIN, owner, num / 4);
        } else if (tokenId == ConstLib.BLACK_IRON_STONE) {
            _backpackFactory.addBalance(ConstLib.GOLD_COIN, owner, num / 8);
        } else {
            revert("tokenId invalid");
        } 

        _backpackFactory.subBalance(tokenId, owner, num);
    }

    // Swap CORE tokens for pMAI3 tokens
    function swapPMAI3(uint256 amount) public {
        coreToken.transferFrom(msg.sender, address(this), amount);
        pMAI3Token.transfer(msg.sender, amount);
    }

    // Calculate the amount of gold coins that can be made from a given token and quantity
    function getMakeGoldNum(uint256 tokenId, uint256 num) public pure returns (uint256) {
        if (tokenId == ConstLib.GOLD_SILVE_STONE) {
            return num * 2;
        } else if (tokenId == ConstLib.GOLD_ORE) {
           return num;
        } else if (tokenId == ConstLib.SILVER_ORE) {
            return num / 2;
        } else if (tokenId == ConstLib.COPPER_ORE) {
            return num / 4;
        } else if (tokenId == ConstLib.BLACK_IRON_STONE) {
            return num / 8;
        } else {
            return 0;
        } 
    }

    // Get prop order details
    function getPropOrder(uint256 orderNo) public view returns (PropOrder memory) {
        return _propOrders[orderNo];
    }

    // Set GM sell account
    function setGmSellAccount(address account) public onlyCaller {
        _gmSellAccount[msg.sender] = account;
    }

    // Set share pool
    function setSharePool(ISharePool sharePool) public onlyCaller {
        _sharePool = sharePool;
    }

    // Get current order number
    function getOrderNo() public view returns (uint256) {
        return _orderNo;
    }

    // Set protocol fee
    function setProtocolFee(uint256 _protocolFee) public onlyCaller {
        protocolFee = _protocolFee;
    }

    // Set treasury address
    function setTreasury(address _treasury) public onlyCaller {
        treasury = _treasury;
    }
}