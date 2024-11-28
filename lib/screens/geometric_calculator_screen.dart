import 'package:calculadoraestadistica/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart'; // Para fórmulas matemáticas
import 'dart:math';

import '../utils/math.dart';

class GeometricCalculatorScreen extends StatefulWidget {
  @override
  _GeometricCalculatorScreenState createState() => _GeometricCalculatorScreenState();
}

class _GeometricCalculatorScreenState extends State<GeometricCalculatorScreen> {
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _xController = TextEditingController();

  String? _formulaProbabilidad;
  String? _resultadoProbabilidad;
  String? _formulaEsperanza;
  String? _formulaVarianza;

  void _calcular() {
    final p = double.tryParse(_pController.text);
    final x = int.tryParse(_xController.text);

    if (p != null && p > 0 && p <= 1 && x != null && x > 0) {
      final probabilidad = pow(1 - p, x - 1) * p;
      final esperanza = 1 / p;
      final varianza = (1 - p) / (p * p);

      setState(() {
        _formulaProbabilidad = r"P(X = x) = (1 - p)^{x-1} \cdot p = "
        r"(1 - " + p.toString() + r")^{" + (x - 1).toString() + r"} \cdot " + p.toString() + r" = ";

        // Llamamos a formatNumber para asegurar que el número se muestra correctamente en LaTeX
        _resultadoProbabilidad = formatNumber(probabilidad) +
            r"\approx " +
            formatNumber(probabilidad * 100) +
            r"\%";

        _formulaEsperanza = r"E(X) = \frac{1}{p} = \frac{1}{" +
            p.toString() +
            r"} = " +
            formatNumber(esperanza);

        _formulaVarianza = r"Var(X) = \frac{1-p}{p^2} = \frac{" +
            formatNumber(1 - p) +
            r"}{" +
            p.toString() +
            r"^2} = " +
            formatNumber(varianza);
      });
    } else {
      setState(() {
        _formulaProbabilidad = null;
        _resultadoProbabilidad = null;
        _formulaEsperanza = null;
        _formulaVarianza = null;
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
                  'Distribución Geométrica',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  'La distribución geométrica modela el número de intentos necesarios para obtener el primer éxito en ensayos independientes con una probabilidad constante de éxito.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fórmula:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Math.tex(
                  r"P(X = x) = (1-p)^{x-1} \cdot p",
                  textStyle: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Donde:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '- P(X = x): Probabilidad de que el primer éxito ocurra en el ensayo x.\n'
                      '- p: Probabilidad de éxito en cada ensayo.\n'
                      '- 1 - p: Probabilidad de fracaso en un ensayo.',
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
      appBar: AppBar(title: const Text('Distribución Geométrica')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _pController,
                decoration: const InputDecoration(labelText: 'Probabilidad de éxito (p)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _xController,
                decoration: const InputDecoration(labelText: 'Número de ensayos (x)'),
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
                      title: 'Esperanza:',
                      formula: _formulaEsperanza!,
                      result: "",
                    ),
                    ResultCard(
                      title: 'Varianza:',
                      formula: _formulaVarianza!,
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
