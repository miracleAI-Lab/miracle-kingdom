const fs = require('fs');
const path = require('path');

const {
  parse,
  stringify
} = require('envfile');

function setEnv(key, value) {
  const configPath = path.resolve(process.cwd(), `.env.${process.env.NODE_ENV}`);
  var data = fs.readFileSync(configPath);

  var result = parse(data);
  result[key] = value;

  fs.writeFileSync(configPath, stringify(result));
}

async function readEnv(key) {
  const configPath = path.resolve(process.cwd(), `.env.${process.env.NODE_ENV}`);
  var data = fs.readFileSync(configPath);

  var result = parse(data);
  var value = result[key];
  console.log(key, ' = ', value);

  return value;
}

export {
  setEnv, readEnv
};