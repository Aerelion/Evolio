class Creature {
  Body body;
  Brain brain;
  
  String[] data = new String[2];
  
  String[] cut(String chrome) {
    String[] subs = new String[genes];
    
    for (int p = 0; p < genes; p++) {
      subs[p] = chrome.substring(p*4, p*4+4);
    }
    
    return subs;
  } // End cut
  
  int[] give(String[] allele) {
    int[] dec = new int[allele.length];
    for (int g = 0; g < allele.length; g++) {
      dec[g] = int(allele[g].substring(1,4));
    }
    return dec;
  } // End give1
  
  int give(String allel) {
    int g = int(allel.substring(1, 4));
    return g;
  } // End give2
  
  Creature () { // Initiating a fresh creature
    generateData(); // Creating fresh chromosomes
    
    createBody();
    
    generateBrain();
    
    body.x = random(0, screenSize);
    body.y = random(0, screenSize);
    body.brain_en = brain.totalLength/1000 + brain.neurons.length/50;
  } // End init for fresh creature
  
  Creature(int x_, int y_, String[] chromes, String[][] genes) { // Spawning new creature from parents 
    data = chromes;
    createBody();
    body.x = x_;
    body.y = y_;
  } // End init for spawning creature
  
  void generateData() {
    String[] chromes = new String[2]; // Creating temp chrome pair
    
    for (int c = 0; c < 2; c++) { // Generating 2 random chromosomes
    
      for (int all = 0; all < genes; all++) { // Generating <genes> amount of genes
        
          int val = int(random(0,256)); // Choosing value
          
            chromes[c] = chromes[c] + str(int('A') + all); // Adding allele marker
            if (val < 10) {
              chromes[c] = chromes[c] + "00" + str(val);
            } else if (val < 100) {
              chromes[c] = chromes[c] + "0" + str(val);
            } else {
              chromes[c] = chromes[c] + str(val);
            }
        }
    }
    
    data = chromes; // Storing chromosomes in data variable
  } // End of generateData
  
  float additive(int a, int b) {
    float res;
    res = float(a) + float(b);
    res = res / 2.0;
    return res;
  }
  
  float circular(int a, int b) {
    float valA = map(a, 0, 256, 0, 360);
    float valB = map(b, 0, 256, 0, 360);
    float xA = cos(valA);
    float yA = sin(valA);
    float xB = cos(valB);
    float yB = sin(valB);
    
    PVector vec = new PVector(xA + xB, yA + yB);
    vec.normalize();
    
    float ang = degrees(vec.heading());
    ang += 360;
    ang = ang % 360;
    return ang;
  }
  
  void createBody() {
    int[] dA = give(cut(data[0]));
    int[] dB = give(cut(data[1]));
    
    float speed = map(additive(dA[2], dB[2]), 0, 256, minSpeed, maxSpeed);
    
    body = new Body(speed);
    
    body.baseSize = int(map(additive(dA[0], dB[0]), 0, 256, 1, ratio));
    body.hue = int(circular(dA[1], dB[1]));
    
  } // End of createBody
  
  void generateBrain() {
    int connecters = sensors*2;
    brain = new Brain(body, sensors, connecters);
    
    for (int hn = 0; hn < sensors; hn++) {
      brain.createNeuron("hid", hn + sensors + controls);
    }
    
    for (int hc = 0; hc < connecters; hc++) {
      brain.createConnection(hc);
    }
  } // End of generateBrain
  
  void display() {
    body.display();
  }
  
  void update() {
    brain.update();
    boolean[] controller = brain.state();
    body.update(controller);
  }
}