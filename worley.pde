PVector[] points_vec;
float[][] distances;

int cell_size;
int point_count;
int order;
Grid grid;

void setup() {
  randomSeed(0);
  cell_size = 64;
  point_count = 1;
  order = 1;

  size(512, 512);
  PVector ws = new PVector(width, height);
  grid = new Grid(ws, cell_size, point_count);

  float start = millis();
  distances = grid.calcDistances(4, DistFunc.EUCLID);
  float end = millis();
  float elapsed = end - start;
  println("Processed in " + elapsed + " milliseconds.");
}

void draw() {
  loadPixels();
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      int index = (y * width) + x;

      float c = distances[index][order - 1];
      pixels[index] = color(map(c, 0, cell_size * order, 0, 255));
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
