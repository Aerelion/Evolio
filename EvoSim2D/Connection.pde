class Connection {
  float weight;
  boolean excited = false;
  int in, out;
  int layer;
  
  Connection(int i, int o) {
    in = i;
    out = o;
    layer = int( float(i) / 20.0);
  }
  
  void reset() {
    excited = false;
  }
}