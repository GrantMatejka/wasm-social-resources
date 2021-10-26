const fs = require('fs');
const bytes = fs.readFileSync('./basicArith.wasm');

const v1 = parseInt(process.argv[2]);
const v2 = parseInt(process.argv[3]);

WebAssembly.instantiate(new Uint8Array(bytes))
  .then(obj => {
    let add_result = obj.instance.exports.add(v1, v2);
    console.log(`${v1} + ${v2} = ${add_result}`);

    let ss_result = obj.instance.exports.sumsquared(v1, v2);
    console.log(`(${v1} + ${v2}) * (${v1} + ${v2}) = ${ss_result}`);
  });
