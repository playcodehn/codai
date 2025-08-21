import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:codai/widgets/habit_tile.dart'; // <-- Importa el widget

class HabbitsProgresoScreen extends StatelessWidget {
  const HabbitsProgresoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mi Progreso",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.chevron_left),
                      Text(
                        "Julio 2025",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // GRÁFICO CIRCULAR
              Center(
                child: CircularPercentIndicator(
                  radius: 120,
                  lineWidth: 12,
                  percent: 0.5,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "50%",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text("Completado", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  progressColor: Colors.yellow,
                  backgroundColor: Colors.grey[300]!,
                ),
              ),
              const SizedBox(height: 20),

              // TÍTULO HÁBITOS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mis Hábitos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    mini: true,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // LISTA DE HÁBITOS
              Expanded(
                child: ListView(
                  children: [
                    HabitTile("Beber 8 vasos de agua", "Salud", Colors.teal, true),
                    HabitTile("Ejercicio 30 min", "Salud", Colors.blue, true),
                    HabitTile("Leer 20 páginas", "Personal", Colors.orange, false),
                    HabitTile("Meditar 10 min", "Personal", Colors.purple, false),
                  ],
                ),
              ),

              // NAV BAR
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.show_chart, "Progreso", true),
                    _buildNavItem(Icons.check_box, "Hábitos", false),
                    _buildNavItem(Icons.bar_chart, "Estadística", false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNavItem(IconData icon, String label, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: selected ? Colors.green : Colors.grey),
        Text(
          label,
          style: TextStyle(color: selected ? Colors.green : Colors.grey),
        ),
      ],
    );
  }
}
