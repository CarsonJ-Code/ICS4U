String activeProvinceName;
void setup() {
  size(1600, 900);
  loadProvinces();
  for (Province province : provinces) province.findBounding();

  initProvinceView();
}

void draw() {
  background(#0B2B43);
  handleCamera();
  fill(#C4106A);

  // draw provinces
  boolean foundProvince = false;
  for (Province province : provinces) {
    if (province.inProvince(screenSpaceToPos(new float[]{mouseX, mouseY}))) {
      foundProvince = true;
      fill(#FFFFFF);
      activeProvinceName = province.getName();
    }

    province.draw();
    fill(#C4106A);
  }

  provinceBox.setActivity(foundProvince);
  provinceName.setActivity(foundProvince);

  // draw province panel
  if (provinceBox.getActivity()) provinceBox.drawRect();
  provinceName.setText(activeProvinceName);
  if(provinceName.getActivity()) provinceName.drawText();
}
