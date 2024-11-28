import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // Importar para formato matemático
import 'dart:math';

import '../utils/math.dart';
import '../widgets/result_card.dart';

class PoissonCalculatorScreen extends StatefulWidget {
  @override
  _PoissonCalculatorScreenState createState() =>
      _PoissonCalculatorScreenState();
}

class _PoissonCalculatorScreenState extends State<PoissonCalculatorScreen> {
  final TextEditingController _lambdaController = TextEditingController();
  final TextEditingController _xController = TextEditingController();

  String? _formulaProbabilidad;
  String? _resultadoProbabilidad;
  String? _formulaVarianza;
  String? _formulaDesviacion;

  void _calcular() {
    final lambda = double.tryParse(_lambdaController.text);
    final x = int.tryParse(_xController.text);

    if (lambda != null && lambda > 0 && x != null && x >= 0) {
      final probabilidad = (pow(lambda, x) * exp(-lambda)) / _factorial(x);

      final varianza = lambda;
      final desviacionEstandar = sqrt(varianza);

      setState(() {
        _formulaProbabilidad =
            r"P(X = x) = \frac{\lambda^x e^{-\lambda}}{x!} = \frac{" +
                lambda.toString() +
                r"^" +
                x.toString() +
                r" \cdot e^{-" +
                lambda.toString() +
                r"}}{" +
                x.toString() +
                r"!}=";

        _resultadoProbabilidad = formatNumber(probabilidad) +
            r"\approx " +
            formatNumber(probabilidad * 100) +
            r"\%";

        _formulaVarianza = r"\sigma^2 = \lambda = " + formatNumber(varianza);

        _formulaDesviacion = r"\sigma = \sqrt{\lambda} = \sqrt{" +
            formatNumber(varianza) +
            r"} = " +
            formatNumber(desviacionEstandar);
      });
    } else {
      setState(() {
        _formulaProbabilidad = null;
        _resultadoProbabilidad = null;
        _formulaVarianza = null;
        _formulaDesviacion = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa valores válidos.')),
      );
    }
  }

  int _factorial(int num) {
    if (num <= 1) return 1;
    return num * _factorial(num - 1);
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
                  'Distribución de Poisson',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'La distribución de Poisson describe el número de eventos que ocurren en un intervalo '
                  'fijo de tiempo o espacio, siempre que estos eventos ocurran con una tasa promedio conocida '
                  'y de forma independiente unos de otros.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fórmula:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Math.tex(
                  r"P(X = x) = \frac{\lambda^x e^{-\lambda}}{x!}",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Donde:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '- P(X = x): Probabilidad de observar exactamente x eventos.\n'
                  '- λ (lambda): Tasa promedio de eventos por intervalo.\n'
                  '- x: Número de eventos observados.\n'
                  '- e: Constante matemática (~2.718).',
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
      appBar: AppBar(title: const Text('Distribución Poisson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _lambdaController,
                decoration:
                    const InputDecoration(labelText: 'Tasa promedio (λ)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _xController,
                decoration:
                    const InputDecoration(labelText: 'Número de eventos (x)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular')
              ),
              const SizedBox(height: 20),
              if (_formulaProbabilidad != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResultCard(
                      title: 'Probabilidad:',
                      formula: _formulaProbabilidad!,
                      result: _resultadoProbabilidad!,
                    ),
                    ResultCard(
                      title: 'Varianza:',
                      formula: _formulaVarianza!,
                      result: "",
                    ),
                    ResultCard(
                      title: 'Desviación Estándar:',
                      formula: _formulaDesviacion!,
                      result: "",
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                  onPressed: _showHelpModal,
                  icon: const Icon(Icons.help_outline),
                  label: const Text("Ayuda")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
