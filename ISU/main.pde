
void setup() {
  size(1600, 900);
  loadProvinces();
  for(Province province : provinces) province.findBounding();
}

void draw() {
  background(#0B2B43);
  handleCamera();
  fill(#C4106A);

  for (Province province : provinces) {
    if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
      fill(#FFFFFF);
      println(province.getName());
    }
    province.draw();
    fill(#C4106A);
  }  
}
