import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class PoissonCalculatorScreen extends StatefulWidget {
  @override
  _PoissonCalculatorScreenState createState() => _PoissonCalculatorScreenState();
}

class _PoissonCalculatorScreenState extends State<PoissonCalculatorScreen> {
  final TextEditingController _muController = TextEditingController();
  final TextEditingController _kController = TextEditingController();

  List<ChartData> _graphPoints = [];
  List<ChartData> _areaPoints = [];
  double? _varianza;
  double? _probabilidadMaxima;
  int? _kMaxProbabilidad;

  void _calcular() {
    final mu = double.tryParse(_muController.text);
    final k = int.tryParse(_kController.text);

    if (mu == null || mu <= 0 || k == null || k < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa valores válidos para μ y k.'),
        ),
      );
      return;
    }

    List<ChartData> points = [];
    List<ChartData> areaPoints = [];
    double maxProbabilidad = 0;
    int maxK = 0;

    for (int x = 0; x <= k; x++) {
      final probabilidad = (pow(mu, x) * exp(-mu)) / factorial(x);
      points.add(ChartData(x, probabilidad));
      areaPoints.add(ChartData(x, probabilidad));

      if (probabilidad > maxProbabilidad) {
        maxProbabilidad = probabilidad;
        maxK = x;
      }
    }

    setState(() {
      _graphPoints = points;
      _areaPoints = areaPoints;
      _varianza = mu; // En Poisson, varianza = μ
      _probabilidadMaxima = maxProbabilidad;
      _kMaxProbabilidad = maxK;
    });
  }

  double factorial(int k) {
    if (k <= 0) return 1;
    double result = 1;
    for (int i = 1; i <= k; i++) {
      result *= i;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Distribución de Poisson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _muController,
                decoration: const InputDecoration(labelText: 'Número esperado (μ)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _kController,
                decoration: const InputDecoration(labelText: 'Número máximo de éxitos (k)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calcular,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Modelado de distribución Poisson',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (_graphPoints.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(title: AxisTitle(text: 'k')),
                    primaryYAxis: NumericAxis(title: AxisTitle(text: 'Probabilidad')),
                    series: <CartesianSeries>[
                      // Área debajo de la curva
                      ColumnSeries<ChartData, int>(
                        dataSource: _areaPoints,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.indigo.withOpacity(0.5),
                      ),
                      // Línea de la función de Poisson
                      LineSeries<ChartData, int>(
                        dataSource: _graphPoints,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        markerSettings: const MarkerSettings(isVisible: true),
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ),
              if (_varianza != null)
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Math.tex(
                            r'\text{Varianza (σ²)} = ' + _varianza!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Math.tex(
                            r'\text{Mayor probabilidad: } ' +
                                _probabilidadMaxima!.toStringAsFixed(4) +
                                r' \ \text{para } k = ' +
                                '$_kMaxProbabilidad',
                            textStyle: const TextStyle(fontSize: 16),
                          ),

                          // Tabla de valores
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tabla de probabilidades',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              DataTable(
                                columns: const [
                                  DataColumn(label: Text('k')),
                                  DataColumn(label: Text('Probabilidad')),
                                ],
                                rows: _graphPoints.map((data) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data.x.toString())),
                                      DataCell(Text(data.y.toStringAsFixed(4))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}
