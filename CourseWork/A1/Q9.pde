// Draws a grid of smiley faces across the screen
void smiley() {
  int smileWidth = 50;

  for (int i = smileWidth/2; i < (width); i += smileWidth) {
    for (int j = smileWidth/2; j < (height); j += smileWidth) {

      // Face
      circle(i,j,smileWidth);
      fill(#FFFF00);

      // Eyes
      circle(i-5, j-5, 5);
      circle(i+5, j-5, 5);

      // Mouth
      strokeWeight(3);
      stroke(#FF0000);
      line(i-5, j+10, i+5, j+10);

      // Reset drawing settings
      fill(#777777);
      strokeWeight(0);
    }
  }
}
