Terra world; //<>//
HashMap<Character, Boolean> keyList = new HashMap<Character, Boolean>();

void register(char ky) {
  keyList.put(ky, false); 
}

void generate() {
  
}

void setup() {
  size(600, 600);
  colorMode(HSB, 360);
  world = new Terra(200, 200, 6, 100); //<>//
  
  register('1');
  register('2');
}

void draw() {
  if (keyList.get('1') == true) {
    world.display("rich", keyList.get('2'));
  } else {
    world.display("hue", keyList.get('2'));
  }
  
}

void keyPressed() {
  keyList.put(key, true);
  println("Pressed: " + key);
}

void keyReleased() {
  keyList.put(key, false);
}