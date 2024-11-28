import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../utils/math.dart';

class BinomialCalculatorScreen extends StatefulWidget {
  @override
  _BinomialCalculatorScreenState createState() =>
      _BinomialCalculatorScreenState();
}

class _BinomialCalculatorScreenState extends State<BinomialCalculatorScreen> {
  final TextEditingController _nController = TextEditingController();
  final TextEditingController _pController = TextEditingController();

  List<ChartData> _graphPoints = [];
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
        SnackBar(content: Text('Por favor, ingresa valores válidos para n y p.')),
      );
      return;
    }

    // Validación para asegurarse de que n esté entre 1 y 170
    if (n <= 0 || n > 170) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El valor de n debe ser mayor que 0 y menor o igual a 170.')),
      );
      return;
    }

    List<ChartData> points = [];
    double maxProbabilidad = 0;
    int maxK = 0;

    for (int x = 0; x <= n; x++) {
      final combinatoria = _factorial(n) / (_factorial(x) * _factorial(n - x));
      final probabilidad = combinatoria * pow(p, x) * pow(1 - p, n - x);
      points.add(ChartData(x, probabilidad));

      // Encontrar la probabilidad máxima
      if (probabilidad > maxProbabilidad) {
        maxProbabilidad = probabilidad;
        maxK = x;  // Guardar el valor de k correspondiente
      }
    }

    // Calcular media, varianza y desviación estándar
    _media = n * p;
    _varianza = n * p * (1 - p);
    _desviacionEstandar = sqrt(_varianza!);

    // Guardar la probabilidad más alta y k correspondiente
    _probabilidadMaxima = maxProbabilidad;
    _kMaxProbabilidad = maxK;

    setState(() {
      _graphPoints = points;
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
              // Texto informativo sobre la gráfica
              const Text(
                'Puedes acercar con los dedos o desplazar horizontalmente para ver más detalles.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              const Text(
                'Presiona un punto de la gráfica para ver más detalles.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              if (_graphPoints.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,  // Modo de activación
                      tooltipSettings: const InteractiveTooltip(
                        color: Colors.indigo,
                        textStyle: TextStyle(color: Colors.white), format: 'k: point.x, Probabilidad: point.y'
                      ),
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,  // Habilitar zoom con pellizco
                      zoomMode: ZoomMode.xy,  // Permite el zoom en ambos ejes
                      enablePanning: true,  // Habilitar desplazamiento
                    ),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, int>(
                        dataSource: _graphPoints,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        markerSettings: const MarkerSettings(isVisible: true),
                        color: Colors.indigo, // Color de la línea de la gráfica
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (_media != null)
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),  // Margen alrededor de la Card
                    elevation: 4,  // Sombra de la Card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),  // Padding interno de la Card
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,  // Centra el contenido verticalmente
                        crossAxisAlignment: CrossAxisAlignment.center,  // Centra el contenido horizontalmente
                        children: [
                          Math.tex(
                            r'\text{Media(} μ \text{)} = ' + formatNumber(_media!),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),  // Espacio entre las fórmulas
                          Math.tex(
                            r'\text{Varianza =}\sigma^2 = ' + formatNumber(_varianza!),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),  // Espacio entre las fórmulas
                          Math.tex(
                            r'\text{Desviación estándar}= \sqrt{\sigma^2} = ' + formatNumber(_desviacionEstandar!),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),  // Espacio entre las fórmulas
                          Math.tex(
                            r'\text{Mayor probabilidad: } ' +
                                formatNumber(_probabilidadMaxima!)+
                                r' \ \text{para} \ k = ' +
                                '$_kMaxProbabilidad',
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
