class Point {
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float x;
  float y;
}

class Cell {
  Cell(int x, int y, int cell_size, int count) {
    this.x = x;
    this.y = y;

    float point_x = random(cell_size) + (x * cell_size);
    float point_y = random(cell_size) + (y * cell_size);

    points = new Point[count];

    for (int i = 0; i < count; ++i) {
      points[i] = new Point(point_x, point_y);
    }
  }

  int x;
  int y;

  Point[] points;
}

class Grid {
  Grid(int w, int h, int cell_size) {
    this.cell_size = cell_size;
    this.num_cells_x = w / this.cell_size;
    this.num_cells_y = h / this.cell_size;
    this.cell_count = this.num_cells_x * this.num_cells_y;

    println("Generating " + cell_count + " cells. " + num_cells_x + " x " + num_cells_y);
    cells = new Cell[cell_count];

    for (int cell_y = 0; cell_y < num_cells_y; ++cell_y) {
      for (int cell_x = 0; cell_x < num_cells_x; ++cell_x) {
        int index = (cell_y * num_cells_x) + cell_x;
        cells[index] = new Cell(cell_x, cell_y, cell_size, 1);
      }
    }
  }

  Cell getCell(int x, int y) {
    int cell_x = int(x / this.cell_size);
    int cell_y = int(y / this.cell_size);
    int index = (cell_y * this.num_cells_x) + cell_x;
    return cells[index];
  }

  int cell_size;
  int num_cells_x;
  int num_cells_y;
  int cell_count;

  Cell[] cells;
}
