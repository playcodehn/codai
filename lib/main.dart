import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estadísticas',
      theme: ThemeData(fontFamily: 'Inter'),
      home: const StatisticsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Barra_nav_inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Estadísticas seleccionada
        selectedItemColor: const Color(0xFF6480E4), // Color morado claro
        unselectedItemColor: Colors.grey,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estadística',
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          // Evita overflow
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Encabezado
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Text(
                      'Estadísticas',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 30),

              // Tarjetas de estadísticas principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildStatCard('28', 'Días Activos')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('85%', 'Tasa de Éxito')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('12', 'Racha Actual')),
                ],
              ),
              const SizedBox(height: 30),

              // Mensaje_progreso
              _buildProgressMessage(),
              const SizedBox(height: 30),

              // Título progreso mensual
              const Text(
                'Progreso Mensual',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Barras_etiquetas_valores 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProgressBar(0.60, 'Sem 1'),
                  _buildProgressBar(0.75, 'Sem 2'),
                  _buildProgressBar(0.85, 'Sem 3'),
                  _buildProgressBar(0.20, 'Sem 4'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tarjeta de estadísticas
  static Widget _buildStatCard(String value, String title) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6480E4), // Color solicitado
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  // Mensaje de progreso
  static Widget _buildProgressMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8B3DFF), // Fondo morado
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.center,
            '¡Excelente progreso!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            textAlign: TextAlign.center,
            'Has mantenido una consistencia increíble este mes. '
            'Sigue así para alcanzar tu mejor versión.',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Barra_porcentaje
  static Widget _buildProgressBar(double percent, String weekLabel) {
    return Column(
      children: [
        Container(
          height: 140,
          width: 50, // Más juntas
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120 * percent,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6480E4), Color(0xFF8B3DFF)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${(percent * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white, // Porcentaje blanco
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(weekLabel, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
