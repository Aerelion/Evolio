class Body {
  float x = 0;
  float y = 0;
  float energy = 100;
  float health = 100;
  
  float base_en = 0.1;
  float brain_en = 0;
  float body_en = 0;
  
  float size = 2;
  int hue = 0;
  int accept = 20;
  int sat = 200;
  int sizeMod = 10;
  int baseSize = 5;
  
  boolean isFemale = true;
  boolean dead = false;
  
  PVector direction;
  PVector motion;
  
  Body(float s_) {
    direction = new PVector(0, s_);
    motion = new PVector(0,0);
  }
  
  void update(boolean[] action) {
    if (dead == false) {
      float used_en = 0;
      if (x+motion.x >= 0 && x+motion.x < screenSize) {
        x += motion.x;
      }
      if (y+motion.y >= 0 && y+motion.y < screenSize) {
        y += motion.y;
      }
      
      boolean moved = false;
      if (action[0]) {
        motion.add(PVector.mult(direction, 1.0/frameRate));
        motion.limit(maxMotion);
        used_en += 0.1;
        moved = true;
      }
      if (action[1]) {
        motion.add(PVector.mult(direction, -0.5/frameRate));
        motion.limit(maxMotion);
        used_en += 0.1;
        moved = true;
      }
      if (moved == false) {
        motion.mult(pow(0.8, 1.0/frameRate));
        if (motion.mag() < 0.1) {
          motion.set(0,0);
        }
      }
      
      if (action[2]) {
        direction.rotate(angularSpeed * (1/frameRate));
        used_en += 0.02;
      }
      if (action[3]) {
        direction.rotate(angularSpeed * (1/frameRate));
        used_en += 0.02;
      }
      
      if (action[4]) {
        int yPos = int(y / ratio);
        int xPos = int(x / ratio);
        
        if (world.map[yPos][xPos][2] == -1) {
          used_en += 0.1;
        } else {
          //if (world.map[yPos][xPos][0] > 
        }
      }
        
      energy -= (base_en + brain_en + body_en + used_en) * (1/frameRate);
      if (energy <= 0) {
        die();
      } else {
        size = float(baseSize*sizeMod) * (energy / 100.0);
      }
    }
  }
  
  void display() {
    if (dead == false) {
      stroke(0);
      fill(hue, sat, 200);
      ellipse(x, y, size, size);
    }
  }
  
  void die() {
    int tX = int(x / ratio);
    int tY = int(y / ratio);
    if (world.map[tY][tX][2] != -1) {
      world.map[tY][tX][2] = world.map[tY][tX][2] + int(health)*6;
    }
    
    creatureCounter--;
    dead = true;
  }
}