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

    float point_x;
    float point_y;

    points = new ArrayList<Point>();

    for (int i = 0; i < count; ++i) {
      point_x = random(cell_size) + (x * cell_size);
      point_y = random(cell_size) + (y * cell_size);
      points.add(new Point(point_x, point_y));
    }
  }

  int x;
  int y;

  ArrayList<Point> points;
}

enum DistFunc {
  EUCLID,
  TAXI,
  STAR,
  MAX,
  MEAN
}

class Grid {
  Grid(int w, int h, int cell_size, int point_count) {
    this.w = w;
    this.h = h;
    this.cell_size = cell_size;
    this.num_cells_x = this.w / this.cell_size;
    this.num_cells_y = this.h / this.cell_size;
    this.cell_count = this.num_cells_x * this.num_cells_y;

    println("Generating " + cell_count + " cells. " + num_cells_x + " x " + num_cells_y);
    cells = new Cell[cell_count];

    for (int cell_y = 0; cell_y < num_cells_y; ++cell_y) {
      for (int cell_x = 0; cell_x < num_cells_x; ++cell_x) {
        int index = (cell_y * num_cells_x) + cell_x;
        cells[index] = new Cell(cell_x, cell_y, cell_size, point_count);
      }
    }
  }

  float distance(float ax, float ay, float bx, float by, DistFunc f) {
    float d = 0;

    switch (f) {
      case EUCLID:
        d = dist(ax, ay, bx, by);
        break;
      case TAXI:
        d = abs(ax - bx) + abs(ay - by);
        break;
      case STAR:
        d = distance(ax, ay, bx, by, DistFunc.EUCLID);
        if (int(d) % 2 == 0) {
          d /= 2;
        } else {
          d *= 2;
        }
        break;
      case MAX:
        d = max(abs(ax - bx), abs(ay - by));
        break;
      case MEAN:
        float taxi = distance(ax, ay, bx, by, DistFunc.TAXI);
        float max = distance(ax, ay, bx, by, DistFunc.MAX);
        d = (taxi + max) / 2;
        break;
    }

    return d;
  }

  float[][] calcDistances(int order, DistFunc df) {
    int pixel_count = this.w * this.h;
    float[][] distances = new float[pixel_count][order];

    for (int y = 0; y < this.h; ++y) {
      for (int x = 0; x < this.w; ++x) {
        int index = (y * this.w) + x;

        ArrayList<Point> points = this.getPoints(x, y);

        float[] tmp_dist = new float[points.size()];
        for (int i = 0; i < points.size(); ++i) {
          Point p = points.get(i);
          float d = distance(x, y, p.x, p.y, df);
          tmp_dist[i] = d;
        }

        float[] sorted = sort(tmp_dist);
        distances[index] = new float[order];
        for (int i = 0; i < order; ++i) {
          float f = sorted[i];
          distances[index][i] = f;
        }
      }
    }

    return distances;
  }

  ArrayList<Cell> getCells(int x, int y) {
    int cell_x = int(x / this.cell_size);
    int cell_y = int(y / this.cell_size);

    ArrayList<Cell> neighbours = new ArrayList<Cell>();

    int index;
    index = (cell_y * this.num_cells_x) + cell_x;
    neighbours.add(this.cells[index]);

    boolean is_top = (cell_y == 0);
    boolean is_bottom = (cell_y == (num_cells_y - 1));
    boolean is_left = (cell_x == 0);
    boolean is_right = (cell_x == (num_cells_x - 1));

    if (!is_top) {
      index = ((cell_y - 1) * this.num_cells_x) + (cell_x);
      neighbours.add(this.cells[index]);

      if (!is_left) {
        index = ((cell_y - 1) * this.num_cells_x) + (cell_x - 1);
        neighbours.add(this.cells[index]);
      }
      if (!is_right) {
        index = ((cell_y - 1) * this.num_cells_x) + (cell_x + 1);
        neighbours.add(this.cells[index]);
      }
    }

    if (!is_left) {
      index = ((cell_y) * this.num_cells_x) + (cell_x - 1);
      neighbours.add(this.cells[index]);
    }
    if (!is_right) {
      index = ((cell_y) * this.num_cells_x) + (cell_x + 1);
      neighbours.add(this.cells[index]);
    }

    if (!is_bottom) {
      index = ((cell_y + 1) * this.num_cells_x) + (cell_x);
      neighbours.add(this.cells[index]);

      if (!is_left) {
        index = ((cell_y + 1) * this.num_cells_x) + (cell_x - 1);
        neighbours.add(this.cells[index]);
      }
      if (!is_right) {
        index = ((cell_y + 1) * this.num_cells_x) + (cell_x + 1);
        neighbours.add(this.cells[index]);
      }
    }

    return neighbours;
  }

  ArrayList<Point> getPoints(int x, int y) {
    ArrayList<Cell> neighbours = this.getCells(x, y);
    ArrayList<Point> points = new ArrayList<Point>();

    for (int i = 0; i < neighbours.size(); ++i) {
      Cell n = neighbours.get(i);
      points.addAll(n.points);
    }

    return points;
  }

  int w;
  int h;
  int cell_size;
  int num_cells_x;
  int num_cells_y;
  int cell_count;

  Cell[] cells;
}
