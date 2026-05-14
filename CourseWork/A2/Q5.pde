// Runs the factoring program
// Takes input number and returns factors

void factor(int number) {
  ArrayList<Integer> smallPositiveFactors = new ArrayList<Integer>();
  for (int i = 1; i <= sqrt(abs(number)); i++) {
    if (number % i == 0) smallPositiveFactors.add(i);
  }
  println("The factors of " + number + " are:");
  for (int i = 0; i <= smallPositiveFactors.size() - 1; i++) {
    int factor1 = smallPositiveFactors.get(i);
    println(factor1 + " , " + number/factor1 + '\n' + -factor1 + " , " + number/-factor1);
  }
}
