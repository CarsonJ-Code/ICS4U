// All possible program states
enum STATES {
  BOUNCE, // Robot bounces left and right
    MOUSE, // Robot follows the mouse
    AGE, // Age calculator
    BANK, // Bank balance calculator
    SLOPE, // Slope calculator
    QUADRATIC, // Quadratic solver
    ADD_LOOP, // Loop-based adding program
    SMILEY,      // Draws smiley faces
    FIVE // Does the five add loop
}
STATES state = STATES.BOUNCE;


// Runs once at program start
void setup() {
  strokeWeight(0);
  background(255);
  size(800, 800);
  fill(#777777);
  // Current state of the program
}



// Runs every frame and executes logic based on current state
void draw() {
  background(255);

  switch (state) {
  case BOUNCE:
    robotBounce();
    break;
  case MOUSE:
    robotTrack();
    break;
  case AGE:
    ageProgram();
    break;
  case BANK:
    bankProgram();
    break;
  case SLOPE:
    slopeProgram();
    break;
  case QUADRATIC:
    quadratics();
    break;
  case ADD_LOOP:
    addLoop();
    break;
  case SMILEY:
    smiley();
    break;
  case FIVE:
    fiveNumbers();
    break;
  }
}

// Changes program state based on key presses
void keyPressed() {
  if (key == 'b') {
    state = STATES.BOUNCE;
  }
  if (key == 'm') {
    state = STATES.MOUSE;
  }
  if (key == 'a')
  {
    state = STATES.AGE;
  }
  if (key == 'd') {
    state = STATES.BANK;
  }
  if (key == 'o') {
    state = STATES.SLOPE;
  }
  if (key == 'q') {
    state = STATES.QUADRATIC;
  }
  if (key == 'l') {
    state = STATES.ADD_LOOP;
  }
  if (key == 's') {
    state = STATES.SMILEY;
  }
  if (key == '5') {
   state = STATES.FIVE; 
  }
}
