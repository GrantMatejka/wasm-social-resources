(module
  (global $g (mut i32) (i32.const 0))
  (func $getGlobal (result i32)
    (global.get $g))
  (func $incglobal
    i32.const 1
    global.get $g
    i32.add
    global.set $g)

  (func (export "getGlobalTest") (result i32)
    call $getGlobal)

  (func (export "incGlobalTest") (result i32)
    call $incglobal
    call $getGlobal)

  (func (export "incGlobalAgainTest") (result i32)
    call $incglobal
    call $getGlobal)
)