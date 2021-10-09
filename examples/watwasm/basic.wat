(module
  ;; stack based format is preferrable as it's closer to actual execution
  (func (export "main") (result i32)
    i32.const 42
    return)
  ;; (func (export "main") (result i32)
  ;;   (return (i32.const 42)))
  )
