// Carson Jones
// February 10, 2026
// Fills an array with random numbers and counts how many times a user-specified number appears

// Declares an integer array with 1000 elements
int[] list = new int[1000];

void setup() {
  // Fills the array with random integers from 0 to 100
  for (int i = 0; i < list.length; i++) {
    list[i] = (int)random(101);
  }
  
  // Prompts the user for a number to check in the array
  int userInput = getInt("What number to check? ");
  
  // Repeats as long as the user enters a non-negative number
  do {
    // Counts how many times the user input appears in the array
    int instances = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == userInput) instances++;
    }
    
    // Displays the number of instances found
    println("There are " + instances + " instances of " + userInput + " in the array.");
    
    // Prompts the user for another number
    userInput = getInt("What number to check? ");
  } while (userInput >= 0);
}
