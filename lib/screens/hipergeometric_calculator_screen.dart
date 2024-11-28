import 'package:calculadoraestadistica/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../utils/math.dart';

class HypergeometricCalculatorScreen extends StatefulWidget {
  @override
  _HypergeometricCalculatorScreenState createState() =>
      _HypergeometricCalculatorScreenState();
}

class _HypergeometricCalculatorScreenState
    extends State<HypergeometricCalculatorScreen> {
  final TextEditingController _nController = TextEditingController(); // Tamaño de la población
  final TextEditingController _kController = TextEditingController(); // Éxitos en la población
  final TextEditingController _sampleSizeController = TextEditingController(); // Tamaño de la muestra
  final TextEditingController _xController = TextEditingController(); // Éxitos en la muestra

  String? _formulaProbabilidad;
  String? _resultadoProbabilidad;

  // Función para calcular el factorial
  int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);

  // Función para calcular combinaciones (binomio)
  int combinacion(int n, int r) =>
      factorial(n) ~/ (factorial(r) * factorial(n - r));

  void _calcular() {
    final N = int.tryParse(_nController.text);
    final K = int.tryParse(_kController.text);
    final n = int.tryParse(_sampleSizeController.text);
    final x = int.tryParse(_xController.text);

    if (N != null && K != null && n != null && x != null &&
        x <= n && x <= K && n <= N) {
      // Fórmula de probabilidad
      final probabilidad = combinacion(K, x) *
          combinacion(N - K, n - x) /
          combinacion(N, n);

      setState(() {
        _formulaProbabilidad = r"P(X = x) = \frac{\binom{" +
            K.toString() +
            r"}{" +
            x.toString() +
            r"} \cdot \binom{" +
            (N - K).toString() +
            r"}{" +
            (n - x).toString() +
            r"}}{\binom{" +
            N.toString() +
            r"}{" +
            n.toString() +
            r"}}";

        _resultadoProbabilidad = formatNumber(probabilidad);
      });
    } else {
      setState(() {
        _formulaProbabilidad = null;
        _resultadoProbabilidad = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa valores válidos.')),
      );
    }
  }

  void _showHelpModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribución Hipergeométrica',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'La distribución hipergeométrica modela la probabilidad de obtener un número determinado de éxitos en una muestra tomada sin reemplazo de una población finita.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fórmula:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Math.tex(
                  r"P(X = x) = \frac{\binom{K}{x} \cdot \binom{N-K}{n-x}}{\binom{N}{n}}",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Donde:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '- \(N\): Tamaño de la población.\n'
                      '- \(K\): Número de éxitos en la población.\n'
                      '- \(n\): Tamaño de la muestra.\n'
                      '- \(x\): Número de éxitos en la muestra.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Distribución Hipergeométrica')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nController,
                decoration: const InputDecoration(labelText: 'Tamaño de la población (N)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _kController,
                decoration: const InputDecoration(labelText: 'Éxitos en la población (K)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sampleSizeController,
                decoration: const InputDecoration(labelText: 'Tamaño de la muestra (n)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _xController,
                decoration: const InputDecoration(labelText: 'Éxitos en la muestra (x)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular')),
              const SizedBox(height: 20),
              if (_formulaProbabilidad != null)
                ResultCard(
                  title: 'Probabilidad:',
                  formula: _formulaProbabilidad!,
                  result: _resultadoProbabilidad!,
                ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                  onPressed: _showHelpModal,
                  icon: const Icon(Icons.help_outline),
                  label: const Text("Ayuda")),
            ],
          ),
        ),
      ),
    );
  }
}
