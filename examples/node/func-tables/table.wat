(module
  (import "js" "increment" (func $js_increment (result i32)))
  (import "js" "decrement" (func $js_decrement (result i32)))

  (table $tbl (export "tbl") 4 funcref)

  (global $i (mut i32) (i32.const 0))

  (func $increment (export "increment") (result i32)
    global.get $i
    i32.const 1
    i32.add
    global.set $i

    global.get $i 
  )

  (func $decrement (export "decrement") (result i32)
    global.get $i
    i32.const 1
    i32.sub
    global.set $i

    global.get $i
  )

  ;; populating table, you can't add js func to table in js land
  (elem (i32.const 0) $js_increment $js_decrement $increment $decrement)

  ;; ^ is same as
  ;; (elem (i32.const 0) $js_increment $js_decrement)
  ;; (elem (i32.const 2) $increment $decrement)
)