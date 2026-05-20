

void setup(){
  size(1600, 900);
  loadProvinces();
}
void draw(){
  background(#006994);
  handleCamera();
  fill(color(#BA4779));

  for(Province p: provinces){
    p.draw();
  }
}  
