PImage testImg;

void setup(){
  size(1600, 900);
  background(color(#FFFFFF));
  testImg = loadImage("test.png");
  loadProvinces();

}

void draw(){
  background(255);
  handleCamera();
  fill(color(#000000));
  float[] screenPos = posToScreenSpace(new float[]{0, 0});
  rect(screenPos[0], screenPos[1], 20/zoom, 20/zoom);
  
  for(Province p: provinces){
    p.draw();
  }
}  
