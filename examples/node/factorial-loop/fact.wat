(module
  (import "env" "log" (func $log (param i32 i32)))

  (func $factorial (export "factorial") (param $n i32) (result i32)
    (local $i i32)
    (local $f i32)

    i32.const 1
    local.set $f

    loop $continue
      block $break
        ;; increment i
        local.get $i
        i32.const 1
        i32.add
        local.set $i

        ;; ith factorial
        local.get $i
        local.get $f
        i32.mul
        local.set $f

        local.get $i
        local.get $f
        call $log

        local.get $i
        local.get $n
        i32.eq
        br_if $break

        br $continue
      end
    end
    
    local.get $f
  )
)