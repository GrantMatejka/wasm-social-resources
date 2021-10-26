const fs = require('fs');
const bytes = fs.readFileSync('./num_string.wasm');

const val = parseInt(process.argv[2]);
let memory = new WebAssembly.Memory({initial: 1});

const importObject = {
  env: {
    buffer: memory,
    print_string: function(pos, len) {
      const str_bytes = new Uint8Array(memory.buffer, pos, len);
      const log_string = new TextDecoder('utf8').decode(str_bytes);
      console.log(`>${log_string}`);
    }
  }
}

WebAssembly.instantiate(new Uint8Array(bytes), importObject)
  .then(obj => {
    obj.instance.exports.to_string(val);
  });
