import java.util.Map; //<>// //<>//

Terra world;
HashMap<Character, Boolean> keyList = new HashMap<Character, Boolean>();
ArrayList<String[]> speciesList = new ArrayList<String[]>();
ArrayList<Creature> entities = new ArrayList<Creature>();
int stage, cycle;
int pairCounter = 0;
int scaleSize = 10;
int specieMax = 20;
int chromes = 2;

int[] chrL = new int[chromes]; {
  chrL[0] = 2;
  chrL[1] = 4; 
}

public float Euler = 2.71828182845904523536;
int worldSize = 200;
int screenSize = 600;

void register(char ky) {
  keyList.put(ky, false);
}

void generateSpecies() {
  String[] specie = new String[2];
  for (int c = 0; c < chromes; c++) {
    for (int allel = 0; allel < chrL[c]; allel++) {
      specie[c] = specie[c] + str(int('A' + allel));
      int val = int(random(0,256));
      if (val < 10) {
        specie[c] = specie[c] + "00" + str(val);
      } else if (val < 100) {
        specie[c] = specie[c] + "0" + str(val);
      } else {
        specie[c] = specie[c] + str(val);
      }
    }
  }
  
  speciesList.add(specie);
}

String generateChrome(String[] specie, int chrNr) {
  String chr = "";

  for (int al = 0; al < chrL[chrNr]; al++) {
    
    chr = chr + 'A';
    chr = chr + str(int(random(0, 256)));
  }
  println(chr);
  return chr;
}

void generate() {
  println("Pair " + str(pairCounter));
  pairCounter++;
  int pairX = int(random(0, worldSize+1) * (float(screenSize) / float(worldSize)));
  int pairY = int(random(0, worldSize+1) * (float(screenSize) / float(worldSize)));
  String chr1 = createChrome(2);
  String chr2 = createChrome(2);
  String chr3 = createChrome(3);
  String chr4 = createChrome(3);

  entities.add(new Creature(char('x'), char('x'), chr1, chr2, chr3, chr4, pairX + int(random(-1 * scaleSize, scaleSize)), pairY + int(random(-1 * scaleSize, scaleSize))));
  entities.add(new Creature(char('x'), char('y'), chr2, chr1, chr4, chr3, pairX + int(random(-1 * scaleSize, scaleSize)), pairY + int(random(-1 * scaleSize, scaleSize))));
  
  world.creatureCounter = world.creatureCounter + 2;
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

  for (int i = 0; i < 50; i++) {
    generate();
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
  
  generate();
  
  fill(0);
  text("Creature Count: " + str(world.creatureCounter), 0, 10);
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