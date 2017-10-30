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
  } // End give
  
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
        chromes[c] += construct(val); // Adding value to current DNA strand
      }
    }
    
    data = chromes; // Storing chromosomes in data variable
  } // End of generateData
  
  void mate(Creature p) {
    String[] myData = data;
    String[] noData = p.data;
    
    myData = crossover(myData);
    noData = crossover(noData);
    
    String A = myData[round(random(0, 1))];
    String B = noData[round(random(0, 1))];
    
    A = mutate(A); 
    B = mutate(B);
  }
  
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
    
    float speed = map(additive(dA[0], dB[0]), 0, 256, Body.minSpeed, Body.maxSpeed);
    
    body = new Body(speed, this);
    
    body.size = int(map(additive(dA[1], dB[1]), 0, 256, 1, ratio));
    body.hue = int(circular(dA[2], dB[2]));
    body.accept = int(map(additive(dA[3], dB[3]), 0, 256, 0, Body.maxAccept));
    
    body.body_en = ((speed * (1.0 / Body.maxSpeed)) + (body.size / ratio)) + (body.accept * (1.0 / Body.maxAccept)) / 10.0;
  } // End of createBody
  
  void generateBrain() {
    int hiders = round(random(1, 5));
    int connecters = round(random(hiders, sensors));
    brain = new Brain(body, hiders, connecters);
    
    for (int hn = 0; hn < hiders; hn++) {
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
  
  String[] crossover(String[] d) {
    int val = int(random(0, genes) + 1);
    String a1 = d[0].substring(0, val*4);
    String b1 = d[1].substring(0, val*4);
    String a2 = d[0].substring(val*4);
    String b2 = d[1].substring(val*4);
    
    d[0] = a1 + b2;
    d[1] = b1 + a2;
    
    return d;
  }
  
  String mutate(String chrome) {
    String res = "";
    int[] alleles = give(cut(chrome));
    
    for (int i = 0; i < alleles.length; i++) {
      int temp = alleles[i];
      temp = min(max(temp + round(random(-mutateStrength, mutateStrength)), 0), 360);
      res += construct(temp);
    }
    return res;
  }
  
  String construct(int var) {
    String res = "A";
    if (var < 10) {
      res += "00";
    } else if (var < 100) {
      res += "0";
    }
    res += str(var);
    return res;
  }
}