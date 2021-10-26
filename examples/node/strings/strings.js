const fs = require('fs');
const bytes = fs.readFileSync('./strings.wasm');

// one page of memory
let memory = new WebAssembly.Memory({initial: 1});
const max_mem = 65535;

let importObject = {
  env: {
    buffer: memory,
    null_str: function(pos) {
      // hack
      const str_bytes = new Uint8Array(memory.buffer, pos, max_mem - pos);
      let loggable_string = (new TextDecoder('utf8').decode(str_bytes))
        .split('\0')[0];
      console.log(loggable_string);
    },
    str_pos_len: function(pos, len) {
      const str_bytes = new Uint8Array(memory.buffer, pos, len);
      const loggable_string = new TextDecoder('utf8').decode(str_bytes);
      console.log(loggable_string);
    },
    len_prefixed: function(pos) {
      // len can only be a byte
      const str_len = new Uint8Array(memory.buffer, pos, 1)[0];
      const str_bytes = new Uint8Array(memory.buffer, pos + 1, str_len);
      const loggable_string = new TextDecoder('utf8').decode(str_bytes);
      console.log(loggable_string);
    }
  }
}

WebAssembly.instantiate(new Uint8Array(bytes), importObject)
  .then(obj => obj.instance.exports.main());
