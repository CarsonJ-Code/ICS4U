// Initilialize objects

boolean pause = false; // debug
boolean computerHasGuessed = false; // Ensures no multiple guesses


// y location of each hand
final int PLAYER_HAND_Y = 475;
final int COMPUTER_HAND_Y = 25;

// initialize scores
int playerScore = 0;
int computerScore = 0;

// initialize objects
Deck deck;
Card card;
Hand playerHand;
Hand computerHand;
Card selectedCard;

// define different game states
enum GAMESTATE {
  START,
    PLAYER,
    COMPUTER,
    END
}
GAMESTATE gamestate = GAMESTATE.START;

// populate hands
void setupHands() {
  for (int i = 0; i < 7; i++) {
    playerHand.addCard(deck.dealCard());
    computerHand.addCard(deck.dealCard());
  }
}

// draw hands to the screen
void drawHands() {
  for (int i = 0; i < playerHand.getHandCount(); i++) {
    playerHand.getCard(i).drawCard(i*(width/playerHand.getHandCount()), PLAYER_HAND_Y, true);
  }
  for (int i = 0; i < computerHand.getHandCount(); i++) {
    computerHand.getCard(i).drawCard(i*(width/computerHand.getHandCount()), COMPUTER_HAND_Y, false);
  }
}

// runs a debug function to dump hand contents into console
void printHand(boolean player) { // debug function
  if (player) {
    for (int i = 0; i < playerHand.getHandCount(); i++) {
      println(playerHand.getCard(i).getCard());
    }
  } else {
    for (int i = 0; i < computerHand.getHandCount(); i++) {
      println(computerHand.getCard(i).getCard());
    }
  }
}

// returns paired cards
ArrayList<Card> findPairs(Hand hand1) {
  int cardsInHand = hand1.getHandCount();

  ArrayList<Card> deletionCards = new ArrayList<Card>();

  boolean[] used= new boolean[cardsInHand];

  // loop through every card and compare its value to all others in hand. Ignore if it has already been used
  for (int i = 0; i < cardsInHand - 1; i++) {
    if (used[i]) continue;

    for (int j = i + 1; j < cardsInHand; j++) {

      if (used[j]) continue;

      if (hand1.getCard(i).getValue() == hand1.getCard(j).getValue()) {
        deletionCards.add(hand1.getCard(i));
        deletionCards.add(hand1.getCard(j));
        used[i] = true;
        used[j] = true;


        break;
      }
    }
  }
  return deletionCards;
}

// draws back of the deck to screen
void drawDeck() {
  if (deck.cardsLeft() > 0) {
    deck.drawDeck(20, 240);
  }
}

// draw scores to scren
void drawScores() {
  text("Player score: " + playerScore, 640, 450);
  text("Computer score: " + computerScore, 600, 175);
}

void setup() {
  // initialize screen paramaters
  size(800, 600);
  background(#FFFFFF);
  textSize(24);
  // init deck
  deck = new Deck();
  deck.shuffleDeck();

  playerHand = new Hand();
  computerHand = new Hand();

  setupHands();
}

void draw() {
  // draw to screen
  background(#FFFFFF);
  drawHands();
  drawDeck();
  drawScores();
  if (pause) {
  } else {
    if (playerHand.getHandCount() == 0 || computerHand.getHandCount() == 0 || deck.cardsLeft() == 0) gamestate = GAMESTATE.END;

    // calls appropriate game state
    if (gamestate == GAMESTATE.START) gamestate = GAMESTATE.PLAYER;
    else if (gamestate == GAMESTATE.PLAYER) playerTurn();
    else if (gamestate == GAMESTATE.COMPUTER) computerTurn();
    else if (gamestate == GAMESTATE.END) end();
  }
}
// runs computer turn
void computerTurn() {


  // score duplicates
  ArrayList<Card> deletionCardsComputer = findPairs(computerHand);
  int pairs = deletionCardsComputer.size() / 2;
  computerScore += pairs;

  // delete duplicates
  for (Card c : deletionCardsComputer) {
    computerHand.removeCard(c);
  }

  // runs check to ensure size != 0
  if (computerHand.getHandCount() == 0) {
    gamestate = GAMESTATE.END;
    return;
  }

  // make guess
  int compGuess = (int)random(0, computerHand.getHandCount());
  selectedCard = computerHand.getCard(compGuess);
  println("Computer guess: " + selectedCard.getCard());

  // search for guess
  int targetVal = selectedCard.getValue();
  for (int i = 0; i < playerHand.getHandCount(); i++) {
    if (playerHand.getCard(i).getValue() == targetVal) {
      computerHand.removeCard(selectedCard);
      playerHand.removeCard(playerHand.getCard(i));

      computerScore++;
      selectedCard = null;
      return;
    }
  }
  computerHand.addCard(deck.dealCard());
  selectedCard = null;
  gamestate = GAMESTATE.PLAYER;
  return;
}

void playerTurn() {
  // remove duplicates
  ArrayList<Card> deletionCardsPlayer = findPairs(playerHand);
  // loop through hands, remove cards
  int pairs = deletionCardsPlayer.size() / 2;
  playerScore += pairs;

  for (Card c : deletionCardsPlayer) {
    playerHand.removeCard(c);
  }

  // runs check to ensure size != 0
  if (playerHand.getHandCount() == 0) {
    gamestate = GAMESTATE.END;
    return;
  }

  if (selectedCard != null) {
    //println(selectedCard.getCard());
    int targetVal = selectedCard.getValue();
    for (int i = 0; i < computerHand.getHandCount(); i++) {
      if (computerHand.getCard(i).getValue() == targetVal) {
        playerHand.removeCard(selectedCard);
        computerHand.removeCard(computerHand.getCard(i));


        // increases player score and returns
        playerScore++;
        selectedCard = null;
        return;
      }
    }
    playerHand.addCard(deck.dealCard());
    selectedCard = null;
    gamestate = GAMESTATE.COMPUTER;
    return;
  }
}

// draws end screen
void end() {
  background(#FFFFFF);
  text("PLAYER SCORE:\n" + playerScore, 50, 200);
  text("COMPUTER SCORE:\n"+computerScore, 450, 200);
  if (playerScore > computerScore) text("You win!", 300, 400);
  else if (computerScore < playerScore) text("Computer wins", 250, 400);
  else text("Tie", 350, 400);
  text("press \'r\' to reset", 300, 500);
}

// on mouse click check paramaters
void mouseReleased() {
  if (mouseButton == RIGHT) { // enters debug state
    cardDebug();
  }
  if (gamestate == GAMESTATE.PLAYER) { // handle mouse clicks on cards
    for (int i = 0; i < playerHand.getHandCount(); i++) {
      if (playerHand.getCard(i).isClicked(mouseX, mouseY)) {
        selectedCard = playerHand.getCard(i);
      }
    }
  }
}
