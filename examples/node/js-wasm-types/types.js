const fs = require('fs');
const bytes = fs.readFileSync('./types.wasm');

let importObject = {
  js: {
    log_i32: (v) => console.log("i32: ", v),
    log_f32: (v) => console.log("f32: ", v),
    log_f64: (v) => console.log("f64: ", v),
  },
  env: {
    import_i32: 5_000_000_000,
    import_f32: 123.0123456789,
    import_f64: 123.0123456789
  }
}

WebAssembly.instantiate(new Uint8Array(bytes), importObject)
  .then(obj => obj.instance.exports.globaltest());
