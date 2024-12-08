import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class GeometricCalculatorScreen extends StatefulWidget {
  @override
  _GeometricCalculatorScreenState createState() =>
      _GeometricCalculatorScreenState();
}

class _GeometricCalculatorScreenState extends State<GeometricCalculatorScreen> {
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _kController = TextEditingController();

  List<ChartData> _graphPoints = [];
  List<TableRow> _tablaResultados = [];
  double? _media;
  double? _varianza;

  void _calcular() {
    final p = double.tryParse(_pController.text);
    final maxK = int.tryParse(_kController.text);

    if (p == null || p <= 0 || p > 1 || maxK == null || maxK <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa valores válidos para p y k.'),
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
              'Número de ensayos',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Probabilidad del primer éxito',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ];

    for (int k = 1; k <= maxK; k++) {
      final probabilidad = pow(1 - p, k - 1) * p;
      points.add(ChartData(k, probabilidad));
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
                probabilidad.toStringAsFixed(4),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      _graphPoints = points;
      _media = 1 / p;
      _varianza = (1 - p) / (p * p);
      _tablaResultados = tabla;
    });
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
                decoration: const InputDecoration(
                  labelText: 'Probabilidad de éxito (p)',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _kController,
                decoration: const InputDecoration(
                  labelText: 'Número máximo de intentos (k)',
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
                'Modelado de distribución geométrica',
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
                            r'\text{Media (μ)} = ' + _media!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Math.tex(
                            r'\text{Varianza (σ²)} = ' + _varianza!.toStringAsFixed(2),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
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
