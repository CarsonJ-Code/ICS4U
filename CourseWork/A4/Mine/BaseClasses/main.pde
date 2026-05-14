Deck deck;
Card card;
Hand hand;

void setup() {
  size(800, 600);
  background(#FFFFFF);
  deck = new Deck();
  
  deck.shuffleDeck();
  
  while(deck.cardsLeft() != 0){
   println(deck.dealCard().getCard()); 
  }
}
