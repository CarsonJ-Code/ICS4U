ArrayList<Integer> battles = new ArrayList<Integer>();

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

  boolean inBattle = false;

  // movement variables
  int currStop;
  int target;
  float distance;
  float progress;
  ArrayList<Integer> path;

  Troop(int maxHealth, float strength, int speed, int location, int owner, PImage icon) {
    this.maxHealth = maxHealth;
    this.currHealth = maxHealth;
    this.strength = strength;
    this.speed = speed;
    this.location = location;
    this.owner = owner;
    this.target = location;
    this.icon = icon;
  }

  void startMove(int target) {
    this.target = target;
    path = provinceGraph.shortestPath(location, target);
    if (path == null || path.size() < 2) {
      // No valid path to the target or no movement needed.
      path = new ArrayList<Integer>();
      currStop = 0;
      distance = 0;
      progress = 0;
      return;
    }
    currStop = 0;
    updateDistance();
    progress = 0;
  }

  void updateDistance() {
    if (path == null || path.size() < 2 || currStop >= path.size() - 1) {
      distance = 0;
      return;
    }
    float[] centre1 = provinces.get(path.get(currStop)).getCentre();
    float[] centre2 = provinces.get(path.get(currStop + 1)).getCentre();
    distance = dist(centre1[0], centre1[1], centre2[0], centre2[1]);
  }

  void moveTroop() {
    if (distance <= 0) return;
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
        troopSelectedFlag = false;
      }
    }
  }

  void drawTroop() {
    float[] screenCentre = posToScreenSpace(provinces.get(location).getCentre());
    fill(getFactionColour(owner));
    rect(screenCentre[0], screenCentre[1], ICON_SIZE, ICON_SIZE);
    image(icon, screenCentre[0], screenCentre[1], ICON_SIZE, ICON_SIZE);
  }

  void drawTroopStats(int[] screenLocation) {
    // icon to right, health bar, strength number
    image(icon, screenLocation[0], screenLocation[1], 50, 50);
    fill(#FF0000);
    rect(screenLocation[0] + 75, screenLocation[1], 125, 10);
    fill(#00FF00);
    rect(screenLocation[0] + 75, screenLocation[1], 125*currHealth/maxHealth, 10);
    fill(#FFFFFF);
    textSize(24);
    text("Strength: " + nf(strength*currHealth/maxHealth, 0, 1), screenLocation[0] + 75, screenLocation[1] + 50);
  }



  void handleTroop() {
    if (isWalking()) {
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
  void addHealth(float healingAmount) {
    currHealth += healingAmount;
    if (currHealth > maxHealth) currHealth = maxHealth;
  }
  float getHealth() {
    return currHealth;
  }
  float getMaxHealth() {
    return maxHealth;
  }
  void setInBattle(boolean newVal) {
    inBattle = newVal;
  }
  boolean getInBattle() {
    return inBattle;
  }
  boolean isWalking() {
    return(location != target);
  }




  boolean trySelectTroop() {
    float[] testLocation = new float[]{mouseX, mouseY};
    float[] provLocation = posToScreenSpace(provinces.get(location).getCentre());
    if (owner == playerFaction && testLocation[0] >= provLocation[0] && testLocation[0] <= provLocation[0] + ICON_SIZE && testLocation[1] >= provLocation[1] && testLocation[1] <= provLocation[1] + ICON_SIZE) {
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
      if (!battles.contains(location)) battles.add(location);
    } else {
      provinces.get(location).setController(owner);
    }
  }
}

void createCavalry(int location, int owner) {
  troops.add(new Troop(200, 1.5, 30, location, owner, loadImage("images/cavalry.png")));
}
void createLevy(int location, int owner) {
  troops.add(new Troop(500, 0.5, 10, location, owner, loadImage("images/levy.png")));
}
void createMercenary(int location, int owner) {
  troops.add(new Troop(400, 1, 15, location, owner, loadImage("images/mercenary.png")));
}
void createArcher(int location, int owner) {
  troops.add(new Troop(100, 2.5, 15, location, owner, loadImage("images/archer.png")));
}

void handleBattle(int battleLocation) {
  ArrayList<Troop> belligerants = new ArrayList<Troop>();
  for (Troop troop : troops) {
    if (troop.getLocation() == battleLocation) belligerants.add(troop);
  }
  if (activeProvinceID == battleLocation) showBattle(belligerants);

  // Check if there are multiple factions at this location
  int factionCount = 0;
  ArrayList<Integer> factions = new ArrayList<Integer>();
  for (Troop troop : belligerants) {
    if (!factions.contains(troop.getOwner())) {
      factions.add(troop.getOwner());
      factionCount++;
    }
  }

  // Only fight if there are opposing factions
  if (factionCount > 1) {
    for (Troop belligerant : belligerants) {
      belligerant.setInBattle(true);
      Troop target;
      do {
        target = belligerants.get(int(random(belligerants.size())));
      } while (target.getOwner() == belligerant.getOwner());
      float damageAmount = belligerant.getStrength()*(belligerant.getHealth()/belligerant.getMaxHealth()) * random(0.8, 1.2);
      target.removeHealth(damageAmount);
    }
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

void handleTroopUpkeep() {
  if (frameNumber % 60 == 0) {
    for (Troop troop : troops) {
      int controller = troop.getOwner();
      factionWealth[controller-1]--;
    }
  }
}
