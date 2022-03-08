const fs = require("fs");
const bytes = fs.readFileSync("./example.wasm");

const importObject = {
  env: {
    log: (num) => console.log(`Block: ${num}`)
  },
};

WebAssembly.instantiate(new Uint8Array(bytes), importObject);
