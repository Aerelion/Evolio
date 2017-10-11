class Body {
  float x = 0;
  float y = 0;
  float energy = 100;
  float health = 100;
  float consumption = 0.01;
  
  int size = 10;
  int hue = 0;
  int sat = 200;
  int baseSize = 5;
  
  boolean isFemale = true;
  boolean dead = false;
  
  Body() {
  }
  
  void update() {
    if (dead == false) {
      energy -= consumption;
      if (energy <= 0) {
        die();
      }
    }
  }
  
  void display() {
    if (dead == false) {
      stroke(0);
      fill(hue, sat, 200);
      ellipse(x, y, float(baseSize*size) * (energy / 100.0), float(baseSize*size) * (energy / 100.0));
    }
  }
  
  void die() {
    int tX = int(x / float(worldSize));
    int tY = int(y / float(worldSize));
    if (world.map[tY][tX][2] != -1) {
      world.map[tY][tX][2] = world.map[tY][tX][2] + int(health);
    }
    
    creatureCounter--;
    dead = true;
  }
}