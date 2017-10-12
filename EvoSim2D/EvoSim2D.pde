import java.util.Map; //<>//

Terra world;

HashMap<Character, Boolean> keyList = new HashMap<Character, Boolean>();
ArrayList<Creature> entities = new ArrayList<Creature>();

// Loop setup
int stage, cycle;
int creatureCounter = 0;
int scaleSize = 10;

// World setup
int worldSize = 100;
int screenSize = 600;
float ratio = screenSize / worldSize;

// Creature setup
int genes = 3;
int startingCreatures = 200;
int specieCounter = 0;
int sensors = 10;
int controls = 5;
float minSpeed = 0.01; // Px/s
float maxSpeed = 0.1;
float maxMotion = 2.5;
float angularSpeed = PI / 8; //RAD

void register(char ky) {
  keyList.put(ky, false);
}

void register(char[] ky) {
  for (int k = 0; k < ky.length; k++) {
    keyList.put(ky[k], false);
  }
}

void setup() {
  size(850, 600);
  colorMode(HSB, 360);
  world = new Terra(worldSize, 200, 6, 100);
  frameRate(10);
  stage = 0;
  cycle = 1;

  register(new char[]{'1', '2', '3'});
  for (int ch = 0; ch < 25; ch++) {
    register(char(int('a') + ch));
  }
  
  for (int i = 0; i < startingCreatures; i++) {
    entities.add(new Creature());
    creatureCounter++;
  }
}

void draw() {
  clear();
  background(100);
  world.update(entities);

  if (keyList.get('1') == true) {
    world.display("rich", keyList.get('2'));
  } else if (keyList.get('3') == true) {
    world.display("hue", keyList.get('2'));
  } else {
    world.display("world", keyList.get('2'));
  }

  for (Creature n : entities) {
    n.display();
  }
  
  fill(0);
  text("FPS: " + str(frameRate), 0, 10);
  text("Creature Count: " + str(creatureCounter), 0, 20);
  
  int bra = 1;
  for (int i = 0; i < 25; i++) {
    if (keyList.get(char(int('a') + i))) {
      bra +=i;
    }
  }
  if (bra < entities.size()) {
    entities.get(bra).brain.display();
  }
  //world.display();
  // Update World

  // Display World

  // Display Creatures

  // Take screenshot , img_nr.png , for future conversion to video for frame consistency and presentation
}

void keyPressed() {
  keyList.put(key, true);
  println("Pressed: " + key);
}

void keyReleased() {
  keyList.put(key, false);
}