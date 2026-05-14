// Carson Jones
// Febuary 10th, 2026
// Generates a random array, outputs the highest 2 unique values


// Create an integer array with space for 100 elements
int[] list = new int[100];

void setup() {

  // Populate the array with random integers from 0 to 500 inclusive
  for (int i = 0; i < list.length; i++) {
    list[i] = (int)random(501);
  }

  // Variable to store the largest value found in the array
  int largest = -1;

  // Variable to store the second largest value found in the array
  int second = -1;

  // Loop through the array to determine the largest and second largest values
  for (int i = 0; i < list.length; i++) {

    // If the current value is greater than or equal to the largest,
    // update largest to this value
    if (list[i] >= largest) {
      largest = list[i];
    }
    // Otherwise, if the current value is greater than the second largest,
    // update second to this value
    else if (list[i] > second) {
      second = list[i];
    }
  }

  // Print the largest and second largest values
  println("The largest number is: " + largest + " and the second largest is: " + second);

  // Print the entire array
  println(list);
}
