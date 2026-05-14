// Solves a quadratic equation using the quadratic formula
void quadratics() {
  float[] coefficients = float(getString("Input coefficients in the form \"a,b,c\"").split(","));
  String[] roots = {"0", "0"};

  // Calculate discriminant
  float discriminant = pow(coefficients[1], 2) - 4 * coefficients[0] * coefficients[2];

  // Two real roots
  if (discriminant > 0) {
    roots[0] = nf((-coefficients[1] - sqrt(discriminant))/(2 * coefficients[0]));
    roots[1] = nf((-coefficients[1] + sqrt(discriminant))/(2 * coefficients[0]));
    print("The roots are " + roots[0] + ", " + roots[1]);

  // One real root
  } else if (discriminant == 0) {
    roots[0] = nf((-coefficients[1])/(2 * coefficients[0]));
    print("The root is" + roots[0]);

  // Complex roots
  } else if (discriminant < 0) { // I'm pretty sure this is worth bonus marks
    float oppDiscriminant = -discriminant;
    float rootOppDisc = sqrt(oppDiscriminant);

    roots[0] = nf(-coefficients[1]/(2*coefficients[0])) + " + " + nf(rootOppDisc/(2*coefficients[0])) + 'i';
    roots[1] = nf(-coefficients[1]/(2*coefficients[0])) + " + " + nf(-rootOppDisc/(2*coefficients[0])) + 'i';

    print("The roots are " + roots[0] + ", " + roots[1]);
  }

  // Return to bounce mode after completion
  state = STATES.BOUNCE;
}
