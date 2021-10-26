// store cell in memory and just loop through and 0 is dead and 1 is alive
// one page should be plenty
const memory = new WebAssembly.Memory({initial: 1}); 

const importObject = {
  env: {
    memory: memory
  }
};

const module = (async () => {
  const fetchPromise = fetch('gol.wasm');
  const { instance } = await WebAssembly.instantiateStreaming(fetchPromise, importObject);
  return instance.exports;
});

const CELL_SIZE = 6;
const DEAD = 0;
const ALIVE = 1;
const GRID_COLOR = "#CCCCCC";
const DEAD_COLOR = "#FFFFFF";
const ALIVE_COLOR = "#000000";

const initCanvas = (height, width) => {
  const canvas = document.getElementById("game-of-life-canvas");
  canvas.height = (CELL_SIZE + 1) * height + 1;
  canvas.width = (CELL_SIZE + 1) * width + 1;

  return canvas.getContext('2d');
}

const drawGrid = (ctx, height, width) => {
  ctx.beginPath();
  ctx.strokeStyle = GRID_COLOR;

  // vert
  for (let i = 0; i <= width; i++) {
    ctx.moveTo(i * (CELL_SIZE + 1) + 1, 0);
    ctx.lineTo(i * (CELL_SIZE + 1) + 1, (CELL_SIZE + 1) * height + 1);
  }

  // horiz
  for (let j = 0; j <= height; j++) {
    ctx.moveTo(0, j * (CELL_SIZE + 1) + 1);
    ctx.lineTo((CELL_SIZE + 1) * width + 1, j * (CELL_SIZE + 1) + 1);
  }

  ctx.stroke();
}

const getIndex = (row, column, width) => {
  return row * width + column;
}

const drawCells = (ctx, cellsPtr, height, width) => {
  const cells = new Uint8Array(memory.buffer, cellsPtr, width * height);
  ctx.beginPath();

  for (let row = 0; row < height; row++) {
    for (let col = 0; col < width; col++) {
      const idx = getIndex(row, col, width);

      ctx.fillStyle = cells[idx] === DEAD
        ? DEAD_COLOR
        : ALIVE_COLOR;
      
      ctx.fillRect(
        col * (CELL_SIZE + 1) + 1,
        row * (CELL_SIZE + 1) + 1,
        CELL_SIZE,
        CELL_SIZE
      );
    }
  }
  
  ctx.stroke();
}

const inpt = document.getElementById('num-input');

const executeGame = () => {
  module().then(
      wasmExports => {
        inpt.value = wasmExports.get_grid_height();

        wasmExports.init_cells();
        let height = wasmExports.get_grid_height();
        let width = wasmExports.get_grid_width();

        const cellsStartPtr = wasmExports.get_cell_start_index();

        let canvasContext = initCanvas(height, width);

        inpt.addEventListener('change', e => {
          const val = parseInt(e.target.value);
          if (val <= 0 || val > 500) {
            return;
          }
          wasmExports.set_grid_height(val);
          wasmExports.set_grid_width(val);
          height = wasmExports.get_grid_height();
          width = wasmExports.get_grid_width();
          canvasContext = initCanvas(height, width);
          drawGrid(canvasContext, height, width);
          drawCells(canvasContext, cellsStartPtr, height, width);
        });

        let fpsOut = 0;
        let lastLoop = new Date();
        const renderLoop = () => {
          // super jank fps
          let thisLoop = new Date();
          let fps = 1000 / (thisLoop - lastLoop);
          fpsOut += fps / 30;
          lastLoop = thisLoop;

          // these may change from one render to another
          let height = wasmExports.get_grid_height();
          let width = wasmExports.get_grid_width();

          wasmExports.tick();
          drawGrid(canvasContext, height, width);
          drawCells(canvasContext, cellsStartPtr, height, width);

          setTimeout(() => {
            requestAnimationFrame(renderLoop);
          }, 50);
        };

        setInterval(() => {
          document.getElementById('fps').innerText = fpsOut.toFixed(2);
          fpsOut = 0;
        }, 500);

        drawGrid(canvasContext, height, width);
        drawCells(canvasContext, cellsStartPtr, height, width);
        addEventListener('click', () => requestAnimationFrame(renderLoop));
        //requestAnimationFrame(renderLoop);
      }
  );
}

addEventListener('DOMContentLoaded', executeGame);
