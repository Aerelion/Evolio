class Neuron {
  String type = "hid";
  float val;
  int label;
  int layer;
  
  Neuron(String t_, int nr) {
    if (t_.equals("in") || t_.equals("hid") || t_.equals("out")) {
      type = t_;
    }
    label = nr;
    layer = int( float(nr) / 20.0);
  }
  
  void update() {
  }
  
  void setVal(float input) {
    val = input;
  }
  
  void addVal(float input) {
    val = val + input;
  }
}