int[] factionWealth = new int[] {0, 0, 0};
int playerFaction = 1;

String getFactionName(int factionID) {
  switch(factionID) {
  case 1:
    return "Anglo-Saxon";
  case 2:
    return "Norman";
  case 3:
    return "Noresman";
  default:
    return "None";
  }
}

color getFactionColour(int factionID) {
  switch(factionID) {
  case 1:
    return #C4106A;
  case 2:
    return #2D8AD3;
  case 3:
    return #23AF2B;
  default:
    return #787878;
  }
}

void doTaxLogic() {
  if (frameNumber % 60 == 0) {
    for (Province province : provinces) {
      int controller = province.getController();
      if(controller != 0) factionWealth[controller-1]++;
    }
  }
}
