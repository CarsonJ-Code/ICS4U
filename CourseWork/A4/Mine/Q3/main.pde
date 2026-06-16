// Carson Jones
// March 2nd, 2025
// Blackjack game


// ── Global objects ──────────────────────────────────────────────────────────
Deck deck;          // The deck of cards used in the game
Card card;          // Generic card reference
Hand playerHand;    // Holds the player's current cards
Hand dealerHand;    // Holds the dealer's current cards

// Action buttons shown during the player's turn
Button hit;
Button stand;
Button doubleDown;
Button insurance;

// ── Game state variables ─────────────────────────────────────────────────────
int bet = 0;        // Current bet placed by the player
int tokens = 100;   // Player's token balance (starts at 100)

int playerSum = 0;  // Running blackjack value of the player's hand
int dealerSum = 0;  // Running blackjack value of the dealer's hand

// Fixed Y positions for rendering each hand on screen
final int PLAYER_HAND_Y = 475;
final int COMPUTER_HAND_Y = 25;

boolean paidBet = false; // Prevents the player from being paid out more than once per round

// Tracks which dealer cards are face-up (true = visible, false = hidden)
ArrayList<Boolean> dealerShow = new ArrayList<Boolean>();

// ── Game state machine ───────────────────────────────────────────────────────
// Represents every possible phase of a blackjack round
enum STATES {
  BET,          // Player is placing their bet
  PLAYER,       // Player's turn (hit / stand / double down)
  DEALER,       // Dealer plays automatically
  END,          // Round is over; determine winner
  PLAYER_WIN,   // Player won the round
  PLAYER_LOSS,  // Player lost the round
  TIE           // Round ended in a push (tie)
}
STATES currState = STATES.BET; // Game always starts in the BET phase


// Initializes (or re-initializes) both hands and deals opening cards
void setupHands() {
  // Create and shuffle a fresh deck
  deck = new Deck();
  deck.shuffleDeck();

  playerHand = new Hand();
  dealerHand = new Hand();
  dealerShow.clear(); // Reset card visibility list

  // Deal two cards each to the player and dealer (alternating, like real blackjack)
  for (int i = 0; i < 2; i++) {
    playerHand.addCard(deck.dealCard());
    dealerHand.addCard(deck.dealCard());
    dealerShow.add(false); // All dealer cards start face-down
  }
  
  // Reveal only the dealer's first card at the start
  dealerShow.set(0, true);
  
  // Check for a natural blackjack (21 on opening hand) for either side
  if (playerHand.bjSum() == 21) {
    currState = STATES.END;
  }
  if (dealerHand.bjSum() == 21) {
    currState = STATES.END;
  }
}

