const fs = require('fs');
const bytes = fs.readFileSync('./fact.wasm');
const n = parseInt(process.argv[2] || "1");

let importObject =  {
  env: {
    log: function (n, f) { console.log(`${n}! = ${f}`); }
  }
};

(async () => {
  let obj = await WebAssembly.instantiate(new Uint8Array(bytes), importObject);

  const factorial = obj.instance.exports.factorial(n);
  console.log(`\nFinal: ${n}! = ${factorial}`);
  if (n > 12) {
    console.log("n > 12 is too big for i32");
  }
})();
