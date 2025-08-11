import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/habit.dart';
import '../services/database_helper.dart';

class CategoryHabitsScreen extends StatefulWidget {
  final Category category;
  final VoidCallback onHabitsChanged;

  const CategoryHabitsScreen({
    Key? key,
    required this.category,
    required this.onHabitsChanged,
  }) : super(key: key);

  @override
  _CategoryHabitsScreenState createState() => _CategoryHabitsScreenState();
}

class _CategoryHabitsScreenState extends State<CategoryHabitsScreen> {
  late Future<List<Habit>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _refreshHabits();
  }

  void _refreshHabits() {
    _habitsFuture = DatabaseHelper.instance.getHabitsByCategory(widget.category.id!);
    setState(() {});
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos de ${widget.category.name}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddHabitDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay hábitos en esta categoría'));
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 16,
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 16, color: Colors.white),
                          onPressed: () {
                            _showEditHabitDialog(context, habit);
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
                            _refreshHabits();
                            widget.onHabitsChanged();
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
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nuevo Hábito'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Nombre del hábito',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final habit = Habit(
                  name: nameController.text,
                  categoryId: widget.category.id!,
                  categoryName: widget.category.name,
                  colorHex: widget.category.colorHex,
                );
                
                await DatabaseHelper.instance.insertHabit(habit);
                _refreshHabits();
                widget.onHabitsChanged();
                Navigator.pop(context);
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final TextEditingController nameController = TextEditingController(text: habit.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final updatedHabit = Habit(
                  id: habit.id,
                  name: nameController.text,
                  categoryId: habit.categoryId,
                  categoryName: habit.categoryName,
                  colorHex: habit.colorHex,
                );
                
                await DatabaseHelper.instance.updateHabit(updatedHabit);
                _refreshHabits();
                widget.onHabitsChanged();
                Navigator.pop(context);
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
