import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';
import 'category_habits_screen.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Habit>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _categoriesFuture = DatabaseHelper.instance.getCategories();
    _habitsFuture = DatabaseHelper.instance.getHabits();
    setState(() {});
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  void _showEditHabitDialog(Habit habit) {
    final TextEditingController nameController = TextEditingController(text: habit.name);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Hábito'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nombre del hábito',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final updatedHabit = Habit(
                    id: habit.id,
                    name: nameController.text.trim(),
                    categoryId: habit.categoryId,
                    categoryName: habit.categoryName,
                    colorHex: habit.colorHex,
                  );
                  await DatabaseHelper.instance.updateHabit(updatedHabit);
                  _refreshData();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Aquí implementarás la navegación hacia atrás
          },
        ),
        title: Text(
          'Gestionar Hábitos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Este botón lo implementarás tú según mencionaste
          FloatingActionButton(
            mini: true,
            child: Icon(Icons.add),
            onPressed: () {
              // Aquí implementarás la creación de un nuevo hábito
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Categorías
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 250, // Aumentado para acomodar dos filas
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay categorías disponibles'));
                }
                
                final categories = snapshot.data!;
                // Dividir categorías en dos filas
                final firstRowCategories = <Category>[];
                final secondRowCategories = <Category>[];
                
                for (int i = 0; i < categories.length; i++) {
                  if (i % 2 == 0) {
                    firstRowCategories.add(categories[i]);
                  } else {
                    secondRowCategories.add(categories[i]);
                  }
                }
                
                return Column(
                  children: [
                    // Primera fila
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: firstRowCategories.length,
                        itemBuilder: (context, index) {
                          final category = firstRowCategories[index];
                          return _buildCategoryCard(category);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    // Segunda fila
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: secondRowCategories.length,
                        itemBuilder: (context, index) {
                          final category = secondRowCategories[index];
                          return _buildCategoryCard(category);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Sección de Todos los Hábitos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Todos los Hábitos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Habit>>(
              future: _habitsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay hábitos disponibles'));
                }
                
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final habit = snapshot.data![index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getColorFromHex(habit.colorHex),
                          radius: 12,
                        ),
                        title: Text(
                          habit.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(habit.categoryName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 16,
                              child: IconButton(
                                icon: Icon(Icons.edit, size: 16, color: Colors.white),
                                onPressed: () {
                                  _showEditHabitDialog(habit);
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 16,
                              child: IconButton(
                                icon: Icon(Icons.delete, size: 16, color: Colors.white),
                                onPressed: () async {
                                  await DatabaseHelper.instance.deleteHabit(habit.id!);
                                  _refreshData();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
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
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryHabitsScreen(
              category: category,
              onHabitsChanged: _refreshData,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: _getColorFromHex(category.colorHex),
              width: 5,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.iconPath,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${category.habitCount}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
