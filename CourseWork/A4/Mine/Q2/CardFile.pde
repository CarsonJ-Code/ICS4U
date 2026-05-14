// Carson Jones
// February 10, 2026
// Defines a Card class representing a playing card with suit, value, and images

class Card
{
  // Images for the front and back of the card
  PImage cardImage;
  PImage cardBackImage;

  // Arrays storing suit and value names
  String[] suits = {"Spades", "Hearts", "Diamonds", "Clubs", "JOKER"};
  String[] values = {"Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "JOKER"};

  // Index values for suit and value
  int suitIndex;
  int valueIndex;

  int[] currentPos = new int[2];

  // Constructor that initializes the card based on value and suit indices
  Card (int valueArg, int suitArg) {
    // Validates the provided indices
    if ((valueArg >= 0 && valueArg <= 13) && (suitArg >= 0 && suitArg <= 4)) {
      valueIndex = valueArg;
      suitIndex = suitArg;

      // Loads the correct image for the card
      if (valueArg == 13 && suitArg == 4) {
        cardImage = loadImage("images\\black-joker.jpg");
      } else {
        cardImage = loadImage("images\\" + suitIndex + '-' + (valueIndex + 1) + ".jpg");
      }

      // Loads the card back image
      cardBackImage = loadImage("images\\card-back.jpg");
    } else {
      // Throws an error if invalid indices are provided
      throw new IllegalArgumentException ("Invalid suit or value");
    }
  }

  // sets suit of card
  void setSuit(int suit) {
    suitIndex = suit;
    cardImage = loadImage("images\\" + suitIndex + '-' + (valueIndex + 1) + ".jpg");
  }
  // sets value of card
  void setValue(int val) {
    valueIndex = val;
    cardImage = loadImage("images\\" + suitIndex + '-' + (valueIndex + 1) + ".jpg");
  }

  // Returns the suit index
  int getSuit() {
    return suitIndex;
  }

  // Returns the value index
  int getValue() {
    return valueIndex;
  }

  // Returns the suit as a string
  String getStringSuit() {
    return suits[suitIndex];
  }

  // Returns the value as a string
  String getStringValue() {
    return values[valueIndex];
  }

  // Returns a human-readable description of the card
  String getCard() {
    return "it is the " +  getStringValue() + " of " + getStringSuit();
  }

  // Draws either the front or back of the card
  void drawCard(int x, int y, boolean front) {
    currentPos[0] = x;
    currentPos[1] = y;

    if (front) drawFront(x, y);
    else drawBack(x, y);
  }

  // Draws the front image of the card
  void drawFront(int x, int y) {
    image(cardImage, x, y);
  }

  // Draws the back image of the card
  void drawBack(int x, int y) {
    image(cardBackImage, x, y);
  }

  // returns whether or not the card is clicked based on where it was drawn
  boolean isClicked(int x, int y) {
    return(x > currentPos[0] && x < currentPos[0] + 75) && (y > currentPos[1] && y < currentPos[1] + 108);
  }
}
