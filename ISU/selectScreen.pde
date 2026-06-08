void handleIntroScreen() {
  normanCrest.drawImage();
  angloCrest.drawImage();
  norseCrest.drawImage();
}
void handleIntroClick() {
  if (normanCrest.isClicked(mouseX, mouseY)) {
    playerFaction = 1;
    currState = gameState.play;
  } else if (angloCrest.isClicked(mouseX, mouseY)) {
    playerFaction = 2;
    currState = gameState.play;
  } else if (norseCrest.isClicked(mouseX, mouseY)) {
    playerFaction = 3;
    currState = gameState.play;
  }
}
