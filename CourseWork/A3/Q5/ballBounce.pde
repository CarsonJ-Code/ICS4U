// Carson Jones
// Febuary 10th, 2026
// Animates a ball spinning


int x = 0; // Initial x position of the ball
int xSpeed = 7; // Initial speed of the ball in the x direction
int y = 0; // Initial y position of the ball
int ySpeed = 4; // Initial speed of the ball in the y direction
int imageNum = 0;
String imageName = "ball0.png";

PImage ball; // Variable to hold the image of the ball

void setup() {
  size(800, 600); // Set the size of the window
  background(0); // Set the background color to black
  fill(255, 0, 0); // Set the fill color to red (not used in this code)
  ball = loadImage(imageName); // Load the image of the ball
}

void draw() {
  background(0); // Clear the screen each frame with black color

  // Check if the ball hits the right edge of the window
  if (x > width - 40) {
    xSpeed = -1 * xSpeed; // Reverse the x direction
  } else if (x < 0) { // Check if the ball hits the left edge of the window
    xSpeed = int(random(3, 15)); // Set a random speed in the x direction
  }

  // Check if the ball hits the bottom edge of the window
  if (y > height - 40) {
    ySpeed = -1 * ySpeed; // Reverse the y direction
  } else if (y < 0) { // Check if the ball hits the top edge of the window
    ySpeed = int(random(3, 12)); // Set a random speed in the y direction
  }

  x = x + xSpeed; // Update the x position of the ball
  y = y + ySpeed; // Update the y position of the ball

  image(ball, x, y); // Draw the ball at the new position
  
  
  imageName = "ball" + imageNum + ".png"; //Changes the name of image to load
  imageNum++;
  imageNum %= 10;
  
  ball = loadImage(imageName); // Load the image of the ball
}
