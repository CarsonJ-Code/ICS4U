String activeProvinceName;
int activeProvinceID;
Graph provinceGraph;
Province activeProvince;
ArrayList<Troop> troops;
Troop activeTroop;

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
}


void draw() {
  background(#ECE3A1);
  handleCamera();
  fill(#C4106A);

  // draw provinces
  boolean foundProvince = false;
  strokeWeight(1);
  for (Province province : provinces) {
    fill(#C4106A);
    province.draw();
  }
  provinceBox.setActivity(foundProvince);
  provinceName.setActivity(foundProvince);
  provinceController.setActivity(foundProvince);
  provinceNeighbours.setActivity(foundProvince);

  // draw province panel
  if (provinceBox.getActivity()) {
    provinceBox.drawRect();
    provinceName.setText(str(activeProvinceID));
    provinceName.drawText();
    provinceController.setText(activeProvince.getController());
    provinceController.drawText();

    provinceNeighbours.setText(provinceGraph.neighboursAsString(activeProvinceID));
    provinceNeighbours.drawText();
  }
  for (Troop troop : troops) {
    troop.handleTroop();
  }

  if (activeTroop != null) {
    drawVectorToMouse(provinces.get(activeTroop.getLocation()).getCentre());
  }
}


void drawVectorToMouse(float[] screenPos) {
  fill(255, 0, 0);
  stroke(255, 0, 0);
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
    if (activeTroop == null) {
      for (Troop troop : troops) {
        if (troop.trySelectTroop()) {
          activeTroop = troop;
          return;
        }
      }
      for (Province province : provinces) {
        if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
          fill(#FFFFFF);
          province.draw();
          activeProvinceName = province.getName();
          activeProvinceID = provinceIDs.get(activeProvinceName);
          activeProvince = province;
          return;
        }
      }
      activeProvince = null;
    } else {
      for (Province province : provinces) {
        if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
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
