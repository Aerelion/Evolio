class Creature {
  Body body;
  String[] data = new String[4];
  int bulk = 20;
  int hue = 0;
  
  String[] cut(String chrome) {
    int Alleles = 0;
    for (int c = 0; c < chrome.length(); c++) {
      if (int(chrome.charAt(c)) >= int('A') && int(chrome.charAt(c)) <= int('Z')) {
        Alleles++;
      }
    }
    
    String[] subs = new String[Alleles];
    
    for (int p = 0; p < chrome.length() / 4; p++) {
      subs[p] = chrome.substring(p*4, p*4+4);
    }
    
    return subs;
  }
  int[] give(String[] allele) {
    int[] dec = new int[allele.length];
    for (int g = 0; g < allele.length; g++) {
      dec[g] = int(allele[g].substring(1,4));
    }
    return dec;
  }
  
  int give(String allel) {
    int g = int(allel.substring(1, 4));
    return g;
  }
  
  Creature (String[] chromes, int _x, int _y) {
    data = chromes;
    
    createBody();
    body.x = _x;
    body.y = _y;
  }
  
  Creature(int _x, int _y, String[] lead) {   
    generateData(lead, 30);
    
    int s_ = int( (float( res_A2[0]) * (float(scaleSize) / 256.0) + float( res_B2[0]) * (float(scaleSize) / 256.0)) / 2);
    if (s_ == 0) {
      s_ = 1;
    }
    body.size = s_;
    body.hue = int( (float( res_A2[1]) * (360.0 / 256.0) + float( res_B2[1]) * (360.0 / 256.0)) / 2);
    
  } // End of Main
  
  void generateData(String[] specie, int initSpread) {
    int chrP = 2;
    String[] chromies = new String[chrP * chromes];
    for (int chr = 0; chr < chromes; chr++) {
      String[] alleles = cut(specie[chr]);
      
      for (int cd = 0; cd < chrP; cd++) { // 2 chromes
        int chrNr = chr*2 + cd;
        
        for (int a = 0; a < alleles.length; a++) { // Iterating over all the alleles
          int rando = int(random(1,6));
          int low,up;
          int valS = give(alleles[a]);
          if (valS - initSpread < 0) {
            low = 0;
          } else {
            low = valS - initSpread;
          }
          if (valS + initSpread > 256) {
            up = 256;
          } else {
            up = valS + initSpread;
          }
          
          for (int i = 0; i < rando; i++) { // A random number of alleles per type
            int val = int(random(low, up));
            chromies[chrNr] = chromies[chrNr] + str(int('A') + a);
            if (val < 10) {
              chromies[chrNr] = chromies[chrNr] + "00" + str(val);
            } else if (val < 100) {
              chromies[chrNr] = chromies[chrNr] + "0" + str(val);
            } else {
              chromies[chrNr] = chromies[chrNr] + str(val);
            }
          }
          
        }
        
      }
      
      
    }
  } // End of generateData
  
  void createBody() {
    body = new Body();
    String[] c1 = cut(data[0]);
    String[] c2 = cut(data[1]);
    int[] d1 = give(c1);
    int[] d2 = give(c2);
    
    int bodySize = 0;
    
  } // End of createBody
  
  void createBrain() {
    
  } // End of createBrain
  
  void display() {
    body.display();
  }
  
  void update() {
    body.update();
  }
}