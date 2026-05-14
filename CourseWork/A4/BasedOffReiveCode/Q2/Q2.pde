// A List to store all of the balls.
ArrayList<Ball> balls;

void setup()
{
  size(800, 600);
  background(0, 100, 100);

  balls = new ArrayList<Ball>();

  balls.add(new Ball(200, 400, 50, #114411, 3, 3));
  balls.add(new Ball(400, 200, 150, #FF0000, 6, 6));
  balls.add(new Ball(100, 500, 25, #0000FF, -2, 4));
  println("The size of balls is: " + balls.size());
}


void draw()
{
  background(0, 100, 100);

  for ( Ball currentBall : balls)
  {
    currentBall.move();
    currentBall.draw();
  }
}

void mouseReleased() {
  balls.add(new Ball(mouseX, mouseY, int(random(25,100)), (color)(random(#FFFFFF)),int(random(-5,6)), int(random(-5,6))));
}

// Goes in the Ball tab
