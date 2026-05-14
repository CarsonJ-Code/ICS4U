README — Program States and Key Controls

This program uses a finite set of states to switch between different mini-programs or visual modes.
Each state is activated by pressing a specific key on the keyboard. The current state determines which logic runs inside the draw() loop.

DEFAULT STATE

When the program starts, it begins in the BOUNCE state.

KEY CONTROLS AND STATES

b
BOUNCE

The robot moves left and right, bouncing off the edges of the screen.

m
MOUSE

The robot tracks and follows the mouse position.

a
AGE

Runs the age calculator program.

d
BANK

Runs the bank balance calculator program.

o
SLOPE

Runs the slope calculator program.

q
QUADRATIC

Runs the quadratic equation solver.

l
ADD_LOOP

Runs a loop-based adding program.

s
SMILEY

Draws smiley faces on the screen.

5
FIVE

Runs the “five” add-loop program.