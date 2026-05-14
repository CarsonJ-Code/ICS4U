// Repeatedly adds numbers until the total exceeds 500
void addLoop() {
  int total = 0;
  int counter = 0;

  do {
    total += getInt('\n' + "Total = " + total + " Next number: ");
    counter ++;
  } while (total <= 500);

  print ("There were " + counter + " numbers.");

  // Return to bounce mode after completion
  state = STATES.BOUNCE;
}
