String activeProvinceName;
int activeProvinceID;
Graph provinceGraph;
Province activeProvince;
ArrayList<Troop> troops;
Troop activeTroop;
boolean foundProvince;
boolean troopSelectedFlag = false;
long frameNumber = 0;

enum gameState {
  selectScreen,
    play,
    endWin,
    endLose
}

gameState currState = gameState.selectScreen;

void setup() {
  size(1600, 900);
  init();
  frameRate(60);
}


void draw() {
  background(#ECE3A1);
  if (currState == gameState.selectScreen) {
    handleIntroScreen();
  } else if (currState == gameState.endWin) {
    handleWinScreen();
  } else if (currState == gameState.endLose) {
    handleLoseScreen();
  } else {
    frameNumber++;
    handleCamera();

    

    // draw provinces
    strokeWeight(1);
    for (Province province : provinces) {
      province.draw();
    }

    handleDrawUI();

    // draw troops
    if (activeTroop != null && activeTroop.getTarget() == activeTroop.getLocation()) {
      drawVectorToMouse(provinces.get(activeTroop.getLocation()).getCentre());
      fill(#000000);
      stroke(#000000);
    }

    for (Troop troop : troops) {
      troop.handleTroop();
    }
    bringOutYourDead();

    doTaxLogic();
    handleTroopUpkeep();
    testWin();
  }
}
void addBridges() {
  provinceGraph.addEdge(19, 20, 10);
  provinceGraph.addEdge(1, 16, 10);
}


void drawVectorToMouse(float[] screenPos) {
  fill(#FF0000);
  stroke(#FF0000);
  float pos[] = posToScreenSpace(screenPos);
  circle(pos[0], pos[1], 10);

  line(pos[0], pos[1], mouseX, mouseY);
  circle(mouseX, mouseY, 10);
}

void mouseReleased() {
  switch(currState) {
  case selectScreen:
    handleIntroClick();
    break;
  case play:
    handlePlayClick();
    break;
  default:
    break;
  }
}


void keyPressed() {
  for (Province province : provinces) {
    if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
      if (key == '0') province.setController(0);
      if (key == '1') province.setController(1);
      if (key == '2') province.setController(2);
      if (key == '3') province.setController(3);
      return;
    }
  }
}

void handlePlayClick() {
  if (mouseButton == CENTER) {
    holdingPan = false;
  }

  if (mouseButton == LEFT) {
    if (!troopSelectedFlag) {
      for (Troop troop : troops) {
        if (troop.trySelectTroop()) {
          activeTroop = troop;
          troopSelectedFlag = true;
          return;
        }
      }
      for (Province province : provinces) {
        if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
          activeProvince = province;
          return;
        }
      }
      handleSummonTest();
      activeProvince = null;
      foundProvince = false;
    } else if (troopSelectedFlag) {
      for (Province province : provinces) {
        if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
          troopSelectedFlag = false;
          if (activeTroop.getLocation() != province.getID()) {
            activeTroop.startMove(province.getID());
          }
        }
      }
      activeTroop = null;
      troopSelectedFlag = false;
      activeProvince = null;
      foundProvince = false;
    }
  }
}

void testWin() {
  int playerControllerProvinces = 0;
  for (Province province : provinces) {
    if (province.getController() == playerFaction) playerControllerProvinces ++;
  }
  if (playerControllerProvinces == 0) {
    currState = gameState.endLose;
  } else if (playerControllerProvinces >= 33) {
    currState = gameState.endWin;
  }
}
