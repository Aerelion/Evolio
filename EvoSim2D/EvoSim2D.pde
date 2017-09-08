Terra world; //<>//
HashMap<Character, Boolean> keyList = new HashMap<Character, Boolean>();
ArrayList<Creature> entities;
int stage, cycle;

void register(char ky) {
  keyList.put(ky, false); 
}

void generate() {
  
}

void setup() {
  size(600, 600);
  colorMode(HSB, 360);
  world = new Terra(200, 200, 6, 100); //<>//
  stage = 0;
  cycle = 1;
  
  register('1');
  register('2');
  register('3');
}

void draw() {
  if (keyList.get('1') == true) {
    world.display("rich", keyList.get('2'));
  } else if (keyList.get('3') == true) {
    world.display("hue", keyList.get('2'));
  } else {
    world.display("world", keyList.get('2'));
  }
  
  if (stage == 0) {
    //world.update(entities);
  } else if (stage == 1) {
    
  }
}

void keyPressed() {
  keyList.put(key, true);
  println("Pressed: " + key);
}

void keyReleased() {
  keyList.put(key, false);
}