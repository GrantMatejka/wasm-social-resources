(module
  (import "env" "memory" (memory 1))

  (global $cells_index i32 (i32.const 128))
  (global $height (mut i32) (i32.const 100))
  (global $width (mut i32) (i32.const 100))

  (func (export "init_cells")
    (local $row i32)
    (local $col i32)
    (local $val i32)
    i32.const 0
    local.set $row

    loop $row_loop
      block $row_break
      
        i32.const 0
        local.set $col

        loop $col_loop
          block $col_break
            i32.const 0
            local.set $val
            
            ;; set the memory value
            (i32.store8
              (call $get_cell_index (local.get $row) (local.get $col))
              (local.get $val))

            ;; increment col
            local.get $col
            i32.const 1
            i32.add
            local.tee $col
            global.get $width
            i32.eq
            br_if $col_break
            br $col_loop
          end
        end

        ;; increment row
        local.get $row
        i32.const 1
        i32.add
        local.tee $row
        global.get $height
        i32.eq
        br_if $row_break
        br $row_loop
      end
    end

    ;; glider pattern
    (i32.store8 offset=128 (i32.const 2) (i32.const 1))
    (i32.store8 offset=128 (i32.const 103) (i32.const 1))
    (i32.store8 offset=128 (i32.const 203) (i32.const 1))
    (i32.store8 offset=128 (i32.const 202) (i32.const 1))
    (i32.store8 offset=128 (i32.const 201) (i32.const 1))

    ;; blinker
    (i32.store8 offset=128 (i32.const 8025) (i32.const 1))
    (i32.store8 offset=128 (i32.const 8026) (i32.const 1))
    (i32.store8 offset=128 (i32.const 8027) (i32.const 1))

    ;; boat
    (i32.store8 offset=128 (i32.const 525) (i32.const 1))
    (i32.store8 offset=128 (i32.const 526) (i32.const 1))
    (i32.store8 offset=128 (i32.const 625) (i32.const 1))
    (i32.store8 offset=128 (i32.const 627) (i32.const 1))
    (i32.store8 offset=128 (i32.const 726) (i32.const 1))

    ;; f|r
    (i32.store8 offset=128 (i32.const 575) (i32.const 1))
    (i32.store8 offset=128 (i32.const 576) (i32.const 1))
    (i32.store8 offset=128 (i32.const 675) (i32.const 1))
    (i32.store8 offset=128 (i32.const 674) (i32.const 1))
    (i32.store8 offset=128 (i32.const 775) (i32.const 1))
  )

  (func $get_cell_index (param $row i32) (param $col i32) (result i32)
    local.get $row
    global.get $width
    i32.mul
    local.get $col
    i32.add
    global.get $cells_index
    i32.add
    return
  )

  ;; this will serve as the second 'page' for rendering
  (func $get_temp_store_cell_index (param $row i32) (param $col i32) (result i32)
    (i32.add
      (i32.mul (local.get $row) (global.get $width))
      ;; offset for page memory
      (i32.mul (global.get $height) (global.get $width)))
    local.get $col
    i32.add
    global.get $cells_index
    i32.add
    return
  )

  (func (export "tick")
    (local $row i32)
    (local $col i32)
    (local $cell_idx i32)
    (local $neighbor_row i32)
    (local $neighbor_col i32)
    (local $new_val i32)
    (local $cell_val i32)
    (local $live_neighbors i32)

    i32.const 0
    local.set $row

    loop $row_loop
      block $row_break
      
        i32.const 0
        local.set $col

        loop $col_loop
          block $col_break
            ;; get the current cell's index
            (call $get_cell_index (local.get $row) (local.get $col))
            local.set $cell_idx
            ;; see if the current cell is alive or dead
            (i32.load8_u (local.get $cell_idx))
            local.set $cell_val

            i32.const 0
            local.set $live_neighbors

            ;; check neighbors
            ;; top
            local.get $row
            i32.const 0 ;; avoid underflow
            i32.ne
            if
              (i32.sub (local.get $row) (i32.const 1))
              local.set $neighbor_row
              (i32.load8_u 
                (call $get_cell_index (local.get $neighbor_row) (local.get $col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; right
            local.get $col
            i32.const 1
            i32.add
            global.get $width ;; avoid overflow
            i32.lt_s
            if
              (local.set $neighbor_col
                (i32.add (i32.const 1) (local.get $col)))
              (i32.load8_u 
                (call $get_cell_index (local.get $row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; bottom
            local.get $row
            i32.const 1
            i32.add
            global.get $height ;; avoid overflow
            i32.lt_u
            if
              (local.set $neighbor_row 
                (i32.add (i32.const 1) (local.get $row)))
              (i32.load8_u 
                (call $get_cell_index (local.get $neighbor_row) (local.get $col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; left
            local.get $col
            i32.const 0 ;; avoid underflow
            i32.ne
            if
              (local.set $neighbor_col
                (i32.sub (local.get $col) (i32.const 1)))
              (i32.load8_u
                (call $get_cell_index (local.get $row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; bottom right
            local.get $col
            i32.const 1
            i32.add
            global.get $width
            i32.lt_s
            local.get $row
            i32.const 1
            i32.add
            global.get $height
            i32.lt_s
            i32.and
            if
              (local.set $neighbor_col
                (i32.add (i32.const 1) (local.get $col)))
              (local.set $neighbor_row
                (i32.add (i32.const 1) (local.get $row)))
              (i32.load8_u
                (call $get_cell_index (local.get $neighbor_row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; top right
            local.get $col
            i32.const 1
            i32.add
            global.get $width ;; avoid overflow
            i32.lt_s
            local.get $row
            i32.const 0
            i32.ne
            i32.and
            if
              (local.set $neighbor_col
                (i32.add (i32.const 1) (local.get $col)))
              (local.set $neighbor_row
                (i32.sub (local.get $row) (i32.const 1)))
              (i32.load8_u
                (call $get_cell_index (local.get $neighbor_row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; top left
            local.get $col
            i32.const 0
            i32.ne
            local.get $row
            i32.const 0
            i32.ne
            i32.and
            if
              (i32.sub (local.get $col) (i32.const 1))
              local.set $neighbor_col
              (i32.sub (local.get $row) (i32.const 1))
              local.set $neighbor_row
              (i32.load8_u
                (call $get_cell_index (local.get $neighbor_row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; bottom left
            local.get $col
            i32.const 0
            i32.ne
            local.get $row
            i32.const 1
            i32.add
            local.tee $neighbor_row
            global.get $height
            i32.lt_s
            i32.and
            if
              (local.set $neighbor_col
                (i32.sub (local.get $col) (i32.const 1)))
              (local.set $neighbor_row
                (i32.add (i32.const 1) (local.get $row)))
              (i32.load8_u
                (call $get_cell_index (local.get $neighbor_row) (local.get $neighbor_col)))
              i32.const 1
              i32.eq ;; is cell alive
              if
                local.get $live_neighbors
                i32.const 1
                i32.add
                local.set $live_neighbors
              end
            end

            ;; apply rules and set new value for cell
            (i32.eq (local.get $cell_val) (i32.const 1))
            if ;; live cell
              local.get $live_neighbors
              i32.const 2
              i32.eq
              local.get $live_neighbors
              i32.const 3
              i32.eq
              i32.or
              if ;; 2 or 3 live neighbors
                i32.const 1
                local.set $new_val
              else
                i32.const 0
                local.set $new_val
              end
            else ;; dead cell
              local.get $live_neighbors
              i32.const 3
              i32.eq
              if ;; 3 live neighbors
                i32.const 1
                local.set $new_val
              else
                i32.const 0
                local.set $new_val
              end
            end
            

            ;; set the memory value
            (i32.store8
              (call $get_temp_store_cell_index (local.get $row) (local.get $col))
              (local.get $new_val))

            ;; increment col
            local.get $col
            i32.const 1
            i32.add
            local.tee $col
            global.get $width
            i32.eq
            br_if $col_break
            br $col_loop
          end
        end

        ;; increment row
        local.get $row
        i32.const 1
        i32.add
        local.tee $row
        global.get $height
        i32.eq
        br_if $row_break
        br $row_loop
      end
    end

    ;; copy over page data to main memory
    i32.const 0
    local.set $row

    loop $row_loop
      block $row_break
      
        i32.const 0
        local.set $col

        loop $col_loop
          block $col_break
            ;; set the main memory value
            (i32.store8
              ;; get the real memory index
              (call $get_cell_index (local.get $row) (local.get $col))
              ;; get the temp memory value
              (i32.load8_u
                (call $get_temp_store_cell_index (local.get $row) (local.get $col)))
            )

            ;; increment col
            local.get $col
            i32.const 1
            i32.add
            local.tee $col
            global.get $width
            i32.eq
            br_if $col_break
            br $col_loop
          end
        end

        ;; increment row
        local.get $row
        i32.const 1
        i32.add
        local.tee $row
        global.get $height
        i32.eq
        br_if $row_break
        br $row_loop
      end
    end
  )

  (func (export "get_cell_start_index") (result i32)
    global.get $cells_index
  )

  (func (export "get_grid_height") (result i32)
    global.get $height
  )

  (func (export "set_grid_height") (param i32)
    local.get 0
    global.set $height
  )

  (func (export "get_grid_width") (result i32)
    global.get $width
  )

  (func (export "set_grid_width") (param i32)
    local.get 0
    global.set $width
  )
)