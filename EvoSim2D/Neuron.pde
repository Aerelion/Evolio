class Neuron {
  String type = "hid";
  float sum;
  float val;
  int label;
  int x,y;
  
  float sigmoid(float x) {
    float res = 1.0 / ( 1.0 + exp(-x));
    
    return res;
  }
  
  Neuron(String t_, int x_, int y_) {
    if (t_.equals("in") || t_.equals("hid") || t_.equals("out")) {
      type = t_;
    }
    x = x_; y = y_;
    
    if (type.equals("in")) {
      val = 1;
    } else {
      val = 0;
      sum = 0;
    }
  }
  
  void update() {
    //sigmoid
    
    if (type.equals("in") == false) {
      val = sigmoid(sum);
      sum = 0;
    }
  }
  
  void setVal(float input) {
    val = input;
  }
  
  void addToSum(float input) {
    sum += input;
  }
}