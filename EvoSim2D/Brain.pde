class Brain {
  Body sensor;
  
  Connection[] connections;
  Neuron[] neurons;
  
  int inputs = sensors;
  int outputs = controls;
  
  float totalLength = 0;
  
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
    
    // Neuron activation
    for (int n = 0; n < neurons.length; n++) {
      neurons[n].update();
    }
    
    // Forwarding output node values to controller
    
  } // End of update
  
  boolean[] state() { // Returns current state of output nodes
    boolean[] res = new boolean[outputs];
    for (int n = 0; n < outputs; n++) {
      if (neurons[n+inputs].val > 0.5) {
        res[n] = true;
      } else {
        res[n] = false;
      }
    }
    return res;
  } // End of state
  
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
          if (xN == xO) { xN = int(random(1,20)); }
          if (yN == yO) { yN = int(random(1,inputs)); }
          free = false;
        }
      }
    }
    Neuron n = new Neuron(t, xN, yN);
    neurons[nr] = n;
  }
  
  void createConnection(int nr) {
    int home = 0;
    int dest = 0;
    while (home == dest) {
      if (random(0,neurons.length-outputs) < inputs) {
        home = int( random(0, inputs));
      } else {
        home = int( random(inputs + outputs, neurons.length));
      }
      dest = int( random(inputs, neurons.length));
    }
    float l = sqrt(pow(neurons[home].x - neurons[dest].x, 2) + pow(neurons[home].y - neurons[dest].y, 2));
    totalLength += l;
    Connection c = new Connection(home, dest, random(-1,1), l);
    connections[nr] = c;
  }
  
  float type() { // Checks food type
    float res = float(world.map[int(sensor.y / ratio)][int(sensor.x / ratio)][0]) / 360.0;
    
    return res;
  }
  
  float[] nearby() { // Checks closest creature (1 means close, 0 means out of range) in all 4 directions
    float[] res = new float[4];
    int range = 3;
    
    if (world.creatureList.get(int(sensor.y / ratio) * worldSize + int(sensor.x / ratio)).size() > 1) {
      res[0] = 1; res[1] = 1; res[2] = 1; res[3] = 1;
    } else {
      
      float dist = range * range * ratio;
      float gX = 0;
      float gY = 0;
      
      for (int r = 1; r <= range; r++) {
        ArrayList<Creature> temp = new ArrayList<Creature>();
        
        for (int y = -r; y <= r; y++) {
          int yTile = int(sensor.y / ratio) + y;
          if (yTile >= 0 && yTile < worldSize) {
            for (int x = -r; x <= r; x++) {
              int xTile = int(sensor.x / ratio) + x;
              if (xTile >= 0 && xTile < worldSize) {
                ArrayList<Creature> tile = world.creatureList.get(yTile * worldSize + xTile);
                if (tile.size() > 0 && (x == 0 && y == 0) == false) {
                  for (Creature c : tile) {
                    temp.add(c);
                  }
                }
              }
            }
          }
        } // End of creature search loop
        
        for (int c = 0; c < temp.size(); c++) {
          float tempDist = sqrt(pow(temp.get(c).body.x-sensor.x, 2) + pow(temp.get(c).body.y-sensor.y, 2));
          if (tempDist < dist) {
            dist = tempDist;
            gX = temp.get(c).body.x - sensor.x;
            gY = temp.get(c).body.y - sensor.y;
          }
        }
        
        if (temp.size() > 0) {
          r = range+1;
        }
        
      } // End of range loop
      
      if (gX > 0) {
        res[0] = map(gX, 0, (range+1) * ratio, 1, 0);
        res[1] = 0;
      } else if (gX < 0) {
        res[0] = 0;
        res[1] = map(gX, (range+1) * -ratio, 0, 0, 1);
      } else {
        res[0] = 0;
        res[1] = 0;
      }
      if (gY > 0) {
        res[2] = map(gY, 0, (range+1) * ratio, 1, 0);
        res[3] = 0;
      } else if (gY < 0) {
        res[2] = 0;
        res[3] = map(gY, (range+1) * -ratio, 0, 0, 1);
      } else {
        res[2] = 0;
        res[3] = 0;
      }
    }
    
    return res;
  }
  
  float food() { // Checks food amount
    float res = float(world.map[int(sensor.y / ratio)][int(sensor.x / ratio)][2]) / 3600.0;
    if (res < 0) {
      res = 0;
    }
    return res;
  }
  
  float water() { // Checks water
    if (world.map[int(sensor.y / ratio)][int(sensor.x / ratio)][2] == -1) {
      return 1;
    } else {
      return 0;
    }
  }
  
  void display() {
    int xOffset = 15;
    int yOffset = 18;
    
    stroke(0, 360, 360);
    fill(0, 360, 360);
    ellipse(sensor.x, sensor.y, 10, 10);
    
    for (int n = 0; n < neurons.length; n++) {
      fill(neurons[n].val * 360);
      if (neurons[n].val > 0.5) {
        stroke(90, 360, 360);
      } else {
        stroke(0, 360, 360);
      }
      ellipse(screenSize + neurons[n].y*yOffset + 10, neurons[n].x*xOffset + 20, 8, 8);
      fill(0);
      text(str(n), screenSize + neurons[n].y * yOffset + 8, neurons[n].x * xOffset + 35);
      //text(str(float(round(neurons[n].val*100.0)) / 100.0), screenSize + neurons[n].y*yOffset + 8, neurons[n].x*xOffset + 35);
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
      text("Nr: " + str(c) + ", from " + str(connections[c].in) + " to " + str(connections[c].out) + ". With length: " + str(float(round(connections[c].l*10))/10), screenSize+5, 20*yOffset + 25 + 10*c);
    }
    
    text(str(totalLength), screenSize+5, 10);
    
    stroke(0);
  } // End of display
}