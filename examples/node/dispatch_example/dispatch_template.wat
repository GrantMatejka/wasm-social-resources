(module
  
  (import "env" "log" (func $log (param i32)))

  (func $dispatch_example

    loop
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

              ;; Block A instructions go here
        
              ;; Decide what next block to jump to here
              local.set $next_block

              br 4 ;; branch back to loop
            end

            ;; Block B instructions go here
        
            ;; Decide what next block to jump to here
            local.set $next_block

            br 3 ;; branch back to loop
          end

          ;; Block C instructions go here
        
          ;; Decide what next block to jump to here
          local.set $next_block

          br 2 ;; branch back to loop
        end

        ;; Block D instructions go here
        
        ;; Decide what next block to jump to here
        local.set $next_block

        br 1 ;; branch back to loop
      end
    end
    ;; End
  )

  (start $dispatch_example)
)