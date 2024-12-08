import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class BinomialCalculatorScreen extends StatefulWidget {
  @override
  _BinomialCalculatorScreenState createState() =>
      _BinomialCalculatorScreenState();
}

class _BinomialCalculatorScreenState extends State<BinomialCalculatorScreen> {
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _pController = TextEditingController();

  List<ChartData> _graphPoints = [];
  List<TableRow> _tablaResultados = [];
  String? _errorMessage;
  double? _media;
  double? _varianza;
  double? _desviacionEstandar;
  double? _probabilidadMaxima;
  int? _kMaxProbabilidad;

  void _calcular() {
    final n = int.tryParse(_nController.text);
    final p = double.tryParse(_pController.text);

    if (n == null || p == null || p < 0 || p > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa valores válidos para n y p.')),
      );
      return;
    }

    if (n <= 0 || n > 170) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El valor de n debe ser mayor que 0 y menor o igual a 170.')),
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
              'Probabilidad',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ];

    double maxProbabilidad = 0;
    int maxK = 0;

    for (int x = 0; x <= n; x++) {
      final combinatoria = _factorial(n) / (_factorial(x) * _factorial(n - x));
      final probabilidad = combinatoria * pow(p, x) * pow(1 - p, n - x);
      points.add(ChartData(x, probabilidad));
      tabla.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$x', textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(probabilidad.toStringAsFixed(4), textAlign: TextAlign.center),
            ),
          ],
        ),
      );

      if (probabilidad > maxProbabilidad) {
        maxProbabilidad = probabilidad;
        maxK = x;
      }
    }

    setState(() {
      _graphPoints = points;
      _tablaResultados = tabla;
      _media = n * p;
      _varianza = n * p * (1 - p);
      _desviacionEstandar = sqrt(_varianza!);
      _probabilidadMaxima = maxProbabilidad;
      _kMaxProbabilidad = maxK;
    });
  }

  double _factorial(int k) {
    if (k <= 0) return 1;
    double result = k.toDouble();
    for (int i = k - 1; i > 0; i--) {
      result *= i;
    }
    return result;
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
                decoration: const InputDecoration(labelText: 'Número de ensayos (n)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _pController,
                decoration: const InputDecoration(labelText: 'Probabilidad de éxito (p)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calcular,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Modelado de distribución binomial',
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
                        format: 'k: point.x, Probabilidad: point.y',
                      ),
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      zoomMode: ZoomMode.xy,
                      enablePanning: true,
                    ),
                    series: <CartesianSeries>[
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
              const SizedBox(height: 20),
              if (_media != null)
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
                            r'\text{Media(} μ \text{)} = ' + _media!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Math.tex(
                            r'\text{Varianza(σ²)} = ' + _varianza!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Math.tex(
                            r'\text{Desviación estándar(σ)} = ' +
                                _desviacionEstandar!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Math.tex(
                            r'\text{Mayor probabilidad} = ' +
                                _probabilidadMaxima!.toStringAsFixed(4) +
                                r'\ \text{para } k = ' +
                                _kMaxProbabilidad.toString(),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Tabla de Probabilidades',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
