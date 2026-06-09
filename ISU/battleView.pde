void showBattle(ArrayList<Troop> belligerants) {
  // grey rectangle, troop images for side 1, 2, health bars
  fill(#444444);
  rect(0, 150, 750, 300);
  fill(getFactionColour(1));
  rect(30, 160, 200, 10);
  fill(getFactionColour(2));
  rect(260, 160, 200, 10);
  fill(getFactionColour(3));
  rect(500, 160, 200, 10);
  for (Troop troop : belligerants) {
    int[] location = new int[]{-225 + 240*troop.getOwner(), 200};
    troop.drawTroopStats(location);
  }
}
