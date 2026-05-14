/**
 * An object of type Card represents a playing card from a
 * standard Poker deck.  The card has a suit, which
 * can be spades, hearts, diamonds, or clubs.  A spade, heart,
 * diamond, or club has one of the 13 values: ace, 2, 3, 4, 5, 6, 7,
 * 8, 9, 10, jack, queen, or king.  Note that "ace" is considered to be
 * the smallest value.
 */
class Card
{
  PImage cardImage;
  final static int SPADES = 0;   // Codes for the 4 suits, plus Joker.
  final static int HEARTS = 1;
  final static int DIAMONDS = 2;
  final static int CLUBS = 3;

  final static int ACE = 1;      // Codes for the non-numeric cards.
  final static int JACK = 11;    //   Cards 2 through 10 have their
  final static int QUEEN = 12;   //   numerical values for their codes.
  final static int KING = 13;


  // This card's suit, one of the constants SPADES, HEARTS, DIAMONDS,
  // or CLUBS.  The suit cannot be changed after the card is constructed.
  final int suit;

  // The card's value.  For a normal cards, this is one of the values
  // 1 through 13, with 1 representing ACE. The value cannot be changed after the card is constructed.
  final int value;

  //Purpose: Creates a card with a specified suit and value.
  //Parameters: theValue - the value of the new card 1-13
  //            theSuit - suit of the new card Card.SPADES, Card.HEARTS, Card.DIAMONDS, Card.CLUBS
  //Returns: Nothing. The new card is created.
  Card (int theValue, int theSuit)
  {
    if (theSuit != SPADES && theSuit != HEARTS && theSuit != DIAMONDS && theSuit != CLUBS)
    {
      throw new IllegalArgumentException ("Illegal playing card suit");
    }
    if (theValue < 1 || theValue > 13)
    {
      throw new IllegalArgumentException ("Illegal playing card value");
    }
    value = theValue;
    suit = theSuit;
    String filename = "images\\" + suit + "-" + value + ".jpg";
    // FOR MAC String filename = "images/" + suit + "-" + value + ".jpg";
    cardImage = loadImage (filename); //Loads the image.
  }

  //Purpose: To get the suit of the card.
  //Parameters: None.
  //Returns: Returns the suit of this card which is one of the constants Card.SPADES,
  // Card.HEARTS, Card.DIAMONDS, Card.CLUBS.
  int getSuit ()
  {
    return suit;
  }


  //Purpose: To get the value of the card.
  //Parameters: None.
  //Returns: The value of the card, which is one the numbers 1 through 13.
  int getValue ()
  {
    return value;
  }



  //Purpose: Returns a String representation of the card's suit.
  //Parameters: None.
  //Returns: Returns one of the strings "Spades", "Hearts", "Diamonds", or "Clubs".
  String getSuitAsString ()
  {
    if (suit == 0)
    {
      return "Spades";
    } else if (suit == 1)
    {
      return "Hearts";
    } else if (suit == 2)
    {
      return "Diamonds";
    } else
      return "Clubs";
  }

  //Purpose: Returns a String representation of the card's value.
  //Parameters: None.
  //Returns: one of the strings "Ace", "2", "3", ..., "10", "Jack", "Queen", or "King".
  String getValueAsString ()
  {
    switch (value)
    {
    case 1:
      return "Ace";

    case 2:
      return "2";

    case 3:
      return "3";

    case 4:
      return "4";

    case 5:
      return "5";

    case 6:
      return "6";

    case 7:
      return "7";

    case 8:
      return "8";

    case 9:
      return "9";

    case 10:
      return "10";

    case 11:
      return "Jack";

    case 12:
      return "Queen";

    case 13:
      return "King";

    default:
      return "Invalid playing card value";
    }
  }


  //Purpose: Returns a string representation of this card, including both its suit and its value.
  //Parameters: None.
  //Returns: Returns a string such as "Queen of Hearts", "10 of Diamonds", "Ace of Spades".
  String toString ()
  {
    return getValueAsString () + " of " + getSuitAsString ();
  }


  //Purpose: Gets the image assigned to the card.
  //Parameters: None.
  //Returns: The image for the card.
  PImage getImage ()
  {
    return this.cardImage; //Gets the image.
  }


  //Purpose: Sets the image to be used for the Card.
  //Parameters: The card image that has already been loaded.
  //Returns: Nothing.
  void setImage (PImage cImage)
  {
    this.cardImage = cImage; //Sets the image.
  }


  //Purpose: Draws the card to the screen at the position any (x,y) position.
  //Parameters: The (x,y) position to draw the image at.
  //Returns: Nothing.
  void drawCard (int xArg, int yArg)
  {
    image (cardImage, xArg, yArg); //Draws the card.
  }
} // end class Card
