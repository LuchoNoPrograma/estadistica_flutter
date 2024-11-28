import 'package:calculadoraestadistica/utils/math.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // Importar para formato matemático
import 'dart:math';

import '../widgets/result_card.dart';

class BinomialCalculatorScreen extends StatefulWidget {
  @override
  _BinomialCalculatorScreenState createState() =>
      _BinomialCalculatorScreenState();
}

class _BinomialCalculatorScreenState extends State<BinomialCalculatorScreen> {
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _xController = TextEditingController();

  String? _formulaProbabilidad;
  String? _resultadoProbabilidad;
  String? _formulaVarianza;
  String? _formulaDesviacion;

  void _calcular() {
    final n = int.tryParse(_nController.text);
    final p = double.tryParse(_pController.text);
    final x = int.tryParse(_xController.text);

    if (n != null && p != null && p >= 0 && p <= 1 && x != null && x <= n) {
      final combinatoria = _factorial(n) / (_factorial(x) * _factorial(n - x));
      final probabilidad = combinatoria * pow(p, x) * pow(1 - p, n - x);

      final varianza = n * p * (1 - p);
      final desviacionEstandar = sqrt(varianza);

      setState(() {
        _formulaProbabilidad = r"P(X = x) = \binom{" +
            n.toString() +
            "}{" +
            x.toString() +
            r"}"
                r"(" +
            p.toString() +
            r")^{" +
            x.toString() +
            r"}(1-" +
            formatNumber(p) +
            r")^{" +
            (n - x).toString() +
            "}=";

        _resultadoProbabilidad = formatNumber(probabilidad) +
            r"\approx " +
            formatNumber(probabilidad * 100) +
            r"\%";

        _formulaVarianza = r"\sigma^2 = n \cdot p \cdot (1-p) = " +
            n.toString() +
            r" \cdot " +
            p.toString() +
            r" \cdot " +
            formatNumber(1 - p) +
            r" = " +
            formatNumber(varianza);

        _formulaDesviacion = r"\sigma = \sqrt{\sigma^2} = \sqrt{" +
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
                  'Distribución Binomial',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'La distribución binomial describe el número de éxitos en '
                  'un número fijo de ensayos independientes con una probabilidad constante de éxito.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fórmula:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Math.tex(
                  r"P(X = x) = \binom{n}{x} p^x (1-p)^{n-x}",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Donde:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '- P(X = x): Probabilidad de obtener exactamente x éxitos.\n'
                  '- n: Número total de ensayos.\n'
                  '- x: Número de éxitos deseados.\n'
                  '- p: Probabilidad de éxito en un ensayo.\n'
                  '- (1 - p): Probabilidad de fracaso en un ensayo.',
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
      appBar: AppBar(title: const Text('Distribución Binomial')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nController,
                decoration:
                    const InputDecoration(labelText: 'Número de ensayos (n)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _pController,
                decoration: const InputDecoration(
                    labelText: 'Probabilidad de éxito (p)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _xController,
                decoration:
                    const InputDecoration(labelText: 'Número de éxitos (x)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular')),
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
                  label: const Text("Ayuda")),
            ],
          ),
        ),
      ),
    );
  }
}
