PVector[] points_vec;
float[][] distances;

PVector cell_counts;
int cell_size;
int point_count;
int order;
int depth;
Grid grid;

void setup() {
  randomSeed(0);
  size(64, 64);

  cell_counts = new PVector(8, 8, 8);
  cell_size = 16;
  point_count = 1;
  order = 1;

  int w = int(cell_counts.x) * cell_size;
  int h = int(cell_counts.y) * cell_size;
  depth = int(cell_counts.z) * cell_size;

  windowResize(w, h);
  PVector ws = new PVector(width, height, depth);
  grid = new Grid(ws, cell_size, point_count);

  float start = millis();
  distances = grid.calcDistances(2, DistFunc.EUCLID);
  float end = millis();
  float elapsed = end - start;
  println("Processed in " + elapsed + " milliseconds.");
}

void draw() {
  loadPixels();
  int slice_pixel_count = width * height;

  for (int y = 0; y < height; ++y) {
    int row_offset = (y * width);
    for (int x = 0; x < width; ++x) {
      int pixel_index = row_offset + x;
      int slice_index = (int(frameCount / 4) % depth) * slice_pixel_count;

      float c = distances[slice_index + pixel_index][order - 1];

      pixels[pixel_index] = color(map(c, 0, cell_size * order * 1.4, 0, 255));
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
  }
}
