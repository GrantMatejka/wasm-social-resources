(module
  
  (import "env" "log" (func $log (param i32)))

  (func $dispatch_example
    (local $next_block i32)
    (local $x i32)
    i32.const 0
    local.set $next_block
    i32.const 0
    local.set $x

    loop
      local.get $x
      i32.const 1
      i32.add
      local.set $x ;; increment x

      block ;; BLOCK D
        block ;; BLOCK C
          block ;; BLOCK B
            block ;; BLOCK A
              block ;; DISPATCH BLOCK
                local.get $next_block
                ;; $next_block represents the number of outer blocks
                ;; to jump to the end to, to get to the instructions of the block of interest

                ;; Ex: To get to block A we want to (br 0) as this will cause us to jump
                ;; to the end of the current block and immediately following the
                ;; current block is Block A's instructions
                ;; To execute block C we will to the end of 2 blocks above us:
                ;;   That is jump out of blocks dispatch (0), A (1) and B (2)
                ;;   The contents of block C immediately follow the end of block B
                br_table 0 1 2 3
              end

              ;; Block A
              i32.const 1
              call $log ;; log what block we are in

              local.get $x
              i32.const 1
              i32.eq
              local.get $x
              i32.const 10
              i32.gt_s
              i32.or
              if
                i32.const 3 ;; if x == 1 or x == 11 goto D
                local.set $next_block
              else
                local.get $x
                i32.const 10
                i32.le_s
                if
                  i32.const 2 ;; if x <= 10 goto C
                  local.set $next_block
                end
              end

              br 4 ;; branch back to loop
            end

            ;; Block B
            i32.const 2
            call $log ;; log what block we are in

            local.get $x
            i32.const 3
            i32.eq
            if
              i32.const 2 ;; if x == 3 goto C
              local.set $next_block
            else
              local.get $x
              i32.const 6
              i32.eq
              if
                i32.const 2 ;; if x == 6 goto A
                local.set $next_block
              end
            end

            br 3 ;; branch back to loop
          end

          ;; Block C
          i32.const 3
          call $log ;; log what block we are in

          local.get $x
          i32.const 4
          i32.eq
          if
            i32.const 3 ;; if x == 4 goto D
            local.set $next_block
          else
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 0 ;; if x > 10 goto A
              local.set $next_block
            end
          end

          br 2 ;; branch back to loop
        end

        ;; Block D
        i32.const 4
        call $log ;; log what block we are in

        local.get $x
        i32.const 2
        i32.eq
        if
          i32.const 1 ;; if x == 2 goto B
          local.set $next_block
        else
          local.get $x
          i32.const 5
          i32.eq
          if
            i32.const 1 ;; if x == 5 goto B
            local.set $next_block
          end
        end

        local.get $x
        i32.const 10
        i32.lt_s
        br_if 1
      end
    end
    ;; End
  )

  (start $dispatch_example)
)