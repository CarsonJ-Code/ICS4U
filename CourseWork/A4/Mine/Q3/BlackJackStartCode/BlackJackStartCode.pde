///////////////////////////////
// ADD COMMENTS TO THIS CODE
// Has a Hit button added to this code.
///////////////////////////////

final int HITTING = 0;
final int BUST= 1;
final int WIN= 2;
final int LOSE= 3;
int state = HITTING;

Deck deck;
Hand playerHand;
Hand dealerHand;

Button hitButton;

void setup()
{
  size(800, 600);
  background(255, 255, 255);

  deck = new Deck ();
  playerHand = new Hand();
  dealerHand = new Hand();

  // Make a new button - x, y, width, height, color, text
  hitButton = new Button(100, 100, 50, 30, color(255, 0, 0), "Hit");


  // Start by dealing 2 cards to each hand.
}

void draw()
{
  background(255, 255, 255);

  if (state == HITTING)
  {
    deck.getCardBack().drawCard(100, 200);

    hitButton.draw();

    // showing the hit and stand buttons
    // covering the second dealer card
  } else if (state == BUST)
  {
    // Tell them they lost and show them restart button
  } else if (state == WIN)
  {
    // Tell them they win and show them restart button
  } else if (state == LOSE)
  {
    // Tell them they lost and show them restart button
  }
}

void keyPressed() // Click of the mouse
{
  // You can use key events if you want, for example:
  if (key == 'q')
  {
    println("Quit the game");
  }
}

void mouseClicked()
{
  if (hitButton.isClicked(mouseX, mouseY))
  {
    println("The hit button was clicked");
  }
}
