class Body{
  float x = 0;
  float y = 0;
  float energy = 100;
  float health = 100;
  
  static final float base_en = 0.1; // Base energy use for all creatures
  static final float baseSize = 0.9; // Base size
  static final int maxAccept = 20; // Maximum degrees of allowed foods
  static final float minSpeed = 0.005; // Minimum speed in pixels per second
  static final float maxSpeed = 0.05; // Max speed in pixels per second
  static final float maxMotion = 1.5; // Maximum length of motion vector
  static final float angularSpeed = PI / 8; // Speed of rotation, in radians
  
  float size = 2;
  float currentSize = 0;
  int hue = 0;
  int accept = 20;
  
  float brain_en = 0;
  float body_en = 0;
  
  boolean dead = false;
  
  PVector direction;
  PVector motion;
  
  Creature self;
  Creature partner = null;
  
  Body(float s_, Creature c) {
    direction = new PVector(0, s_);
    motion = new PVector(0,0);
    self = c;
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
      if (action[0]) { // Act0 = forward
        motion.add(PVector.mult(direction, (1.0/frameRate) * (min(energy, 100) / 100)));
        motion.limit(maxMotion);
        used_en += 0.1;
        moved = true;
      }
      if (action[1]) { // Act1 = backwards
        motion.add(PVector.mult(direction, (-0.5/frameRate) * (min(energy, 100) / 100)));
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
      
      if (action[2]) { // Act2 = turn left
        direction.rotate(angularSpeed * (1/frameRate));
        used_en += 0.02;
      }
      if (action[3]) { // Act3 = turn right
        direction.rotate(-angularSpeed * (1/frameRate));
        used_en += 0.02;
      }
      
      if (action[4]) { // Action 4 = eat
        int yPos = int(y / ratio);
        int xPos = int(x / ratio);
        
        if (world.map[yPos][xPos][2] == -1) { // Can't really eat/drink salt water
          used_en += 0.1;
        } else {
          int foodHue = world.map[yPos][xPos][0];
          int foodVal = world.map[yPos][xPos][2];
          if ((foodHue + accept) % 360 < (hue + 2*accept) % 360) { // Check if the creature can accept this type of food
            if (foodVal > 50) { // Checks if there's enough food
              used_en -= 5.0;
              world.map[yPos][xPos][2] = foodVal - round(50.0 / frameRate);
            } else if (foodVal > 10) {
              used_en -= 0.5;
              world.map[yPos][xPos][2] = foodVal - round(10.0 / frameRate);
            } else {
              used_en += 0.5;
            }
          } else {
            used_en += 1.0; // Penalty for eating wrong food
          }
        }
      } // End of if(eat)
      
      if (action[5] && partner != null && partner.brain.state()[5]) { // Act5 = mate || checks if there's a partner and if partner is willing
        if (energy > 200 && partner.body.energy > 100) {
          self.mate(partner);
        }
      } // End of if(mate)
      float energyMod = (base_en + brain_en + body_en + used_en + (currentSize / (10*ratio))) * (1 / frameRate);
      if (energyMod >= 0) {
        energy -= energyMod * max((energy/100), 0.8);
      } else {
        energy -= energyMod;
      }
      
      if (energy <= 0) {
        die();
      } else {
        currentSize = (baseSize * size) * sqrt(energy / 100.0);
      }
    }
  }
  
  void display() {
    if (dead == false) {
      stroke(0);
      fill(hue, 200, 200);
      ellipse(x, y, currentSize, currentSize);
      fill(0);
      text(str(round(energy)), x, y);
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