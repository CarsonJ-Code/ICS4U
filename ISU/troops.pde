class Troop {
  static final int ICON_SIZE = 32;
  static final float SPEED_FACTOR = 100;
  int maxHealth;
  float currHealth;
  float strength;
  int speed;
  int location;
  int owner;
  PImage icon;

  // movement variables
  int currStop;
  int target; float distance;
  float progress;
  ArrayList<Integer> path;

  Troop(int maxHealth, int strength, int speed, int location, int owner) {
    this.maxHealth = maxHealth;
    this.currHealth = maxHealth;
    this.strength = strength;
    this.speed = speed;
    this.location = location;
    this.owner = owner;
    this.target = location;
    this.icon = loadImage("sword.png");
  }

  void startMove(int target) {
    this.target = target;
    path = provinceGraph.shortestPath(location, target);
    currStop = 0;
    updateDistance();
    progress = 0;
  }

  void updateDistance() {
    float[] centre1 = provinces.get(path.get(currStop)).getCentre();
    float[] centre2 = provinces.get(path.get(currStop + 1)).getCentre();
    distance = dist(centre1[0], centre1[1], centre2[0], centre2[1]);
  }

  void moveTroop() {
    progress += SPEED_FACTOR*speed/distance;
    if (progress >= 1) {
      currStop++;
      location = path.get(currStop);
      progress = 0;
      handleTroopOnProvince();

      if (currStop < path.size() - 1) {
        updateDistance();
      } else {
        activeTroop = null;
      }
    }
  }

  void drawTroop() {
    float[] screenCentre = posToScreenSpace(provinces.get(location).getCentre());
    fill(#3D4127);
    rect(screenCentre[0], screenCentre[1], ICON_SIZE, ICON_SIZE);
    image(icon, screenCentre[0], screenCentre[1], ICON_SIZE, ICON_SIZE);
  }



  void handleTroop() {
    if (target != location) {
      moveTroop();
    }
    drawTroop();
    handleTroopOnProvince();
  }

  int getLocation() {
    return location;
  }

  int getTarget() {
    return target;
  }
  int getOwner() {
    return owner;
  }
  float getStrength() {
    return strength;
  }
  void removeHealth(float damageAmount) {
    currHealth -= damageAmount;
  }
  float getHealth() {
    return currHealth;
  }




  boolean trySelectTroop() {
    float[] testLocation = new float[]{mouseX, mouseY};
    float[] provLocation = posToScreenSpace(provinces.get(location).getCentre());
    if (testLocation[0] >= provLocation[0] && testLocation[0] <= provLocation[0] + ICON_SIZE && testLocation[1] >= provLocation[1] && testLocation[1] <= provLocation[1] + ICON_SIZE) {
      return true;
    }
    return false;
  }

  void handleTroopOnProvince() {
    boolean battle = false;
    for (Troop troop : troops) {
      if (troop.getLocation() == location && troop.getOwner() != owner) {
        battle = true;
      }
    }
    if (battle) {
      println("Handling a battle in " + location);

      handleBattle(location);
    } else {
      provinces.get(location).setController(owner);
    }
  }
}

void createCavalry(int location, int owner) {
  troops.add(new Troop(100, 15, 30, location, owner));
}
void createLevy(int location, int owner){
  troops.add(new Troop(250, 5, 10, location, owner));
}
void createMercenary(int location, int owner){
  troops.add(new Troop(200, 10, 15, location, owner));
}
void createArcher(int location, int owner){
  troops.add(new Troop(50, 25, 15, location, owner));
}

void handleBattle(int battleLocation) {
  ArrayList<Troop> belligerants = new ArrayList<Troop>();
  for (Troop troop : troops) {
    if (troop.getLocation() == battleLocation) belligerants.add(troop);
  }
  for (Troop belligerant : belligerants) {
    Troop target;
    do {
      target = belligerants.get(int(random(belligerants.size())));
    } while (target.getOwner() == belligerant.getOwner());
    float damageAmount = belligerant.getStrength() + random(-5,5);
    target.removeHealth(damageAmount);
  }
}

void bringOutYourDead() {
  ArrayList<Troop> deadTroops = new ArrayList<Troop>();
  for (Troop troop : troops) {
    if (troop.getHealth() <= 0) {
      deadTroops.add(troop);
    }
  }
  for (Troop troop : deadTroops) {
    troops.remove(troop);
  }
}
