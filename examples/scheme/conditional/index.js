const fs = require("fs");
const bytes = fs.readFileSync("./cond.wasm");

const importObject = {
  env: {
    log: (x) => console.log(x)
  },
};

WebAssembly.instantiate(new Uint8Array(bytes), importObject).then((obj) => {});
