(module
  (import "env" "mem" (memory 1))

  (global $data_addr (import "env" "data_addr") i32)
  (global $data_count (import "env" "data_count") i32)

  (func $store_data (param $index i32) (param $value i32)
    (i32.store
      (i32.add 
        (global.get $data_addr)
        (i32.mul (i32.const 4) (local.get $index))
      )
      (local.get $value)
    )
  )

  (func $init
    (local $index i32)

    (loop $data_loop
      (call $store_data
        (local.get $index)
        (i32.mul (local.get $index) (i32.const 5))
      )

      (i32.add (local.get $index) (i32.const 1))

      (br_if $data_loop (i32.lt_u (local.tee $index) (global.get $data_count)))
    )

    (call $store_data (i32.const 0) (i32.const 1))
  )

  (start $init)
)