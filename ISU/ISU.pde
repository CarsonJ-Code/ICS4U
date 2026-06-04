String activeProvinceName;
int activeProvinceID;
Graph provinceGraph;
Province activeProvince;
ArrayList<Troop> troops;
Troop activeTroop;
boolean foundProvince;
boolean troopSelectedFlag = false;

void setup() {
  size(1600, 900);
  provinceGraph = new Graph();
  loadProvinces();
  for (Province province : provinces) {
    province.findBounding();
    province.findCentre();
  }

  initProvinceView();

  populateEdges();

  troops = new ArrayList<Troop>();
  createCavalry(1, 0);

  // add edges from Leinster to Wales and Ulster to Southern Scotland to fix Dijkstra's
  addBridges();
}


void draw() {
  background(#ECE3A1);
  handleCamera();

  // draw provinces
  strokeWeight(1);
  for (Province province : provinces) {
    province.draw();
  }

  if (activeProvince != null) {
    activeProvinceName = activeProvince.getName();
    activeProvinceID = provinceIDs.get(activeProvinceName);
    activeProvince.drawSelected();
    foundProvince = true;
  }

  provinceBox.setActivity(foundProvince);
  provinceName.setActivity(foundProvince);
  provinceController.setActivity(foundProvince);
  provinceNeighbours.setActivity(foundProvince);

  // draw province panel
  if (provinceBox.getActivity()) {
    provinceBox.drawRect();
    provinceName.setText(activeProvinceName);
    provinceName.drawText();
    provinceController.setText(activeProvince.getController());
    provinceController.drawText();

    provinceNeighbours.setText(provinceGraph.neighboursAsString(activeProvinceID));
    provinceNeighbours.drawText();
  }
  for (Troop troop : troops) {
    troop.handleTroop();
  }

  if (activeTroop != null && activeTroop.getTarget() == activeTroop.getLocation()) {
    drawVectorToMouse(provinces.get(activeTroop.getLocation()).getCentre());
    fill(#000000);
    stroke(#000000);
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
    } else if(troopSelectedFlag){
      for (Province province : provinces) {
        if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
          troopSelectedFlag = false;
          activeTroop.startMove(province.getID());
        }
      }
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
