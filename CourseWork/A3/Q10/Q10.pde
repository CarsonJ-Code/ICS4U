// Carson Jones
// February 10, 2026
// Checks whether a password appears in a list of common passwords and reports its strength and ranking

// Array to store up to 1,000,000 common passwords
String[] passwords = new String[1000000];
String[] sortedPasswords = new String[passwords.length];

// Checks whether the given password does NOT appear in the password list
// Returns true if the password is strong (not found), false if weak (found)
boolean testQuality(String testPass) {
  int bottom = 0; // lower bound index of subarray
  int top = sortedPasswords.length; // upper bound index of subarray
  int middle; // middle index of subarray
  //boolean found = false; // to stop if item found
  //int location = -1; // index of item in array, returns -1 if not found
  while (bottom < top)
  {
    middle = (bottom + top) / 2;
    if (sortedPasswords[middle].equals(testPass)) // success
    {
      return false;
      //location = middle;
    }
    if (sortedPasswords[middle].compareTo(testPass) < 0) // not in bottom half
    {
      bottom = middle + 1;
    } else // item cannot be in top half
    {
      top = middle - 1;
    }
    println(1);
  }
  return true;
  //for(int i = 0; i < passwords.length; i++){
  //  // Compares the test password to each stored password
  //  if((testPass).equals(passwords[i])) return false;
  //}
  //return true;
}

// Finds the ranking (index) of the password in the password list
// Returns the index if found, or -1 if not found
int ranking(String userPass) {
  for (int i = 0; i < passwords.length; i++) {
    // Checks for a match in the password list
    if ((userPass).equals(passwords[i])) return i;
  }
  return -1;
}

void setup() {
  // Loads the list of common passwords from a text file
  passwords = loadStrings("super-clean-passwords-1000000.txt");
  sortedPasswords = sort(passwords);

  // Prompts the user to enter a password
  String userPass = getString("What is the password? ");

  // Tests the password and prints whether it is strong or weak
  if (testQuality(userPass)) println("The inputted password is strong");
  else println("The inputted password is weak. It is ranked number " + (ranking(userPass)+1) + " as far as bad passwords go.");
}
