PVector[] genPoints(int w, int h, int cell_size) {
  int num_cells_x = w / cell_size;
  int num_cells_y = h / cell_size;
  int cell_count = num_cells_x * num_cells_y;

  println("Generating " + cell_count + " cells. " + num_cells_x + " x " + num_cells_y);
  PVector[] points = new PVector[cell_count];

  for (int cell_y = 0; cell_y < num_cells_y; ++cell_y) {
    for (int cell_x = 0; cell_x < num_cells_x; ++cell_x) {
      float x = random(cell_size) + (cell_x * cell_size);
      float y = random(cell_size) + (cell_y * cell_size);

      int index = (cell_y * num_cells_x) + cell_x;
      points[index] = new PVector(x, y);
    }
  }

  return points;
}
