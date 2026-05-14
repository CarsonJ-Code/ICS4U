// Do question 7
void fiveNumbers(){
  int total = 0; // init total
 for(int i = 0; i < 5; i ++){ // loop five times
   total += getInt("What number?"); // add number
 }
 print('\n' + '\n' + total + '\n' + '\n'); // print total
}
