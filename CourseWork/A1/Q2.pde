// Makes the robot follow the mouse while staying on screen
void robotTrack() {
  robot(
    constrain(mouseX-ROBOT_WIDTH/2, 0, width-ROBOT_WIDTH),
    constrain(mouseY-ROBOT_HEIGHT/4, ROBOT_HEIGHT/3, height-ROBOT_HEIGHT)
  );
}
