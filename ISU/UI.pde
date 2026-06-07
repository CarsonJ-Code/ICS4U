
class TextElement {
  int[] TL;
  int[] dimensions;
  String text;
  int textSize;
  color textColour;
  boolean isActive = true;

  void setText(String newText) {
    text = newText;
  }

  TextElement(int[] TLArg, int[] dimensionsArg, String textArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    text = textArg;
    textSize = 12;
    textColour = #000000;
  }
  TextElement(int[] TLArg, int[] dimensionsArg, String textArg, int textSizeArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    text = textArg;
    textSize = textSizeArg;
    textColour = #000000;
  }
  TextElement(int[] TLArg, int[] dimensionsArg, String textArg, int textSizeArg, color textColourArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    text = textArg;
    textSize = textSizeArg;
    textColour = textColourArg;
  }

  void drawText() {
    textSize(textSize);
    fill(textColour);
    text(text, TL[0], TL[1], TL[0] + dimensions[0], TL[1] + dimensions[1]);
  }

  boolean getActivity() {
    return isActive;
  }
  void setActivity(boolean newActivity) {
    isActive = newActivity;
  }
}


class RectElement {
  int[] TL;
  int[] dimensions;
  color fillColour;
  int strokeWidth;
  color strokeColour;
  boolean isActive = true;

  RectElement(int[] TLArg, int[] dimensionsArg, color colourArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    fillColour = colourArg;
    strokeWidth = 0;
    strokeColour = #000000;
  }
  RectElement(int[] TLArg, int[] dimensionsArg, color colourArg, int strokeArg, color strokeColourArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    fillColour = colourArg;
    strokeWidth = strokeArg;
    strokeColour = strokeColourArg;
  }


  void drawRect() {
    strokeWeight(strokeWidth);
    stroke(strokeColour);
    fill(fillColour);
    rect(TL[0], TL[1], dimensions[0], dimensions[1]);
  }
  boolean getActivity() {
    return isActive;
  }
  void setActivity(boolean newActivity) {
    isActive = newActivity;
  }
}

class ImageElement {
  int[] TL;
  int[] dimensions;
  PImage image;
  boolean isActive = true;

  ImageElement(int[] TLArg, int[] dimensionsArg, PImage imageArg) {
    TL = TLArg;
    dimensions = dimensionsArg;
    image = imageArg;
  }

  boolean getActivity() {
    return isActive;
  }
  void setActivity(boolean newActivity) {
    isActive = newActivity;
  }


  void drawImage() {
    image(image, TL[0], TL[1], dimensions[0], dimensions[1]);
  }
}

void handleDrawTroopUI() {
  if (troopSelectedFlag && activeTroop != null) {
    activeTroopOwner.setText(getFactionName(activeTroop.getOwner()));
    activeTroopHealth.setText("Health: " + activeTroop.getHealth());
    activeTroopStrength.setText("Strength: " + activeTroop.getStrength());
  } else if (activeTroop == null) {
    troopSelectedFlag = false;
  }

  activeTroopInfo.setActivity(troopSelectedFlag);
  activeTroopOwner.setActivity(troopSelectedFlag);
  activeTroopHealth.setActivity(troopSelectedFlag);
  activeTroopStrength.setActivity(troopSelectedFlag);

  if (troopSelectedFlag) {
    activeTroopInfo.drawRect();
    activeTroopOwner.drawText();
    activeTroopHealth.drawText();
    activeTroopStrength.drawText();
  }
}


void handleDrawProvinceUI() {
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
    provinceController.setText(getFactionName(activeProvince.getController()));
    provinceController.drawText();

    provinceNeighbours.setText(provinceGraph.neighboursAsString(activeProvinceID));
    provinceNeighbours.drawText();
  }
}

void handleDrawWealthUI(){
  wealthBox.drawRect();
  wealthValue.setText(str(factionWealth[playerFaction-1]));
  wealthValue.drawText();
  wealthSymbol.drawImage();
}