import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class ResultCard extends StatelessWidget{
  final String title;
  final String formula;
  final String result;

  const ResultCard({super.key, required this.title, required this.formula, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        color: Colors.blueGrey[35],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Contenedor con scroll horizontal separado
              SizedBox(
                height: 60, // Ajusta la altura total del contenedor
                child: Scrollbar(
                  thumbVisibility: true, // La barra es visible
                  thickness: 8,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Math.tex(
                        formula,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (result.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  'Resultado:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 60, // Ajusta esta altura si el resultado es más grande
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 8,
                    radius: const Radius.circular(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Math.tex(
                          result,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
}