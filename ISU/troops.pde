class Troop {
  int maxHealth;
  int currHealth;
  int strength;
  int speed;
  int location;
  int owner;

  // movement variables
  int currStop;
  int target;
  float distance;
  float progress;
  ArrayList<Integer> path;

  Troop(int maxHealth, int strength, int speed, int location, int owner) {
    this.maxHealth = maxHealth;
    this.strength = strength;
    this.speed = speed;
    this.location = location;
    this.owner = owner;
  }

  void startMove() {
    path = provinceGraph.shortestPath(location, target);
    currStop = 0;
  }

  void updateDistance() {
    float[] centre1 = provinces.get(path.get(currStop)).getCentre();
    float[] centre2 = provinces.get(path.get(currStop + 1)).getCentre();
    distance = dist(centre1[0], centre1[1], centre2[0], centre2[1]);
  }

  void moveTroop() {
    progress += speed/distance;
    if (progress >= 1) {
      currStop ++;
      location = path.get(currStop);
    }
  }
  void drawTroop(){
    float[] centre = provinces.get(location).getCentre();
    fill(#3D4127);
    rect(centre[0], centre[1], 50, 50);
  }

}

void handleTroops(){
  
}
