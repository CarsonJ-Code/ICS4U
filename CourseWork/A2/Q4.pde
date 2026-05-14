// Runs factorial program
// Takes input and returns its factorial

int factorial(int number) {
  if (number == 0) return 1;
  int result = 1;
  while (number > 1) {
      result *= number;
      number--;
  }
  return result;
}
