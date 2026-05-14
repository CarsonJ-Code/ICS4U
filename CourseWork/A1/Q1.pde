// Direction of robot movement (false = left, true = right)
boolean robotDir = false;

// Robot dimensions and movement speed
int ROBOT_WIDTH = 100;
int ROBOT_HEIGHT = ROBOT_WIDTH * 3 / 2;
int ROBOT_SPEED = 1;


// Moves the robot left and right, bouncing off screen edges
void robotBounce() {

  // Reverse direction when hitting left or right edge
  if (robotX == 0|| robotX == width-ROBOT_WIDTH) robotDir = !robotDir;

  // Move robot based on direction
  if (robotDir) robotX += ROBOT_SPEED;
  else robotX -= ROBOT_SPEED;

  // Draw robot at updated position
  robot(robotX, robotY);
}
