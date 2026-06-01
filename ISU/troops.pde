class Troop {
  int maxHealth;
  int currHealth;
  int strength;
  int speed;
  int location;
  int nextStop;
  int target;
  int owner;
  float distance;
  
  float progress;

  Troop(int maxHealth, int strength, int speed, int location, int owner) {
    this.maxHealth = maxHealth;
    this.strength = strength;
    this.speed = speed;
    this.location = location;
    this.owner = owner;
  }
  
  void startMove(){
   float[] centre1 = provinces.get(location).getCentre();
   float[] centre2 = provinces.get(nextStop).getCentre();
   distance = dist(centre1[0], centre1[1], centre2[0], centre2[1]);
  }
  
  void moveTroop() {
    progress += speed/distance;
    if(progress >= 1){
      
    }
  }
}
