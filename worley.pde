PVector[] points_vec;
float[][] distances_r;
float[][] distances_g;
float[][] distances_b;

int cell_size;
int point_count;
int order;
Grid grid_r;
Grid grid_g;
Grid grid_b;

void setup() {
  cell_size = 64;
  point_count = 1;
  order = 1;

  size(512, 512);
  grid_r = new Grid(width, height, cell_size, point_count);
  distances_r = grid_r.calcDistances(4);
  grid_g = new Grid(width, height, cell_size, point_count);
  distances_g = grid_g.calcDistances(4);
  grid_b = new Grid(width, height, cell_size, point_count);
  distances_b = grid_b.calcDistances(4);
}

void draw() {
  loadPixels();
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      int index = (y * width) + x;

      float r = map(distances_r[index][order - 1], 0, cell_size * order, 0, 127);
      float g = map(distances_g[index][order - 1], 0, cell_size * order, 0, 127);
      float b = map(distances_b[index][order - 1], 0, cell_size * order, 0, 255);

      pixels[index] = color(r, g, b);
    }
  }
  updatePixels();

  // draw reference grid for debug
  // strokeWeight(1);
  // int num_cells_x = width / cell_size;
  // int num_cells_y = height / cell_size;
  //
  // for (int cell_x = 0; cell_x < num_cells_x; ++cell_x) {
  //   int x = cell_x * cell_size;
  //   line(x, 0, x, height);
  // }
  // for (int cell_y = 0; cell_y < num_cells_y; ++cell_y) {
  //   int y = cell_y * cell_size;
  //   line(0, y, width, y);
  // }
  // end debug
}


void keyPressed() {
  if (key == 's') {
    save("screenshot.png");
  } else if (key == '1') {
    order = 1;
  } else if (key == '2') {
    order = 2;
  } else if (key == '3') {
    order = 3;
  } else if (key == '4') {
    order = 4;
  }
}
