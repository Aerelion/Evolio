class Connection {
  float weight;
  int in, out;
  float l;
  
  Connection(int i, int o, float w, float l_) {
    in = i;
    out = o;
    weight = w;
    l = l_;
  }
}