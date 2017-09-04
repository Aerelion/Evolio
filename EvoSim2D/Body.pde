class Body {
  float x = 0;
  float y = 0;
  float energy = 100;
  float health = 100;
  
  int size = 2;
  int baseSize = 5;
  
  boolean isFemale = true;
  
  Body(int x_, int y_) {
    x = x_;
    y = y_;
    
  }
  
  void update() {
    
  }
  
  void display() {
    stroke(0);
    ellipse(x, y, size, size);
  }
  
}