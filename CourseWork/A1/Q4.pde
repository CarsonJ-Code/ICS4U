// Simulates a simple bank deposit calculation
void bankProgram() {
  float balance = getFloat("What is your current balance?");
  float deposit = getFloat("How much are you depositing?");

  print('\n' + "You're new balance is " + nf(balance+deposit, 0, 2) + '\n');

  // Return to bounce mode after completion
  state = STATES.BOUNCE;
}
