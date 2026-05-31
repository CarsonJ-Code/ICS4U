String activeProvinceName;
Graph provinceGraph;

void setup() {
  size(1600, 900);
  provinceGraph = new Graph();
  loadProvinces();
  for (Province province : provinces) province.findBounding();

  initProvinceView();
  
  populateEdges();
}


void draw() {
  background(#ECE3A1);
  handleCamera();
  fill(#C4106A);

  // draw provinces
  Province activeProvince = null;
  boolean foundProvince = false;
  strokeWeight(1);
  for (Province province : provinces) {
    if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
      foundProvince = true;
      fill(#FFFFFF);
      activeProvinceName = province.getName();
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
    provinceName.setText(activeProvinceName);
    provinceName.drawText();
    provinceController.setText(activeProvince.getController());
    provinceController.drawText();
    provinceNeighbours.setText(provinceGraph.neighboursAsString(activeProvinceName));
    provinceNeighbours.drawText();
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
