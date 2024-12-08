import 'package:calculadoraestadistica/screens/geometric_calculator_screen.dart';
import 'package:calculadoraestadistica/screens/hipergeometric_calculator_screen.dart';
import 'package:flutter/material.dart';
import 'binomial_calculator_screen.dart';
import 'poisson_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribuciónes Estadística II'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard(
              context,
              title: 'Distribución Binomial',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BinomialCalculatorScreen()),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Distribución Poisson',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PoissonCalculatorScreen()),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Distribución Geométrica',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeometricCalculatorScreen()),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Distribución Hipergeométrica',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HyperGeometricCalculatorScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.indigo,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
