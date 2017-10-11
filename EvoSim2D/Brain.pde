class Brain {
  Body sensor;
  
  Connection[] connections;
  Neuron[] neurons;
  
  int inputs = sensors;
  int outputs = controls;
  
  Brain(Body temp, int hiddens, int cs) {
    sensor = temp;
    neurons = new Neuron[inputs+outputs+hiddens];
    connections = new Connection[cs];
    for (int n = 0; n < inputs; n++) {
      neurons[n] = new Neuron("in", 0, n);
    }
    for (int n = inputs; n < inputs+outputs; n++) {
      neurons[n] = new Neuron("out", 20, n-inputs);
    }
  }
  
  void update() {
    /*/ Update order:
         - Inputs
         - Connections
         - Hidden nodes & outputs
         - Outputs -> controller
    /*/
    // Inputs:
    neurons[0].setVal(type()); // Ground color
    neurons[1].setVal(float(sensor.hue) / 360.0); // Creature color
    neurons[2].setVal(food()); // Food amount
    neurons[3].setVal(sensor.energy / 100.0); // Energy amount
    float[] ner = nearby();
    for (int n = 0; n < 4; n++) {
      neurons[4+n].setVal(ner[n]); // Nearby things
    } // 4, 5, 6, 7
    neurons[8].setVal(water()); // Water?
    //9(10) is bias (always 1)
    
    // Connection updates
    for (int c = 0; c < connections.length; c++) {
      int home = connections[c].in;
      int dest = connections[c].out;
      float val = neurons[home].val;
      float w = connections[c].weight;
      neurons[dest].addToSum(val * w);
    }
    
    for (int n = 0; n < neurons.length; n++) {
      neurons[n].update();
    }
    // Node activation phase
    
  } // End of update
  
  void addNeuron(int nr, Neuron n) {
    neurons[nr + inputs+outputs] = n;
  }
  
  void addConnection(int nr, Connection c) {
    connections[nr] = c;
  }
  
  void createNeuron(String t, int nr) {
    int xN = int(random(1,20));
    int yN = int(random(1,inputs));
    boolean free = false;
    while (free == false) {
      free = true;
      for (int n = 0; n < nr; n++) {
        int xO = neurons[n].x;
        int yO = neurons[n].y;
        while (xN == xO && yN == yO) {
          if (xN == xO) { xN = int(random(1,inputs)); }
          if (yN == yO) { yN = int(random(1,inputs)); }
          free = false;
        }
      }
    }
    Neuron n = new Neuron(t, xN, yN);
    neurons[nr] = n;
  }
  
  void createConnection(int nr) {
    int home = int( random(0, neurons.length - outputs));
    int dest = int( random(inputs, neurons.length));
    Connection c = new Connection(home, dest, random(-1,1));
    connections[nr] = c;
  }
  
  float type() { // Checks food type
    float res = float(world.map[int(sensor.y / worldSize)][int(sensor.x / worldSize)][0]) / 360.0;
    
    return res;
  }
  
  float[] nearby() { // Checks closest creature (1 means close, 0 means out of range) in all 4 directions
    float[] res = new float[4];
    res[0] = 1;
    res[1] = 0.5;
    res[2] = 0.1;
    res[3] = 1;
    return res;
  }
  
  float food() { // Checks food amount
    float res = float(world.map[int(sensor.y / float(worldSize))][int(sensor.x / float(worldSize))][2]) / 360.0;
    if (res < 0) {
      res = 0;
    }
    return res;
  }
  
  float water() { // Checks water
    if (world.map[int(sensor.y / float(worldSize))][int(sensor.x / float(worldSize))][2] == -1) {
      return 1;
    } else {
      return 0;
    }
  }
  
  void display() {
    int xOffset = 15;
    int yOffset = 18;
    stroke(0);
    for (int n = 0; n < neurons.length; n++) {
      fill(neurons[n].val * 360);
      ellipse(screenSize + neurons[n].y*yOffset + 10, neurons[n].x*xOffset + 20, 8, 8);
      fill(0);
      text(str(neurons[n].val), screenSize + neurons[n].y*yOffset + 10, neurons[n].x*xOffset + 40);
    }
    
    for (int c = 0; c < connections.length; c++) {
      float w_ = connections[c].weight;
      if (w_ > 0) {
        stroke(90, 360, 60 + 300 * w_);
      } else if (w_ < 0) {
        stroke(0, 360, 60 + (-300 * w_));
      } else {
        stroke(255);
      }
      line(screenSize + neurons[connections[c].in].y*yOffset + 10, neurons[connections[c].in].x*xOffset + 20, screenSize + neurons[connections[c].out].y*yOffset + 10, neurons[connections[c].out].x*xOffset + 20);
    }
    
    stroke(0);
    text(str(neurons[2].val) + " - " + str(neurons[8].val), screenSize + 50, 20*yOffset + 50);
  } // End of display
}