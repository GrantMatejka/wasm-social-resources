(module
  ;; Can also add a label in the func declaration
  (; Function 0 ;)
  (import "env" "log" (func (param i32)))

  ;; S-expr format 
  (; Function 1 ;)
  (func (param i32) (result i32)
    (return
      (if (result i32)
        (i32.gt_u (local.get 0) (i32.const 2))
        (then (i32.add (i32.mul (i32.const 2) (local.get 0)) 
          (i32.sub (local.get 0) (i32.const 2))))
        (else (i32.add (i32.add (i32.const 1) (local.get 0)) 
          (i32.add (i32.const 1) 
            (i32.add (i32.const 1) (local.get 0)))))))
  )

  ;; Stack format
  (; Function 2 ;)
  (func (param i32) (result i32)
    local.get 0
    i32.const 2
    i32.gt_u

    if (result i32)
      local.get 0
      i32.const 2
      i32.sub

      i32.const 2
      local.get 0
      i32.mul

      i32.add
    else
      i32.const 1
      local.get 0
      i32.add

      i32.const 1
      i32.add

      i32.const 1
      local.get 0
      i32.add

      i32.add
    end
    
    return
  )

  (; Function 3 ;)
  (func
    ;; Call function indexed at 0 with param 1
    ;; then log the result
    i32.const 1
    call 1
    call 0

    i32.const 3
    call 1
    call 0
    
    i32.const 1
    call 2
    call 0

    i32.const 3
    call 2
    call 0
  )

  (start 3)
)