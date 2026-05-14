// Initialize one of each card
Deck deck;
Card card;
Hand hand;

// Sets current state to 0, and have the default guess be incorrect
int stateCounter = 0; //0 is drawing, 1 is getting guess, 2 is has guess
boolean correct = false;

// Reset the program
void reset() {
  stateCounter = 0;
  correct = false;
  background(#FFFFFF);
  deck.newShuffled();
  hand.clearHand();
  hand.addCard(deck.dealCard());
}


void setup() {
  size(800, 600);
  fill(#000000);
  textSize(50);
  background(#FFFFFF);

  // Initialize and shuffle the deck and hand
  deck = new Deck();
  hand = new Hand();

  deck.shuffleDeck();
}

// draw loop, actions based on state counter
void draw() {
  if (stateCounter == 0) { // first loop, shuffle deck, and draw card
    deck.newShuffled();
    Card currentCard = deck.dealCard();
    hand.addCard(currentCard);
    stateCounter++;
    hand.getCard(0).drawCard(width/2-50, height/2-50, false);
  } else if (stateCounter == 1) { // second loop, gets user guess
    int guess = getInt("What suit do you think it is? \n (0 - Spades, 1 - Hearts, 2 - Diamonds, 3 - Clubs)");
    if (guess == hand.getCard(0).getSuit()) correct = true;
    stateCounter++;
    println(correct);
  } else if (stateCounter == 2) { // shows sucess of guess as the result on the screen
    hand.getCard(0).drawCard(width/2-50, height/2-50, true);
    if (correct) {
      text("Congratulations! You are correct", 250, 200);
    } else text("Try again", 250, 200);

    text("Press r to reset", 250, 400);
    stateCounter++;
  }
}

void keyPressed() { // on r being pressed initialize reset
  if (key == 'r' && stateCounter >= 2) {
    reset();
  }
}
