(module
  (memory $mem 1)
  (export "mem" (memory $mem))
  (data (i32.const 0) "Hello")
  
  (func (export "dataLength") (result i32)
    i32.const 5
    return))