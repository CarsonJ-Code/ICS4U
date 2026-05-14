// Carson Jones
// February 10, 2026
// Splits a time string into hours, minutes, and seconds and displays them

void setup(){
  // Prompts the user to enter a time in the format HH:MM:SS
  String time = getString("What time? ");
  
  // Splits the input string at each colon into an array
  String[] splitTime = time.split(":");
  
  // Prints the hours, minutes, and seconds in a readable format
  println(splitTime[0] + " hours, " + splitTime[1] + " minutes, and " + splitTime[2] + " seconds.");
}
