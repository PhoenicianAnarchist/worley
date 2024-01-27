class Point {
  Point(PVector p) {
    this.position = p;
    this.weight = 1.0;
  }

  PVector position;
  float weight;
}

class Cell {
  Cell(PVector position, int cell_size, int count) {
    this.position = position;

    points = new ArrayList<Point>();
    for (int i = 0; i < count; ++i) {
      PVector p = new PVector(
        random(cell_size) + (position.x * cell_size),
        random(cell_size) + (position.y * cell_size),
        random(cell_size) + (position.z * cell_size)
      );

      points.add(new Point(p));
    }
  }

  PVector position;

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
  Grid(PVector dimensions, int cell_size, int point_count) {
    this.dimensions = dimensions;
    this.cell_size = cell_size;
    this.num_cells = new PVector(
      int(this.dimensions.x / this.cell_size),
      int(this.dimensions.y / this.cell_size),
      int(this.dimensions.z / this.cell_size)
    );

    int cell_count = int(this.num_cells.x * this.num_cells.y * this.num_cells.z);
    println("Generating " + cell_count + " cells. " + this.num_cells.x + " x " + this.num_cells.y + " x " + this.num_cells.z);
    cells = new Cell[cell_count];

    int layer_cell_count = int(this.num_cells.x * this.num_cells.y);
    for (int cell_z = 0; cell_z < this.num_cells.z; ++cell_z) {
      int layer_offset = cell_z * layer_cell_count;

      for (int cell_y = 0; cell_y < this.num_cells.y; ++cell_y) {
        int row_offset = cell_y * int(this.num_cells.x);

        for (int cell_x = 0; cell_x < this.num_cells.x; ++cell_x) {
          int cell_index = layer_offset + row_offset + cell_x;

          PVector p = new PVector(cell_x, cell_y, cell_z);
          cells[cell_index] = new Cell(p, cell_size, point_count);
        }
      }
    }
  }

  float distance(PVector a, PVector b, DistFunc f) {
    float d = 0;

    switch (f) {
      case EUCLID:
        d = dist(a.x, a.y, a.z, b.x, b.y, b.z);
        break;
      case TAXI:
        d = abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z);
        break;
      case STAR:
        d = distance(a, b, DistFunc.EUCLID);
        if (int(d) % 2 == 0) {
          d /= 2;
        } else {
          d *= 2;
        }
        break;
      case MAX:
        d = max(abs(a.x - b.x), abs(a.y - b.y), abs(a.z - b.z));
        break;
      case MEAN:
        float taxi = distance(a, b, DistFunc.TAXI);
        float max = distance(a, b, DistFunc.MAX);
        d = (taxi + max) / 2;
        break;
    }

    return d;
  }

  float[][] calcDistances(int order, DistFunc df) {
    int pixel_count = int(this.dimensions.x * this.dimensions.y * this.dimensions.z);
    float[][] distances = new float[pixel_count][order];

    int layer_cell_count = int(this.dimensions.x * this.dimensions.y);

    for (int z = 0; z < this.dimensions.z; ++z) {
      int layer_offset = z * layer_cell_count;

      for (int y = 0; y < this.dimensions.y; ++y) {
        int row_offset  = y * int(this.dimensions.x);

        for (int x = 0; x < this.dimensions.x; ++x) {
          int cell_index = layer_offset + row_offset + x;

          ArrayList<Point> points = this.getPoints(new PVector(x, y, z));

          float[] tmp_dist = new float[points.size()];
          for (int i = 0; i < points.size(); ++i) {
            Point p = points.get(i);
            float d = distance(new PVector(x, y, z), p.position, df);
            tmp_dist[i] = d;
          }

          float[] sorted = sort(tmp_dist);
          for (int i = 0; i < order; ++i) {
            float f = sorted[i];
            distances[cell_index][i] = f;
          }
        }
      }
    }

    return distances;
  }

  ArrayList<Integer> getIndices(PVector pos, PVector bounds) {
    ArrayList<Integer> indices = new ArrayList<Integer>();

    int lower   = (pos.z == 0)              ? 0 : -1;
    int upper   = (pos.z == (bounds.z - 1)) ? 0 :  1;
    int top     = (pos.y == 0)              ? 0 : -1;
    int bottom  = (pos.y == (bounds.y - 1)) ? 0 :  1;
    int left    = (pos.x == 0)              ? 0 : -1;
    int right   = (pos.x == (bounds.x - 1)) ? 0 :  1;

    int layer_cell_count = int(bounds.x * bounds.y);

    for (int k = lower; k <= upper; ++k) {
      int layer_offset = (int(pos.z) + k) * layer_cell_count;

      for (int j = top; j <= bottom; ++j) {
        int row_offset = (int(pos.y) + j) * int(bounds.x);

        for (int i = left; i <= right; ++i) {
          indices.add(layer_offset + row_offset + int(pos.x + i));
        }
      }
    }

    return indices;
  }

  ArrayList<Cell> getCells(PVector pos) {
    PVector cell_pos = new PVector(
      int(pos.x / this.cell_size),
      int(pos.y / this.cell_size),
      int(pos.z / this.cell_size)
    );

    ArrayList<Integer> indices = getIndices(cell_pos, this.num_cells);

    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    for (int i : indices) {
      neighbours.add(this.cells[i]);
    }

    return neighbours;
  }

  ArrayList<Point> getPoints(PVector pos) {
    ArrayList<Cell> neighbours = this.getCells(pos);
    ArrayList<Point> points = new ArrayList<Point>();

    for (int i = 0; i < neighbours.size(); ++i) {
      Cell n = neighbours.get(i);
      points.addAll(n.points);
    }

    return points;
  }

  PVector dimensions;
  PVector num_cells;
  int cell_size;
  Cell[] cells;
}
