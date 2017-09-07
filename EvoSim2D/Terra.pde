class Terra { //<>// //<>// //<>//
  int[][][] map;
  int size;
  int seaLvl;
  float lakes;
  HashMap<Integer, ArrayList<Creature>> creatureList = new HashMap<Integer, ArrayList<Creature>>();

  private void closen(int depth, int mult) {
    int[][][] newMap = new int[size][size][5];
    if (mult == 0) {
      mult = 1;
    }

    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        float hue = float(map[x][y][0]);
        float tC = cos(radians(hue)) * float(mult);
        float tS = sin(radians(hue)) * float(mult);


        int totalRich = map[x][y][1] * mult;

        int count = mult;

        for (int x_offset = -depth; x_offset < depth+1; x_offset++) {
          for (int y_offset = -depth; y_offset < depth+1; y_offset++) {

            if (x+x_offset < size && x+x_offset > 0) {
              if (y+y_offset < size && y+y_offset > 0) {

                int newX = x + x_offset;
                int newY = y + y_offset;

                float newHue = float(map[newX][newY][0]);
                tC = tC + cos(radians(newHue));
                tS = tS + sin(radians(newHue));

                totalRich = totalRich + map[newX][newY][1];

                count++;
              }
            }
          }
        }

        tC = tC / float(count);
        tS = tS / float(count);

        float sTan = atan(tS / tC); //<>//

        PVector sVec = new PVector(tC, tS);
        sVec.normalize();

        int newHue = int((degrees(sVec.heading()) + 360) % 360);
        //int newHue = int((degrees(sTan)+ 360) % 360);
        totalRich = totalRich / count;

        newMap[x][y][0] = newHue;
        newMap[x][y][1] = totalRich; //<>//
        newMap[x][y][2] = map[x][y][2];
        newMap[x][y][3] = map[x][y][3];
      }
    }

    map = newMap;
  }


  Terra(int s_, int z_, float l_, int worldSeed) {
    size = s_;
    seaLvl = z_;
    lakes = l_;
    map = new int[size][size][4];
    randomSeed(worldSeed);
    noiseSeed(worldSeed);
    
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        float var = 0;
        float scaler = ((float(y)/float(size)) * 360.0) % 90.0;
        float var2 = random(scaler, 90.0);
        
        if (y < size*(1.0/4.0)) {
          var = 90.0 - var2;
          map[x][y][0] = int(random(var, 360.0-var));
          
        } else if (y < size*(2.0/4.0)) {
          var = 0.0 + var2;
          if (random(0,1) > 0.5) {
            map[x][y][0] = int(random(0.0, 180.0-var));
          } else {
            map[x][y][0] = int(random(180.0+var, 360.0));
          }
          
        } else if (y < size*(3.0/4.0)) {
          var = 90.0 - var2;
          if (random(0,1) > 0.5) {
            map[x][y][0] = int(random(0.0, 180.0-var));
          } else {
            map[x][y][0] = int(random(180.0+var, 360.0));
          }
          
        } else {
          var = 0.0 + var2;
          map[x][y][0] = int(random(var, 360.0-var));
        }
            
        map[x][y][1] = int(random(0, 360)); // Food richness
        map[x][y][2] = map[x][y][1]; // Food level
        map[x][y][3] = int(noise(float(x) * lakes/size, float(y) * lakes/size) * 360.0); // Water amount
        
        if (map[x][y][3] > seaLvl) { // When does water form a lake
          map[x][y][2] = -1; // Disabling food from tile (in case of water walkers)
        } else {
          float ori = float(map[x][y][1]);
          float bonus = float(map[x][y][3]) * (360.0 / (float(seaLvl)));
          map[x][y][1] = int((ori + bonus) / 2.0); // Boosting richness if there's a lot of water and it will add something
        }
        
      }
    }

    closen(1,2);
  }

  void display(String arg, boolean stroke) {
    float posVarX = width/size;
    float posVarY = height/size;
    
    if (stroke == true) {
      stroke(0);
    } else {
      noStroke();
    }
    
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        int hue = 0;
        int sat = 200;
        int bri = 200;
        
        if (arg == "hue") {

          if (map[x][y][2] == -1) {
            hue = 230;
            sat = 360;
          } else {
            hue = map[x][y][0];
            sat = map[x][y][1];
          }
          
        } else if (arg == "rich") {
          
          if (map[x][y][2] == -1) {
            hue = 180;
          }
          
          bri = map[x][y][1];
        }
        
        fill(hue, sat, bri);
        rect(posVarX*x, posVarY*y, posVarX, posVarY);
        
      }
    }
  }
}