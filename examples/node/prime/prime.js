const fs = require('fs');
const bytes = fs.readFileSync('./prime.wasm');
const val = parseInt(process.argv[2]);

WebAssembly.instantiate(new Uint8Array(bytes))
  .then(obj => {
    console.log(`${val} is prime: ${obj.instance.exports.isprime(val)}`)
  });