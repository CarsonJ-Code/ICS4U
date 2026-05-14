void cardDebug() {
  Card selectedCard = null;
  for (int i = 0; i < playerHand.getHandCount(); i++) {
    if (playerHand.getCard(i).isClicked(mouseX, mouseY)) {
      selectedCard = playerHand.getCard(i);
    }
  }
  for (int i = 0; i < computerHand.getHandCount(); i++) {
    if (computerHand.getCard(i).isClicked(mouseX, mouseY)) {
      selectedCard = computerHand.getCard(i);
    }
  }
  
  
  if (selectedCard != null) {
    selectedCard.setSuit(getInt("What suit"));
    selectedCard.setValue(getInt("What value"));
  }
}


void keyPressed(){
 if(key == ' ') pause = !pause; 
}
