;; function factorial(n) {
;;   if (n <= 2) return n;
;;   let fact = 1;
;;   for (let i = 2; i <= n; i++) {
;;       fact = fact * i;
;;   }
;;   return fact;
;; }

(module 
  (func $factItr (export "factorial_iterative") (param $n i32) (result i32)
    (local $i i32)
    (local $fac i32)
    
    i32.const 2
    local.get $n
    i32.ge_s  ;; if 2 is greater than or equal to n
    if (result i32)
      local.get $n
      return
    else
      i32.const 1 ;; init factorial calc
      local.set $fac
      i32.const 2
      local.set $i

      loop $facLoop
        local.get $i
        local.get $fac
        i32.mul
        local.set $fac

        local.get $i
        i32.const 1
        i32.add
        local.set $i

        local.get $n
        local.get $i
        i32.ge_s
        br_if $facLoop ;; arg is index of loop, can be '0' but for clarity label is used
      end

      local.get $fac
      return
    end)

  (func $factRec (export "factorial_recursive") (param $n i32) (result i32)
    i32.const 2
    local.get $n
    i32.ge_s
    if (result i32)
      local.get $n
    else
      local.get $n
      i32.const 1
      i32.sub
      call $factRec
      local.get $n
      i32.mul
    end
    return)
  
  (func (export "test-itr") (result i32)
    i32.const 5
    call $factItr)
  (func (export "test-rec") (result i32)
    i32.const 5
    call $factRec))