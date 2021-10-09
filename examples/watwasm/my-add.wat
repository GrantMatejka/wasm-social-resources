(module
  (func $main (export "main") (param i32) (param i32) (result i32)
    local.get 0
    local.get 1
    i32.add
    return)
  (func (export "test1") (result i32)
    i32.const 1
    i32.const 1
    call $main
    return))