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
        random(cell_size) + (position.y * cell_size)
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
      int(this.dimensions.y / this.cell_size)
    );

    int cell_count = int(this.num_cells.x * this.num_cells.y);
    println("Generating " + cell_count + " cells. " + this.num_cells.x + " x " + this.num_cells.y);
    cells = new Cell[cell_count];

    for (int cell_y = 0; cell_y < this.num_cells.y; ++cell_y) {
      int row_offset = int(cell_y * num_cells.x);

      for (int cell_x = 0; cell_x < this.num_cells.x; ++cell_x) {
        int cell_index = row_offset + cell_x;

        PVector p = new PVector(cell_x, cell_y);
        cells[cell_index] = new Cell(p, cell_size, point_count);
      }
    }
  }

  float distance(PVector a, PVector b, DistFunc f) {
    float d = 0;

    switch (f) {
      case EUCLID:
        d = dist(a.x, a.y, b.x, b.y);
        break;
      case TAXI:
        d = abs(a.x - b.x) + abs(a.y - b.y);
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
        d = max(abs(a.x - b.x), abs(a.y - b.y));
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
    int pixel_count = int(this.dimensions.x * this.dimensions.y);
    float[][] distances = new float[pixel_count][order];

    for (int y = 0; y < this.dimensions.y; ++y) {
      int row_offset  = int(y * this.dimensions.x);

      for (int x = 0; x < this.dimensions.x; ++x) {
        int cell_index = row_offset + x;

        ArrayList<Point> points = this.getPoints(x, y);

        float[] tmp_dist = new float[points.size()];
        for (int i = 0; i < points.size(); ++i) {
          Point p = points.get(i);
          float d = distance(new PVector(x, y), p.position, df);
          tmp_dist[i] = d;
        }

        float[] sorted = sort(tmp_dist);
        distances[cell_index] = new float[order];
        for (int i = 0; i < order; ++i) {
          float f = sorted[i];
          distances[cell_index][i] = f;
        }
      }
    }

    return distances;
  }

  ArrayList<Integer> getIndices(PVector pos, PVector bounds) {
    ArrayList<Integer> indices = new ArrayList<Integer>();

    int top     = (pos.y == 0)              ? 0 : -1;
    int bottom  = (pos.y == (bounds.y - 1)) ? 0 :  1;
    int left    = (pos.x == 0)              ? 0 : -1;
    int right   = (pos.x == (bounds.x - 1)) ? 0 :  1;

    for (int i = top; i <= bottom; ++i) {
      int row_offset = int((pos.y + i) * bounds.x);

      for (int j = left; j <= right; ++j) {
        indices.add(row_offset + int(pos.x + j));
      }
    }

    return indices;
  }

  ArrayList<Cell> getCells(int x, int y) {
    PVector cell_pos = new PVector(
      int(x / this.cell_size),
      int(y / this.cell_size)
    );

    ArrayList<Integer> indices = getIndices(cell_pos, this.num_cells);

    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    for (int i : indices) {
      neighbours.add(this.cells[i]);
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

  PVector dimensions;
  PVector num_cells;
  int cell_size;
  Cell[] cells;
}
