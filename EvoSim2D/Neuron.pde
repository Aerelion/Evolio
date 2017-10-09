class Neuron {
  String type = "hid";
  
  Neuron(String t_) {
    if (t_.equals("in") || t_.equals("hid") || t_.equals("out")) {
      type = t_;
    }
    
  }
  
}