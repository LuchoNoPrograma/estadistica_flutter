import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class HyperGeometricCalculatorScreen extends StatefulWidget {
  @override
  _HyperGeometricCalculatorScreenState createState() =>
      _HyperGeometricCalculatorScreenState();
}

class _HyperGeometricCalculatorScreenState
    extends State<HyperGeometricCalculatorScreen> {
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _NController = TextEditingController();
  final TextEditingController _KController = TextEditingController();

  List<ChartData> _graphPoints = [];
  List<TableRow> _tablaResultados = [];

  double _factorial(int num) {
    if (num <= 1) return 1.0;
    return num * _factorial(num - 1);
  }

  double _combination(int n, int k) {
    if (k > n) return 0;
    return _factorial(n) / (_factorial(k) * _factorial(n - k));
  }

  void _calcular() {
    final N = int.tryParse(_NController.text);
    final K = int.tryParse(_KController.text);
    final n = int.tryParse(_nController.text);

    if (N == null || K == null || n == null || N <= 0 || K <= 0 || n <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa valores válidos para N, r y n.'),
        ),
      );
      return;
    }

    List<ChartData> points = [];
    List<TableRow> tabla = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'k',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'P(X = k)',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ];

    for (int k = 0; k <= n; k++) {
      if (k > K || (n - k) > (N - K)) continue;

      final numerator = _combination(K, k) * _combination(N - K, n - k);
      final denominator = _combination(N, n);
      final probability = numerator / denominator;

      points.add(ChartData(k, probability));
      tabla.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$k',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                probability.toStringAsFixed(4),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      _graphPoints = points;
      _tablaResultados = tabla;
    });
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
                controller: _NController,
                decoration: const InputDecoration(
                  labelText: 'Tamaño total de la población (N)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _KController,
                decoration: const InputDecoration(
                  labelText: 'Número de elementos deseados en la población (r)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _nController,
                decoration: const InputDecoration(
                  labelText: 'Tamaño de la muestra (n)',
                ),
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
                'Modelado de distribución hipergeométrica',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              if (_graphPoints.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      tooltipSettings: const InteractiveTooltip(
                        color: Colors.indigo,
                        textStyle: TextStyle(color: Colors.white),
                        format: 'k: point.x, P(X = k): point.y',
                      ),
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      zoomMode: ZoomMode.xy,
                      enablePanning: true,
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, int>(
                        dataSource: _graphPoints,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (_tablaResultados.isNotEmpty)
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Tabla de Probabilidades',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(),
                            children: _tablaResultados,
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
