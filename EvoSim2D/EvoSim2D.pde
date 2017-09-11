Terra world; //<>//
HashMap<Character, Boolean> keyList = new HashMap<Character, Boolean>();
ArrayList<Creature> entities;
int stage, cycle;
public float Euler = 2.71828182845904523536;

void register(char ky) {
  keyList.put(ky, false); 
}

void generate() {
  
}

void setup() {
  size(600, 600);
  colorMode(HSB, 360);
  world = new Terra(20, 200, 6, 100); //<>//
  frameRate(0.2);
  stage = 0;
  cycle = 1;
  
  register('1');
  register('2');
  register('3');
}

void draw() {
  world.update(entities);
  
  if (keyList.get('1') == true) {
    world.display("rich", keyList.get('2'));
  } else if (keyList.get('3') == true) {
    world.display("hue", keyList.get('2'));
  } else {
    world.display("world", keyList.get('2'));
  }
  
    
    //world.display();
    
    // Take screenshot , img_nr.png , for future conversion to video for frame consistency and presentation
}

void keyPressed() {
  keyList.put(key, true);
  println("Pressed: " + key);
}

void keyReleased() {
  keyList.put(key, false);
}