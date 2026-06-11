final int ARCHER_COST = 100;
final int CAVALRY_COST = 100;
final int LEVY_COST = 100;
final int MERCENARY_COST = 100;


void handleSummonTest() {
  if (activeProvince != null && activeProvince.getController() == playerFaction) {
    if (summonArcher.isClicked(mouseX, mouseY)) summonArcher(playerFaction, activeProvinceID);
    else if (summonLevy.isClicked(mouseX, mouseY)) summonLevy(playerFaction, activeProvinceID);
    else if (summonCavalry.isClicked(mouseX, mouseY)) summonCavalry(playerFaction, activeProvinceID);
    else if (summonMercenary.isClicked(mouseX, mouseY)) summonMercenary(playerFaction, activeProvinceID);
  }
}


void summonArcher(int faction, int provinceID) {
  if (factionWealth[faction-1] >= ARCHER_COST) {
    factionWealth[faction-1] -= ARCHER_COST;
    createArcher(provinceID, faction);
  }
}
void summonCavalry(int faction, int provinceID) {
  if (factionWealth[faction-1] >= CAVALRY_COST) {
    factionWealth[faction-1] -= CAVALRY_COST;
    createCavalry(provinceID, faction);
  }
}
void summonMercenary(int faction, int provinceID) {
  if (factionWealth[faction-1] >= MERCENARY_COST) {
    factionWealth[faction-1] -= MERCENARY_COST;
    createMercenary(provinceID, faction);
  }
}
void summonLevy(int faction, int provinceID) {
  if (factionWealth[faction-1] >= LEVY_COST) {
    factionWealth[faction-1] -= LEVY_COST;
    createLevy(provinceID, faction);
  }
}
