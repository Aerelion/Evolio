class Brain {
  Body sensor;
  ArrayList<Neuron> neurons = new ArrayList<Neuron>();
  ArrayList<Connection> connections = new ArrayList<Connection>();
  
  int inputs = sensors;
  int outputs = controls;
  
  Brain(Body temp) {
    sensor = temp;
    for (int n = 0; n < inputs; n++) {
      neurons.add(new Neuron("in", n));
    }
    for (int n = inputs; n < inputs+outputs; n++) {
      neurons.add(new Neuron("out", n));
    }
  }
  
  void addNeuron(int nr) {
    neurons.add(new Neuron("hid", nr));
  }
  
  void update() {
    
    for (Connection c : connections) {
      
    }
  }
  
  float type() { // Checks food type
    float res = world.map[int(sensor.y / worldSize)][int(sensor.x / worldSize)][0];
    
    return res;
  }
  
  float[] nearby() { // Checks closest creature (1 means close, 0 means out of range) in all 4 directions
    float[] res = new float[4];
    
    return res;
  }
  
  float food() { // Checks food amount
    float res = world.map[int(sensor.y / worldSize)][int(sensor.x / worldSize)][2] / 360;
    
    return res;
  }
  
  float water() { // Checks water
    if (world.map[int(sensor.y / worldSize)][int(sensor.x / worldSize)][2] == -1) {
      return 1;
    } else {
      return 0;
    }
  }
}