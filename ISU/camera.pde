float[] mousePan = {0, 0};
float[] mouseLast = {0, 0};
float zoom = 1;
float[] centre = {0, 0};
boolean holdingPan = false;

static float MIN_ZOOM = 0.01;
static float ZOOM_AMOUNT = 20;

void mousePressed() {
    if (mouseButton == CENTER) {
        holdingPan = true;
        mouseLast = new float[]{mouseX, mouseY}; // ← also fixes the ghost-jump bug (see below)
    }
}

void mouseReleased() {
    if (mouseButton == CENTER) {
        holdingPan = false;
    }
}

void handleCamera() {
    if (holdingPan) {
        handleMousePan();
        centre[0] += mousePan[0];
        centre[1] += mousePan[1];
    }
}

// set the amount to move the camera by how much the mouse has moved
void handleMousePan() {
  float x_diff = mouseLast[0] - mouseX;
  float y_diff = mouseLast[1] - mouseY;

  mousePan[0] = x_diff * zoom / 2;
  mousePan[1] = y_diff * zoom / 2;
  mouseLast = new float[]{mouseX, mouseY};
}


// takes a position on the screen, and converts it to world co-ordinates
float[] screenSpaceToPos(float[] pos) {
  float newx = centre[0] + (pos[0] - width/2) * zoom;
  float newy = centre[1] + (pos[1] - height/2) * zoom;
  return new float[]{newx, newy};
}

// takes a position on the screen, and converts it to world co-ordinates
float xScreenToPos(float pos) {
  return centre[0] + (pos - height/2) * zoom;
}

// takes a position on the screen, and converts it to world co-ordinates
float yScreenToPos(float pos) {
  return centre[1] + (pos - height/2) * zoom;
}


// takes a world position and converts it to screen co-ordinates
float[] posToScreenSpace(float[] pos) {
  float newx = width/2 + (pos[0] - centre[0]) / zoom;
  float newy = height/2 + (pos[1] - centre[1]) / zoom;
  return new float[]{newx, newy};
}

float xPosToScreenSpace(float xPos){
  return (width/2 + (xPos - centre[0]) / zoom);
}

float yPosToScreenSpace(float yPos){
  return (height/2 + (yPos - centre[1]) / zoom);
}

void mouseWheel(MouseEvent event) {
  float amount = event.getCount() ;

  zoom += ZOOM_AMOUNT * amount;
  if (zoom < MIN_ZOOM) zoom = MIN_ZOOM;
}


void drawToScreen(PImage img, float xCoord, float yCoord, float xSize, float ySize){
  image(img, xPosToScreenSpace(xCoord), yPosToScreenSpace(yCoord), xSize/zoom, ySize/zoom); 
}

//void drawToScreen
