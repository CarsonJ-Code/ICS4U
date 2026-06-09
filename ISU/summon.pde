final int ARCHER_COST = 100;
final int CAVALRY_COST = 100;
final int LEVY_COST = 100;
final int MERCENARY_COST = 100;


void handleSummonTest() {
  if (activeProvince != null) {
    if (summonArcher.isClicked(mouseX, mouseY)) summonArcher();
    else if (summonLevy.isClicked(mouseX, mouseY)) summonLevy();
    else if (summonCavalry.isClicked(mouseX, mouseY)) summonCavalry();
    else if (summonMercenary.isClicked(mouseX, mouseY)) summonMercenary();
  }
}


void summonArcher() {
  if (factionWealth[playerFaction-1] >= ARCHER_COST) {
    factionWealth[playerFaction-1] -= ARCHER_COST;
    createArcher(activeProvinceID, playerFaction);
  }
}
void summonCavalry() {
  if (factionWealth[playerFaction-1] >= CAVALRY_COST) {
    factionWealth[playerFaction-1] -= CAVALRY_COST;
    createCavalry(activeProvinceID, playerFaction);
  }
}
void summonMercenary() {
  if (factionWealth[playerFaction-1] >= MERCENARY_COST) {
    factionWealth[playerFaction-1] -= MERCENARY_COST;
    createMercenary(activeProvinceID, playerFaction);
  }
}
void summonLevy() {
  if (factionWealth[playerFaction-1] >= LEVY_COST) {
    factionWealth[playerFaction-1] -= LEVY_COST;
    createLevy(activeProvinceID, playerFaction);
  }
}
