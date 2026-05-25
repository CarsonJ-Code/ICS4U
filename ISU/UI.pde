
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

//class Element {
//  ArrayList<RectElement> rects;
//  ArrayList<TextElement> texts;
//  ArrayList<ImageElement> images;
//  boolean isActive;

//  Element() {
//  }

//  Element(ArrayList<RectElement> rectsArg, ArrayList<TextElement> textsArg, ArrayList<ImageElement> imagesArg) {
//    rects = rectsArg;
//    texts = textsArg;
//    images = imagesArg;
//  }

//  void drawElement() {
//    drawRects();
//    drawImages();
//    drawTexts();
//  }

//  void drawRects() {
//    for (RectElement rect : rects) {
//      rect.drawRect();
//    }
//  }
//  void drawTexts() {
//    for (TextElement text : texts) {
//      text.drawText();
//    }
//  }
//  void drawImages() {
//    for (ImageElement img : images) {
//      img.drawImage();
//    }
//  }
//}
