int cell_size = 128;
PVector[] points_vec;
float[] distances;


Grid grid;

void setup() {
  size(512, 512);
  grid = new Grid(width, height, cell_size);

  Point[] points = new Point[grid.cells.length];
  for (int i = 0; i < grid.cells.length; ++i) {
    points[i] = grid.cells[i].points[0];
  }

  distances = calcDistances(width, height, points);
}

void draw() {
  noLoop();

  loadPixels();
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      int index = (y * width) + x;
      pixels[index] = color(map(distances[index], 0, cell_size, 0, 255));
    }
  }
  updatePixels();

  // draw reference grid for debug
  strokeWeight(1);
  int num_cells_x = width / cell_size;
  int num_cells_y = height / cell_size;

  for (int cell_x = 0; cell_x < num_cells_x; ++cell_x) {
    int x = cell_x * cell_size;
    line(x, 0, x, height);
  }
  for (int cell_y = 0; cell_y < num_cells_y; ++cell_y) {
    int y = cell_y * cell_size;
    line(0, y, width, y);
  }
  // end debug
}


void keyPressed() {
  if (key == 's') {
    save("screenshot.png");
  }
}

void mouseClicked() {
  Cell c = grid.getCell(mouseX, mouseY);
  println(c.x, c.y);
  Point p = c.points[0];
  println(p.x, p.y);
}
