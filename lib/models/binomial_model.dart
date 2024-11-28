import 'dart:math';

class BinomialModel {
  final int n; // Número de ensayos
  final double p; // Probabilidad de éxito
  final int x; // Número de éxitos

  BinomialModel({required this.n, required this.p, required this.x});

  // Calcula el factorial
  int _factorial(int num) {
    if (num <= 1) return 1;
    return num * _factorial(num - 1);
  }

  // Calcula la probabilidad binomial
  double calcularProbabilidad() {
    final combinatoria = _factorial(n) / (_factorial(x) * _factorial(n - x));
    return combinatoria * pow(p, x) * pow(1 - p, n - x);
  }

  // Calcula la varianza
  double calcularVarianza() {
    return n * p * (1 - p);
  }

  // Calcula la desviación estándar
  double calcularDesviacionEstandar() {
    return sqrt(calcularVarianza());
  }

  // Devuelve una descripción del modelo actual
  String descripcion() {
    return 'Modelo Binomial: n = $n, p = $p, x = $x';
  }
}