// Processing's built-in setup - runs once at launch
void setup() {
  size(800, 600);
  background(#FFFFFF);

  // Create deck (setupHands() will re-create it, but this prevents null references)
  deck = new Deck();
  deck.shuffleDeck();

  playerHand = new Hand();
  dealerHand = new Hand();

  // Deal the opening hands
  setupHands();

  // Initialize all action buttons with position, size, colour, and label
  hit        = new Button(700, 225, 100, 50, #FF0000, "HIT");
  stand      = new Button(700, 300, 100, 50, #00FF00, "STAND");
  doubleDown = new Button(700, 375, 100, 50, #FF00FF, "DOUBLE\nDOWN");
  insurance  = new Button(700, 200, 100, 50, #0000FF, "INSURANCE");

  reset(); // Begin the first round
}


// Processing's built-in draw loop - runs every frame
void draw() {
  background(#FFFFFF); // Clear the screen each frame
  switch(currState) {
    
    // Prompt the player for a bet amount, deduct it, then move to the player's turn
    case BET:
      bet = constrain(getInt("You have " + tokens + " tokens. What bet do you want?"), 0, tokens);
      tokens -= bet;
      currState = STATES.PLAYER;
      break;
  
    // Player's turn: render cards, buttons, and money display each frame
    case PLAYER:
      drawHands();
      drawButtons();
      drawMoney();
      break;
  
    // Dealer's turn: render cards and run the dealer's auto-play logic
    case DEALER:
      drawHands();
      dealerTurn();
      drawMoney();
      break;
  
    // Evaluate the final hands and transition to the correct outcome state
    case END:
      testEnd();
      break;
  
    // Player won - show all cards and a WIN message
    case PLAYER_WIN:
      revealDealer();
      text("WIN", 300, 400);
      drawHands();
      text("r to play again", 300, 500);
      break;
  
    // Player lost - show all cards and a LOSS message
    case PLAYER_LOSS:
      revealDealer();
      text("LOSS", 300, 400);
      text("r to play again", 300, 500);
      drawHands();
      break;
  
    // Tie - show all cards and a TIE message
    case TIE:
      revealDealer();
      text("TIE", 300, 400);
      drawHands();
      break;

    default:
      break;
  }
}

// Compares final hand scores and transitions to PLAYER_WIN, PLAYER_LOSS, or TIE;
// also awards tokens accordingly (guarded by paidBet to prevent double payouts)
void testEnd() {
  revealDealer();
  int playerScore = playerHand.bjSum();
  int dealerScore = dealerHand.bjSum();
  if (playerScore == dealerScore) {
    currState = STATES.TIE;
    if (!paidBet) {
      tokens += bet;       // Return the original bet on a tie
      paidBet = true;
    }
  } else if (playerScore > dealerScore || dealerScore > 21) {
    currState = STATES.PLAYER_WIN;
    if (!paidBet) {
      tokens += 2 * bet;   // Return double the bet on a win
      paidBet = true;
    }
  } else {
    currState = STATES.PLAYER_LOSS; // Dealer wins; bet is already deducted
  }
}

// Checks the player's hand value after each card is drawn.
// Transitions to PLAYER_LOSS on bust (>21) or PLAYER_WIN on exactly 21.
// Returns true if the round should end immediately.
boolean checkSumPlayer() {
  if (playerSum < 21) {
    // Still in play - do nothing
  } else if (playerSum > 21) {
    currState = STATES.PLAYER_LOSS; // Bust
    return true;
  } else {
    currState = STATES.PLAYER_WIN;  // Exactly 21
  }
  return false;
}

// Checks the dealer's hand value after each card is drawn.
// The dealer must stop at 17 or above (standard blackjack rule).
// Returns true if the dealer's turn is over.
boolean checkSumDealer() {
  if (dealerSum >= 17) {
    currState = STATES.END; // Dealer stands; move to END to compare hands
    return true;
  }
  return false;
}


// Renders all cards in both hands at evenly spaced horizontal positions
void drawHands() {
  // Draw each player card face-up
  for (int i = 0; i < playerHand.getHandCount(); i++) {
    playerHand.getCard(i).drawCard(i*(width/playerHand.getHandCount()), PLAYER_HAND_Y, true);
  }
  // Draw each dealer card; visibility is controlled by the dealerShow list
  for (int i = 0; i < dealerHand.getHandCount(); i++) {
    dealerHand.getCard(i).drawCard(i*(width/dealerHand.getHandCount()), COMPUTER_HAND_Y, dealerShow.get(i));
  }
}

// Renders the Hit, Stand, and Double Down action buttons
void drawButtons() {
  hit.draw();
  stand.draw();
  doubleDown.draw();
}

// Displays the player's current token balance and active bet on screen
void drawMoney() {
  text("Tokens: " + tokens, 700, 100);
  text("Bet: " + bet, 700, 150);
}

// Handles mouse click events - only active during the player's turn
void mouseReleased() {
  if (currState == STATES.PLAYER) {
    if      (hit.isClicked(mouseX, mouseY))        hitButton();
    else if (stand.isClicked(mouseX, mouseY))      standButton();
    else if (doubleDown.isClicked(mouseX, mouseY)) doubleDownButton();
  }
}

// HIT: deals one card to the player, then checks for bust or 21
void hitButton() {
  playerHand.addCard(deck.dealCard());
  playerSum = playerHand.bjSum();
  delay(500); // Brief pause for visual feedback
  if (checkSumPlayer()) return; // End turn immediately on bust or 21
}

// STAND: end the player's turn and pass control to the dealer
void standButton() {
  currState = STATES.DEALER;
  dealerShow.set(1, true); // Reveal the dealer's hidden second card
  delay(1000);             // Pause before the dealer starts playing
}

// DOUBLE DOWN: double the bet, take exactly one more card, then stand
void doubleDownButton() {
  bet *= 2;       // Double the current bet
  tokens -= bet;  // Deduct the additional amount from the player's balance
  hitButton();    // Deal one card (handles bust/21 check internally)
  if (checkSumPlayer()) return; // If bust, don't force a stand
  standButton();  // Automatically stand after the one card
}

// Dealer's auto-play logic: keeps drawing until reaching 17 or above
void dealerTurn() {
  delay(500); // Pause between dealer draws for visual pacing
  dealerSum = dealerHand.bjSum();
  if (checkSumDealer()) return; // Already at 17+; end dealer turn
  if (currState == STATES.DEALER) {
    dealerHand.addCard(deck.dealCard()); // Draw another card
    dealerShow.add(true);                // New dealer cards are always face-up
    if (checkSumDealer()) return;        // Re-check after drawing
  }
}

// Keyboard shortcuts: 'r' restarts the game after a round ends;
// 't' tops up tokens to 100 when the player is broke
void keyPressed() {
  // Allow restart only when the round has concluded
  if (currState == STATES.PLAYER_WIN || currState == STATES.PLAYER_LOSS || currState == STATES.TIE) {
    if (key == 'r') reset();
  }
  // Emergency top-up when the player runs out of tokens
  if (tokens == 0) {
    if (key == 't') {
      tokens += 100;
    }
  }
}

// Resets all round-specific state and starts a fresh round
void reset() {
  bet = 0;
  setupHands();           // Deal new hands
  currState = STATES.BET; // Return to the betting phase
  paidBet = false;        // Allow the next payout

  // Recalculate hand values for the fresh deal
  playerSum = playerHand.bjSum();
  dealerSum = dealerHand.bjSum();

  // If the new deal immediately triggers an end condition, reset again
  if (checkSumDealer()) reset();
  if (checkSumPlayer()) reset();
}

// Flips all dealer cards face-up (called when the round ends)
void revealDealer() {
  for (int i = 0; i < dealerShow.size(); i++) {
    dealerShow.set(i, true);
  }
}
