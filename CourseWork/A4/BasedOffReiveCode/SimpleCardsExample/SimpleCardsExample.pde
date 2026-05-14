void setup()
{
  size(800, 600);
  background(255, 255, 255);
  Deck deck = new Deck ();

  Card currentCard = null; //Declare new Card which stores a card.
  int cardCount = 0; // To show the card index while deal.

  println ("Print the contents of a new deck where cards are inorder.");
  while (deck.cardsLeft () > 0)
  {
    currentCard = deck.dealCard ();
    cardCount++;
    println ("Card number: " + cardCount + " is: " + currentCard.toString ());
  }
}
