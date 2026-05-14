Deck myDeck;
Hand myHand;
Card back;

void setup()
{
  size(800, 600);
  background(#FFFFFF);
  Deck deck = new Deck ();

  Card currentCard = null; //Declare new Card which stores a card.
  int cardCount = 0; // To show the card index while deal.
  
  back = myDeck.cardBack;
  
  println ("Print the contents of a new deck where cards are in yorder.");
  while (deck.cardsLeft () > 0)
  {
    currentCard = deck.dealCard ();
    cardCount++;
    println ("Card number: " + cardCount + " is: " + currentCard.toString ());
  }
}

void draw() {
  Deck myDeck = new Deck();
  myDeck.shuffle();
  
  back.drawCard(100, 100);
  int guessedSuit = getInt("What suit do you think the card is? ");
  myHand.addCard(myDeck.dealCard());
  myHand.getCard(0).drawCard(100, 100);
  
  
  if(guessedSuit == myHand.getCard(0).getSuit()) println("You win!");
  else println("Try again.");
  
  char userDecision = getChar("Would you like to continue? (Y/n)");
  if (userDecision == 'n' || userDecision == 'N') exit();
  
  else {
    //background(#FFFFFF);
  }
}

// draw only updates at end of loop

void makeNewDeck(){
  Deck myDeck = new Deck();
  myDeck.shuffle();
}

void makeNewHand(){
    myHand = new Hand();
    back = myDeck.getCardBack();
}
