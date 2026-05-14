class Hand
{
  
  // Hold the list of cards in the hand
  ArrayList<Card> hand;

  // Construct hand by creating an ArrayList
  Hand() {
    hand = new ArrayList<Card>();
  }

  // Randomize the order of cards in the hand
  void shuffleHand() {

    ArrayList<Card> shuffledHand = new ArrayList<Card> ();
    int index;

    for (int remaining = hand.size (); remaining >= 1; remaining--) {
      index = (int) (random(1) * remaining);
      shuffledHand.add(hand.remove(index));
    }
    hand = shuffledHand;
  }
  
  // return card at a given position
  Card getCard(int i) {
    return hand.get(i);
  }
  
  // empties hand
  void clearHand() {
    hand.clear();
  }

  // adds card to hand
  void addCard(Card cardArg) {
    hand.add(cardArg);
  }

  // removes a given card from hand
  void removeCard(Card cardArg) {
    hand.remove(cardArg);
  }
  
  // removes a given card provided the position exists
  Card removeCard(int position) {
    if (position < 0 || position >= hand.size ()) throw new RuntimeException("Poistion does not exist");
    return hand.remove(position);
  }
  
  // returns number of cards in hand
  int getHandCount() {
    return hand.size();
  }
  
  // sorts hands by suit
  void sortSuit() {
    {
      ArrayList<Card> sortedHand = new ArrayList<Card> ();
      while (hand.size () > 0)
      {
        int pos = 0;  // Position of minimal card.
        Card c = (Card) hand.get (0); // Minimal card.
        for (int i = 1; i < hand.size (); i++)
        {
          Card c1 = (Card) hand.get (i);
          if (c1.getSuit () < c.getSuit () || (c1.getSuit () == c.getSuit () && c1.getValue () < c.getValue ()))
          {
            pos = i;
            c = c1;
          }
        }
        hand.remove (pos);
        sortedHand.add (c);
      }
      hand = sortedHand;
    }
  }
  
  // sorts hands by value
  void sortValue() {
    ArrayList<Card> sortedHand = new ArrayList<Card> ();
    while (hand.size () > 0)
    {
      int pos = 0;  // Position of minimal card.
      Card c = (Card) hand.get (0); // Minumal card.
      for (int i = 1; i < hand.size (); i++)
      {
        Card c1 = (Card) hand.get (i);
        if (c1.getValue () < c.getValue () ||
          (c1.getValue () == c.getValue () && c1.getSuit () < c.getSuit ()))
        {
          pos = i;
          c = c1;
        }
      }
      hand.remove (pos);
      sortedHand.add (c);
    }
    hand = sortedHand;
  }
}
