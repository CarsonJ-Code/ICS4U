String activeProvinceName;
int activeProvinceID;
Graph provinceGraph;
Province activeProvince;
ArrayList<Troop> troops;
Troop activeTroop;
boolean foundProvince;
boolean troopSelectedFlag = false;
long frameNumber = 0;

void setup() {
  size(1600, 900);
  init();
  frameRate(60);
}


void draw() {
  frameNumber++;
  background(#ECE3A1);
  handleCamera();

  // draw provinces
  strokeWeight(1);
  for (Province province : provinces) {
    province.draw();
  }


  handleDrawProvinceUI();
  handleDrawTroopUI();
  handleDrawWealthUI();
  // draw troop panel


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
