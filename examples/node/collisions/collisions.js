const fs = require('fs');

const bytes = fs.readFileSync('./collisions.wasm');

const memory = new WebAssembly.Memory({initial: 1});
const mem_i32 = new Uint32Array(memory.buffer);

const obj_base_addr = 0;
const obj_count = 32;
const obj_stride = 16;

// structure offset
const x_offset = 0;
const y_offset = 4;
const r_offset = 8;
const c_offset = 12;

const obj_i32_base_index = obj_base_addr / 4;
const obj_i32_stride = obj_stride / 4;

const x_offset_i32 = x_offset / 4;
const y_offset_i32 = y_offset / 4;
const r_offset_i32 = r_offset / 4;
const c_offset_i32 = c_offset / 4;

const importObject = {
  env: {
    mem: memory,
    obj_base_addr: obj_base_addr,
    obj_count: obj_count,
    obj_stride: obj_stride,
    x_offset: x_offset,
    y_offset: y_offset,
    r_offset: r_offset,
    c_offset: c_offset,
  },
};

for (let i = 0; i < obj_count; i++) {
  let index = obj_i32_stride * i + obj_i32_base_index;

  let x = Math.floor(Math.random() * 100);
  let y = Math.floor(Math.random() * 100);
  let r = Math.ceil(Math.random() * 10);

  mem_i32[index + x_offset_i32] = x;
  mem_i32[index + y_offset_i32] = y;
  mem_i32[index + r_offset_i32] = r;
}

(async () => {
  let obj = await WebAssembly.instantiate(new Uint8Array(bytes), importObject);

  for (let i = 0; i < obj_count; i++) {
    let index = obj_i32_stride * i + obj_i32_base_index;
    
    let x = mem_i32[index + x_offset_i32].toString().padStart(2, " ");
    let y = mem_i32[index + y_offset_i32].toString().padStart(2, " ");
    let r = mem_i32[index + r_offset_i32].toString().padStart(2, " ");

    let i_str = i.toString().padStart(2, " ");
    let c = !!mem_i32[index + c_offset_i32];

    console.log(`obj[${i_str}] x=${x} y=${y} r=${r} collision=${c}`);
  }
})();

