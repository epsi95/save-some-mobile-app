import 'dart:math';
import 'package:linalg/linalg.dart';

List calculatePolynomialRegression(List input, List predictionFor) {
  // calculate polynomial regression of degree 2
  if (input.length < 3) {
    return [];
  } else {
    int sizeOfInput = input.length;

    // construction regression variables
    double n = sizeOfInput * 1.0;
    double sum_xi = 0.0;
    double sum_xi_2 = 0.0;
    double sum_xi_3 = 0.0;
    double sum_xi_4 = 0.0;
    double sum_yi = 0.0;
    double sum_xi_yi = 0.0;
    double sum_xi_2_yi = 0.0;

    input.asMap().forEach((i, e) {
      double index = i + 1.0;
      sum_xi += index;
      sum_xi_2 += pow(index, 2);
      sum_xi_3 += pow(index, 3);
      sum_xi_4 += pow(index, 4);
      sum_yi += e;
      sum_xi_yi += (index * e);
      sum_xi_2_yi += (pow(index, 2)) * e;
    });
    // C = A-1 * B;
    final Matrix a = Matrix([
      [n, sum_xi, sum_xi_2],
      [sum_xi, sum_xi_2, sum_xi_3],
      [sum_xi_2, sum_xi_3, sum_xi_4]
    ]);
    final Vector b = Vector.column([sum_yi, sum_xi_yi, sum_xi_2_yi]);
    Vector result = ((a.inverse()) * b).toVector();
    List<double> predictions = [];
    predictionFor.forEach((element) {
      predictions.add(prediction(result, element.toDouble()));
    });
    return predictions;
  }
}

double prediction(Vector v, double x) {
  double r = (v.transpose() * Vector.column([1, x, x * x]))[0][0];
  r = (r * 10).roundToDouble() / 10;
  return r;
}

void main() {
  print(calculatePolynomialRegression([20, 0, 5], [4, 5, 6, 7]));
}
