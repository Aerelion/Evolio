class Creature {
  Body body;
  String chrome2A, chrome2B, chrome3A, chrome3B;
  char chrome1A, chrome1B;
  
  Creature(char A1, char B1, String A2, String B2, String A3, String B3, int _x, int _y) {
    chrome1A = A1;
    chrome1B = B1;
    chrome2A = A2;
    chrome2B = B2;
    chrome3A = A3;
    chrome3B = B3;
    
    body = new Body(_x, _y);
    
    if (chrome1A == 'y' || chrome1B == 'y') {
      body.isFemale = false;
    } else {
      body.isFemale = true;
    }
    
    
    body.size = 20;
  }
  
  void display() {
    body.display();
  }
  
  void update() {
    
  }
}