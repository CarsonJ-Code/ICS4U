// Carson Jones
// February 10, 2026
// Defines a Deck class that manages a collection of playing cards

class Deck
{
  // Stores all Card objects in the deck
  ArrayList<Card> deck;

  // Constructor that initializes a standard deck of cards
  Deck() {
    initializeDeck();
  }

  // Creates a new ordered deck of 52 cards
  void initializeDeck() {
    deck = new ArrayList<Card>();
    for (int suit = 0; suit <= 3; suit++) {
      for (int value = 0; value <= 12; value++) {
        deck.add(new Card(value, suit));
      }
    }
  }
  
  // Randomly shuffles the deck by removing cards into a new list
  void shuffleDeck(){
    ArrayList<Card> shuffledDeck = new ArrayList<Card> ();
    int index;
    
    for (int remaining = deck.size(); remaining >= 1; remaining--){
      index = (int)(random(1) * remaining);
      shuffledDeck.add(deck.remove(index));
    }
    deck = shuffledDeck;
  }
  
  // Resets the deck and shuffles it
  void newShuffled(){
    initializeDeck();
    shuffleDeck();
  }
  
  // Returns the number of cards left in the deck
  int cardsLeft(){
    return deck.size();
  }
  
  // Removes and returns the top card of the deck
  Card dealCard(){
    if(deck.size() == 0) throw new RuntimeException("Deck is empty");
    return deck.remove(0);
  }
}
