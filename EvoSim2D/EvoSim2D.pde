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

// Creature setup
int genes = 2;
int startingCreatures = 100;
int specieCounter = 0;
int sensors = 8;
int controls = 5;

void register(char ky) {
  keyList.put(ky, false);
}

void setup() {
  size(600, 600);
  colorMode(HSB, 360);
  world = new Terra(worldSize, 200, 6, 0.1, 100);
  frameRate(1);
  stage = 0;
  cycle = 1;

  register('1');
  register('2');
  register('3');

  for (int i = 0; i < startingCreatures; i++) {
    entities.add(new Creature());
    creatureCounter++;
  }
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

  for (Creature n : entities) {
    n.display();
  }
  
  fill(0);
  text("Creature Count: " + str(creatureCounter), 0, 10);
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