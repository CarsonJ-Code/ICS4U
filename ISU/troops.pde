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
    this.target = location;
  }

  void startMove(int target) {
    this.target = target;
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
  void drawTroop() {
    float[] screenCentre = posToScreenSpace(provinces.get(location).getCentre());
    fill(#3D4127);
    rect(screenCentre[0], screenCentre[1], 16, 16); // smaller marker so it's visible
  }



  void handleTroop() {
    if(target != location){
    moveTroop();
    }
    drawTroop();
  }
}

void createCavalry(int location, int owner){
  troops.add(new Troop(100, 15, 30, location, owner));
}