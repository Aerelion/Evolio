class Creature {
  Body body;
  Brain brain;
  
  float mut_solve = 0.5;
  
  
  float age = 0;
  int depreviation = 0;
  
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
  
  Creature(float x_, float y_, String[] b_, Neuron[] n_, Connection[] c_) { // Spawning new creature from parents 
    data = b_;
    
    createBody(); //<>//
    
    createBrain(n_, c_); //<>//
    
    body.x = min(screenSize-1, max(1, x_ + random(-5, 5))); //<>//
    body.y = min(screenSize-1, max(1, y_ + random(-5, 5)));
    body.brain_en = brain.totalLength/1000 + brain.neurons.length/50;
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
    //--------- Mutating body ------------
    // Retrieve data
    String[] bodyData_child = new String[2];
    String[] bodyData_self = data;
    String[] bodyData_partner = p.data;
    
    // Internal crossover
    bodyData_self = crossover(bodyData_self);
    bodyData_partner = crossover(bodyData_partner);
    
    // Selecting one strand for new creature
    String chromeA = bodyData_self[round(random(0, 1))];
    String chromeB = bodyData_partner[round(random(0, 1))];
    
    // Mutating strands
    chromeA = mutate(chromeA); 
    chromeB = mutate(chromeB);
    
    // Adding strands to new creatures dataset
    bodyData_child[0] = chromeA;
    bodyData_child[1] = chromeB;
    
    //---------- Brain recombination ---------------
    // Retrieving data
    Connection[][] brainData_oldC = new Connection[2][]; // Stores connections from both parents
    brainData_oldC[0] = brain.connections;
    brainData_oldC[1] = p.brain.connections;
    Connection[] brainData_childC; // Child connection storage
    
    Neuron[][] brainData_oldN = new Neuron[2][];
    brainData_oldN[0] = brain.neurons;
    brainData_oldN[1] = p.brain.neurons;
    Neuron[] brainData_childN;
    
    // Combine the 2 brains using external crossover, switch between choosing from one or the other.
    // Selecting split points
    int splitAmount = max(1, int(random(0, max(1, brainData_oldC[0].length/5))));
    int[] splits = new int[splitAmount]; // Random amount of split points based on the amount of connections in the self brain
    
    for (int i = 0; i < splits.length; i++) {
      splits[i] = int(random(0, brainData_oldC[0].length));
    } // Selecting location of split points
    splits = sort(splits); // Sorting split points
    
    int split = 0;
    int currentStrand = 0;
    boolean flip = true;
    ArrayList<Connection> c_temp = new ArrayList<Connection>(); // Temporary storage for connection data
    ArrayList<Neuron> n_temp = new ArrayList<Neuron>(); // Temporary storage for neurons belonging to the connection that gets copied over
    HashMap<Integer, Integer> boot = new HashMap<Integer, Integer>();
    int boots = 0;
    for (int connection = 0; connection < max(brainData_oldC[0].length, brainData_oldC[1].length); connection++) { // Iterate over the length of the longest array
      if (split < splits.length && connection == splits[split]) { // Switch from Brain DNA strand if a splitpoint is reached
        flip = !flip;
        currentStrand = int(flip);
        split++;
      }
      Connection temp;
      if (connection >= brainData_oldC[currentStrand].length) {
        temp = null;
      } else {
        temp = brainData_oldC[currentStrand][connection];
      }
      if (temp != null) {
        c_temp.add(temp); // Add selected connection to temporary storage
        
        if (temp.in >= sensors + controls) { // If the connection receives inputs from a hidden neuron, add the neuron to temporary storage
          if (boot.get(temp.in) == null) { // Checks if the hidden neuron has already been added
            n_temp.add(brainData_oldN[currentStrand][temp.in]);
            boot.put(temp.in, boots);
            boots++;
          }
        }
        
        if (temp.out >= sensors + controls) { // If the connection is connected to a hidden neuron, add the hidden neuron to temporary storage
          if (boot.get(temp.out) == null) { // Checks if the hidden neuron has already been added
            n_temp.add(brainData_oldN[currentStrand][temp.out]);
            boot.put(temp.out, boots);
            boots++;
          }
        }
      }
    }
    
    HashMap<Integer, Boolean> serving = new HashMap<Integer, Boolean>();
    HashMap<Integer, Boolean> receiving = new HashMap<Integer, Boolean>();
    
    for (Connection c : c_temp) {
      int in = c.in;
      int out = c.out;
      if (c.in >= sensors+controls) {
        in = boot.get(in) + sensors + controls;
      }
      
      if (c.out >= sensors+controls) {
        out = boot.get(out) + sensors + controls;
      }
      c.in = in;
      c.out = out;
      serving.put(in, true);
      receiving.put(out, true);
    }
    
    
    
    //------------ Mutating the strands ----------
    // Checking for unlinked neurons:
    for (int b = 0; b < boots; b++) {
      if (serving.get(b) == null) {
        if (random(0, 1) < mut_solve) {
          int from = int(random(0, sensors));
          float le = sqrt(pow(n_temp.get(b).x - brainData_oldN[0][from].x, 2.0) + pow(n_temp.get(b).y - brainData_oldN[0][from].y, 2.0));
          c_temp.add(new Connection(from, b+sensors+controls, random(-1,1), le));
        }
      }
      if (receiving.get(b) == null) {
        if (random(0, 1) < mut_solve) {
          int from = int(random(sensors, sensors+controls));
          float le = sqrt(pow(n_temp.get(b).x - brainData_oldN[0][from].x, 2.0) + pow(n_temp.get(b).y - brainData_oldN[0][from].y, 2.0));
          c_temp.add(new Connection(b+sensors+controls, from, random(-1,1), le));
        }
      }
    }
    
    // Creating new creature
    brainData_childC = new Connection[c_temp.size()]; // Setting the static array to the correct size
    brainData_childN = new Neuron[n_temp.size()]; // Dependant on the variable amount of connections and neurons
    
    for (int c = 0; c < c_temp.size(); c++) { // Adding dynamic entries to static array
      brainData_childC[c] = c_temp.get(c);
    }
    for (int n = 0; n < n_temp.size(); n++) {
      brainData_childN[n] = n_temp.get(n);
    }
    c_temp = null; // Removing dynamic thingy
    n_temp = null;
    
    entities.add(new Creature(body.x, body.y, bodyData_child, brainData_childN, brainData_childC));
    creatureCounter++;
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
  
  void createBrain(Neuron[] _n, Connection[] _c) {
    brain = new Brain(body, _n.length, _c.length);
    
    for (int hn = 0; hn < _n.length; hn++) {
      brain.addNeuron(hn, _n[hn]);
    }
    
    for (int hc = 0; hc < _c.length; hc++) {
      brain.addConnection(hc, _c[hc]);
    }
  }
  
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