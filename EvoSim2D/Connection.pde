class Connection {
  float weight;
  int in, out;
  
  Connection(int i, int o, float w) {
    in = i;
    out = o;
    weight = w;
  }
}