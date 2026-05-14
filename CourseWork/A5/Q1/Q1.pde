// Carson Jones
// February 13, 2026
// Changes the colour of a circle based on button clicks

// Button objects for each colour option
Button blueButton;
Button yellowButton;
Button redButton;
Button greenButton;

// Current colour of the circle
color circleColor = color(100, 50, 200);

// Width and height of each button
int RECT_WIDTH = 100;

void setup()
{
  // Sets up the window size and initial background
  size(800, 600);
  background(0, 100, 100);
  
  // Creates buttons positioned in each quadrant with different colours
  redButton = new Button(width/4-RECT_WIDTH/2, height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FF0000, "");
  greenButton = new Button(3*width/4-RECT_WIDTH/2, height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #00FF00, "");
  yellowButton = new Button(width/4-RECT_WIDTH/2, 3*height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #FFFF00, "");
  blueButton = new Button(3*width/4-RECT_WIDTH/2, 3*height/4-RECT_WIDTH/2, RECT_WIDTH, RECT_WIDTH, #0000FF, "");
}

void draw()
{
  // Clears and redraws the background
  background(#161803);
  
  // Draws all colour selection buttons
  redButton.draw();
  greenButton.draw();
  yellowButton.draw();
  blueButton.draw();

  // Draws the circle in the currently selected colour
  fill(circleColor);
  circle(width/2, height/2, 100);
}

void mouseReleased()
{
  // Updates the circle colour based on which button is clicked
  if (redButton.isClicked(mouseX, mouseY))
  {
    circleColor = redButton.getColour();
  }

  if (greenButton.isClicked(mouseX, mouseY))
  {
    circleColor = greenButton.getColour();
  }

  if (yellowButton.isClicked(mouseX, mouseY))
  {
    circleColor = yellowButton.getColour();
  }

  if (blueButton.isClicked(mouseX, mouseY))
  {
    circleColor = blueButton.getColour();
  }
}
