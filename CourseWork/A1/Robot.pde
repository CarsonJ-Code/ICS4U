// Carson
// 2/3/26
// Does all parts of a1

// Robot position (top-left corner)
int robotX = 50;
int robotY = 50;

// Draws a robot using two squares at a given position
void robot(int x, int y) {
  square(x+ROBOT_WIDTH/4, y-ROBOT_WIDTH/2, ROBOT_WIDTH/2); // head
  square(x, y, ROBOT_WIDTH);                              // body
}
