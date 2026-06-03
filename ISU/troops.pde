class Troop {
  static final int ICON_SIZE = 32;
  static final float SPEED_FACTOR = 100;
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
    updateDistance();
    progress = 0;
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
    progress += SPEED_FACTOR*speed/distance;
    println("Progress is " + progress);
    if (progress >= 1) {
      currStop ++;
      location = path.get(currStop);
      updateDistance();
      progress = 0;
    }
  }
  void drawTroop() {
    float[] screenCentre = posToScreenSpace(provinces.get(location).getCentre());
    fill(#3D4127);
    rect(screenCentre[0], screenCentre[1], ICON_SIZE, ICON_SIZE);
  }



  void handleTroop() {
    if (target != location) {
      moveTroop();
    }
    drawTroop();
  }

  int getLocation(){
    return location;
  }




  boolean trySelectTroop() {
    float[] testLocation = new float[]{mouseX, mouseY};
    float[] provLocation = posToScreenSpace(provinces.get(location).getCentre());
    if (testLocation[0] >= provLocation[0] && testLocation[0] <= provLocation[0] + ICON_SIZE && testLocation[1] >= provLocation[1] && testLocation[1] <= provLocation[1] + ICON_SIZE) {
      return true;
    }
    return false;
  }
}

void createCavalry(int location, int owner) {
  troops.add(new Troop(100, 15, 30, location, owner));
}
