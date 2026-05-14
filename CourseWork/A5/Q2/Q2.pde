// Carson Jones
// February 13, 2026
// Interactive ball simulation with colour changes, resizing, and removal

// A list to store all of the Ball objects
ArrayList<Ball> balls;

// Button used to change the colour of all balls
Button colourChange;

// Changes all balls to the colour selected by the button
void changeColours() {
  color newColour = colourChange.getColour();
  for (Ball currentBall : balls) currentBall.changeColour(newColour);
}

void setup()
{
  // Sets up the window size and background colour
  size(800, 600);
  background(0, 100, 100);

  // Initializes the ArrayList of balls
  balls = new ArrayList<Ball>();

  // Adds several initial balls with different properties
  balls.add(new Ball(200, 400, 50, #00FF00, 3, 3));
  balls.add(new Ball(400, 200, 150, #FF0000, 6, 6));
  balls.add(new Ball(100, 500, 25, #0000FF, -2, 4));
  
  // Prints the initial number of balls
  println("The size of balls is: " + balls.size());
  
  // Creates the colour-change button
  colourChange = new Button(0, height-100, 100, 100, #FFFFFF, "CHANGE \nCOLOUR");
}

void draw()
{
  // Clears and redraws the background each frame
  background(0, 100, 100);

  // Loops through the balls list backwards to safely remove dead balls
  for (int i = balls.size() - 1; i >= 0; i--) {
    Ball b = balls.get(i);

    // Updates position and draws the ball
    b.move();
    b.draw();
    
    // Draws the colour-change button
    colourChange.draw();
    
    // Removes the ball if it is marked as dead
    if (b.dead) {
      balls.remove(i);
    }
  }
}

// Handles mouse click events
void mouseReleased() {
  // Changes all ball colours if the button is clicked
  if (colourChange.isClicked(mouseX, mouseY)) {
    changeColours();
  } 
  // Otherwise, adds a new ball at the mouse position with random properties
  else balls.add(new Ball(
    mouseX, 
    mouseY, 
    int(random(25, 100)), 
    color(int(random(0xff)), int(random(0xff)), int(random(0xff))), 
    int(random(-5, 6)), 
    int(random(-5, 6))
  ));
}

// Handles key press events
void keyPressed() {
  switch(key) {
  // Increases the size of all balls
  case '=':
    for (Ball currentBall : balls) currentBall.sizeChange(1);
    break;
  // Decreases the size of all balls
  case '-':
    for (Ball currentBall : balls) currentBall.sizeChange(-1);
    break;
  }
}
