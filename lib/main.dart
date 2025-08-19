import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color selectedColor = Colors.blue; // variable de estado global

  void _showAddHabitDialog() {
    final _formKey = GlobalKey<FormState>();
    String habitName = "";
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nuevo Hábito"),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre del hábito
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nombre del hábito",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Ej: Beber 8 vasos de agua",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors
                                  .grey, // color del borde cuando no está enfocado
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(
                                0xFF657EEB,
                              ), // color del borde cuando está enfocado
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) => habitName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor escribe un nombre";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Categoría
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Categoría",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Personal",
                            child: Text("Personal"),
                          ),
                          DropdownMenuItem(
                            value: "Trabajo",
                            child: Text("Trabajo"),
                          ),
                          DropdownMenuItem(
                            value: "Estudio",
                            child: Text("Estudio"),
                          ),
                          DropdownMenuItem(value: "Otro", child: Text("Otro")),
                        ],
                        onChanged: (value) => selectedCategory = value,
                        validator: (value) {
                          if (value == null) {
                            return "Selecciona una categoría";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Selector de color
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Color del Hábito:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          buildColorCircle(Color(0xFFFD6B6B)),
                          const SizedBox(width: 12),
                          buildColorCircle(Color(0xFF4CCEC4)),
                          const SizedBox(width: 12),
                          buildColorCircle(Color(0xFF47B6D1)),
                          const SizedBox(width: 12),
                          buildColorCircle(Color(0xFF96CEB3)),
                          const SizedBox(width: 12),
                          buildColorCircle(Color(0xFFFDEAA6)),
                          const SizedBox(width: 12),
                          buildColorCircle(Color(0xFFDBA1DE)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón Cancelar
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Color(0xFF657EEB),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                ),
                const SizedBox(width: 12), // espacio entre botones
                // Botón Guardar
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF657EEB),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Hábito: $habitName");
                        print("Categoría: $selectedCategory");
                        print("Color: $selectedColor");
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Guardar"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color,
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: const Text('Pulsa el botón para agregar un hábito')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
