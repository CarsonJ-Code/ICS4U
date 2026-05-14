// Carson Jones
// February 10, 2026
// Removes all instances of a user-specified number from a random array

// Declares an integer array with 100 elements
int[] list = new int[100];

void setup() {
  // Fills the array with random integers from 0 to 50
  for (int i = 0; i < list.length; i++) {
    list[i] = (int)random(51);
  }
  
  // Prompts the user for a number to remove from the array
  int numberToRemove = getInt("What number would you like to remove? ");
  
  // Counts how many times the number appears in the array
  int count = 0;
  for(int i = 0; i < list.length; i++) {
    if(list[i] == numberToRemove) count++;
  }
  
  // Creates a new array with a reduced size excluding the removed values
  int[] newList = new int[list.length - count];
  
  // Resets count to use it as an index offset
  count = 0;
  for(int i = 0; i < list.length; i++) {
    // Copies values that are not equal to the removed number
    if(list[i] != numberToRemove) newList[i - count] = list[i];
    // Increments count when a value is skipped
    else count++;
  }
  
  // Prints the new array without the removed number
  println(newList);
}
