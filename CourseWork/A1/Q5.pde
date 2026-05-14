// Calculates the slope between two points
void slopeProgram() {
  float[] point1 = float(getString("Point 1 (\"x,y\"):").split(","));
  float[] point2 = float(getString("Point 2 (\"x,y\"):").split(","));

  // Check for vertical line
  if (point1[0] == point2[0]) print("The slope is infinite");
  else {
    print("The slope is " + (point1[1]-point2[1])/(point1[0]-point2[0]) + '\n');
    state = STATES.BOUNCE;
  }}
