class Terra { //<>// //<>// //<>// //<>// //<>//
  int[][][] map;
  int size;
  int seaLvl;
  int creatureCounter = 0;
  float lakes, growthRate;
  HashMap<Integer, ArrayList<Creature>> creatureList = new HashMap<Integer, ArrayList<Creature>>();

  private void closen(int depth, int mult) {
    int[][][] newMap = new int[size][size][5];
    if (mult == 0) {
      mult = 1;
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        float hue = float(map[y][x][0]);
        float tC = cos(radians(hue)) * float(mult);
        float tS = sin(radians(hue)) * float(mult);


        int totalRich = map[y][x][1] * mult;

        int count = mult;

        for (int y_offset = -depth; y_offset < depth+1; y_offset++) {
          for (int x_offset = -depth; x_offset < depth+1; x_offset++) {

            if (x+x_offset < size && x+x_offset > 0) {
              if (y+y_offset < size && y+y_offset > 0) {

                int newX = x + x_offset;
                int newY = y + y_offset;

                float newHue = float(map[newY][newX][0]);
                tC = tC + cos(radians(newHue));
                tS = tS + sin(radians(newHue));

                totalRich = totalRich + map[newY][newX][1];

                count++;
              }
            }
          }
        }

        tC = tC / float(count);
        tS = tS / float(count);

        float sTan = atan(tS / tC);

        PVector sVec = new PVector(tC, tS);
        sVec.normalize();

        int newHue = int((degrees(sVec.heading()) + 360) % 360);
        //int newHue = int((degrees(sTan)+ 360) % 360);
        totalRich = totalRich / count;

        newMap[y][x][0] = newHue;
        newMap[y][x][1] = totalRich;
        newMap[y][x][2] = map[y][x][2];
        newMap[y][x][3] = map[y][x][3];
      }
    }

    map = newMap;
  } // End 'closen'


  Terra(int s_, int z_, float l_, float r_, int worldSeed) {
    size = s_;
    seaLvl = z_;
    lakes = l_;
    growthRate = r_;
    map = new int[size][size][4];
    randomSeed(worldSeed);
    noiseSeed(worldSeed);

    for (int y = 0; y < size; y++) {
      float scaler = ((float(y)/float(size)) * 360.0) % 90.0;

      for (int x = 0; x < size; x++) {

        if (y < size*(1.0/4.0)) {
          map[y][x][0] = int(random(90.0 - scaler, 360.0 - (90.0 - scaler)));
        } else if (y < size*(2.0/4.0)) {
          if (random(0, 1) > 0.5) {
            map[y][x][0] = int(random(0.0, 180.0 - scaler));
          } else {
            map[y][x][0] = int(random(180.0 + scaler, 360.0));
          }
        } else if (y < size*(3.0/4.0)) {
          if (random(0, 1) > 0.5) {
            map[y][x][0] = int(random(0.0, 180.0 - (90.0 - scaler)));
          } else {
            map[y][x][0] = int(random(180.0 + (90.0 - scaler), 360.0));
          }
        } else {
          map[y][x][0] = int(random(scaler, 360.0 - scaler));
        }

        map[y][x][3] = int(noise(float(x) * lakes/size, float(y) * lakes/size) * 360.0); // Water amount

        if (map[y][x][3] > seaLvl) { // When does water form a lake
          map[y][x][2] = -1; // Disabling food from tile (in case of water walkers)
          map[y][x][1] = int(random(180, 360));
        } else {
          map[y][x][1] = int(random(map[y][x][3], 360));
          map[y][x][2] = map[y][x][1];
        }


        // Generate Tile Lists
        int tile = y*size + x;
        creatureList.put(tile, new ArrayList<Creature>());
      }
    }

    int iVal = int( float(size) / ( 7.0 * ( float(size) / sqrt( 2.0 * float(size)))));
    for (int i = iVal; i > 0; i--) {
      if (i <= 1) {
        closen(i, 2*i);
      } else {
        closen(i * (i-1), i*i);
      }
    }
  } // End 'Terra'

  void display(String arg, boolean stroke) {
    float posVarX = width/size;
    float posVarY = height/size;

    if (stroke == true) {
      stroke(0);
    } else {
      noStroke();
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        int hue = 0;
        int sat = 200;
        int bri = 200;

        if (arg == "world") {

          if (map[y][x][2] == -1) {
            hue = 230;
            sat = 360;
          } else {
            hue = map[y][x][0];
            sat = map[y][x][2];
          }
        } else if (arg == "rich") {

          if (map[y][x][2] == -1) {
            hue = 180;
          }

          bri = map[y][x][1];
        } else if (arg == "hue") {
          if (map[y][x][2] == -1) {
            hue = 230;
            sat = 360;
          } else {
            hue = map[y][x][0];
            sat = 300;
          }
        }

        fill(hue, sat, bri);
        rect(posVarX*x, posVarY*y, posVarX, posVarY);
        fill(0);
        //text(str(map[y][x][2]), posVarX*x, posVarY*y);
      }
    }
  } // End 'display'

  void update(ArrayList<Creature> creatures) {
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        //creatureList.put(y*size + x, new ArrayList<Creature>()); //Refresh creature lists

        if (map[y][x][2] != -1) { // Update food

          float growth = -1 * pow( (float(map[y][x][2]) - 180.0) / 16.0, 2.0) + 120;
          int base = 1;
          if (int(growth) <= 0 && map[y][x][2] < 360) {
            growth = 1;
          } else if (map[y][x][2] >= 360) {
            growth = 0;
            base = 0;
          }
          map[y][x][2] = map[y][x][2] + base + int(growth * growthRate * (360.0 / float(map[y][x][1])));
        }
      }
    }

    for (Creature n : creatures) { // Place creatures in tile lists for efficiency
      int x_ = int(n.body.x / size);
      int y_ = int(n.body.y / size);

      int tile = y_*size + x_;

      ArrayList<Creature> population = creatureList.get(tile);
      population.add(n);
      creatureList.put(tile, population);
    }

    for (Map.Entry tile : creatureList.entrySet()) {
      ArrayList<Creature> list = creatureList.get(tile.getKey());
      for (Creature n : list) {
        n.update();
        if (n.body.dead == true) {
          // Remove creature
        }
      }
    }
    // Update per tile for fairness, location based instead of number
    // Place things like eating & birthing in queue


    // Resolve queue
  } // End 'update'
} // End class 'Terra'