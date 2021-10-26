(module
  (func $isprime (export "isprime") (param $n i32) (result i32)
    (local $i i32)
    
    local.get $n
    i32.const 1
    i32.eq
    if
      i32.const 0
      return ;; 1 is not prime
    end

    local.get $n
    call $istwo
    if
      i32.const 1
      return ;; 2 is prime
    end

    block $notprime
      local.get $n
      call $iseven
      br_if $notprime ;; even is not prime

      i32.const 1
      local.set $i
      loop $prime_test_loop
        local.get $i
        i32.const 2
        i32.add ;; i += 2
        local.tee $i ;; tee sets and keeps value at top of stack

        local.get $n

        i32.ge_u
        if
          i32.const 1
          return ;; if i >= n then n is prime
        end

        local.get $n
        local.get $i  
        call $ismultiple
        br_if $notprime

        br $prime_test_loop
      end
    end

    i32.const 0
    return
  )

  (func $iseven (param $n i32) (result i32)
    local.get $n
    i32.const 1
    i32.and
    i32.const 0
    i32.eq
  )

  (func $istwo (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.eq
  )

  (func $ismultiple (param $n i32) (param $m i32) (result i32)
    local.get $n
    local.get $m
    i32.rem_u
    i32.const 0
    i32.eq
  )
)