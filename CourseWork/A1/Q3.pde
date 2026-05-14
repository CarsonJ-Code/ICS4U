// Asks for name and birth year, then prints the user's age
void ageProgram() {
  String fName = getString("What is your first name?");
  String lName = getString("What is your last name?");
  int birthYear = getInt("What is your birth year");

  print(
    '\n' +
    "Hello " + fName + ' ' + lName + '.' + '\n' +
    "You're age is " + (2026-birthYear) +
    '\n' + '\n'
  );

  // Return to bounce mode after completion
  state = STATES.BOUNCE;
}
