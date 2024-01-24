float[] calcDistances(int w, int h, PVector[] points) {
  int pixel_count = w * h;
  float[] distances = new float[pixel_count];

  for (int y = 0; y < h; ++y) {
    for (int x = 0; x < w; ++x) {
      int index = (y * w) + x;

      float[] tmp_dist = new float[points.length];
      for (int i = 0; i < points.length; ++i) {
        PVector p = points[i];
        float d = dist(x, y, p.x, p.y);
        tmp_dist[i] = d;
      }

      float[] sorted = sort(tmp_dist);
      distances[index] = sorted[0];
    }
  }

  return distances;
}
