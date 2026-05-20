PImage testImg;

void setup(){
  size(1600, 900);
  background(color(#FFFFFF));
  testImg = loadImage("test.png");
  loadProvinces();

}

void draw(){
  println("mouse is at: (" + xScreenToPos(mouseX) + " , " + yScreenToPos(mouseY) +" )" + '\n' + "The zoom is " + zoom);
  background(#006994);
  handleCamera();
  fill(color(#BA4779));

  for(Province p: provinces){
    p.draw();
  }
}  
