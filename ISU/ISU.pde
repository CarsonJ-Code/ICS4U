String activeProvinceName;
int activeProvinceID;
Graph provinceGraph;
Province activeProvince;
ArrayList<Troop> troops;

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
  createCavalry(1,0);
}


void draw() {
  background(#ECE3A1);
  handleCamera();
  fill(#C4106A);

  // draw provinces
  boolean foundProvince = false;
  strokeWeight(1);
  for (Province province : provinces) {
    if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
      foundProvince = true;
      fill(#FFFFFF);
      activeProvinceName = province.getName();
      activeProvinceID = provinceIDs.get(activeProvinceName);
      activeProvince = province;
    }

    province.draw();
    fill(#C4106A);
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
}

void mouseReleased() {

  if (mouseButton == CENTER) {
    holdingPan = false;
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
