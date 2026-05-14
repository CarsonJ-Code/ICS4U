class Ball
{
  // Location
  int x;
  int y;

  int radius; // Size

  // Speed for moving the ball
  int xSpeed;
  int ySpeed;

  // Color
  color colour;

  // Collision count
  int collisions;

  // Dead
  boolean dead;

  Ball(int xArg, int yArg, int radiusArg, color colourArg, int xSpeedArg, int ySpeedArg)
  {
    x = xArg;
    y = yArg;
    radius = radiusArg;
    colour = colourArg;
    xSpeed = xSpeedArg;
    ySpeed = ySpeedArg;
    collisions = 0;
  }

  void draw()
  {
    fill(colour);
    ellipse(x, y, radius*2, radius*2);
  }

  void move()
  {
    // Move the ball
    x=x+xSpeed;
    y=y+ySpeed;

    // Check to see if the ball is hitting an edge.
    // See if the face is at the right side.
    if (x+radius>width)
    {
      // At the right side
      xSpeed = -1*abs(xSpeed);
      handleCollisisionm();
    } else if (x<radius)
    {
      // At the left side
      xSpeed = abs(xSpeed);
      handleCollisisionm();
    }

    // See if the face is at the bottom or top.
    if (y+radius>height)
    {
      // At the bottom side
      ySpeed = -1*abs(ySpeed);
      handleCollisisionm();
    } else if (y<radius)
    {
      // At the top side
      ySpeed = abs(ySpeed);
      handleCollisisionm();
    }
  }
  void handleCollisisionm() {
    changeColourRandom();
    collisions++;
    if (collisions >= 10) {
      deleteBall();
    }
  }

  void changeColourRandom() {
    changeColour(color(int(random(0xff)), int(random(0xff)), int(random(0xff))));
  }

  void changeColour(color newColour) {
    colour = newColour;
  }

  void deleteBall() {
    dead = true;
  }
  void sizeChange(int change) {
    radius += change;
    radius = constrain(radius,1,200);
  }
}
