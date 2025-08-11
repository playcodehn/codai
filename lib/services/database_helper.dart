import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static SharedPreferences? _prefs;
  static bool _initialized = false;

  DatabaseHelper._init();

  Future<void> initDatabase() async {
    if (_initialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    
    // Insertar categorías por defecto si no existen
    if (!_prefs!.containsKey('categories')) {
      await _insertDefaultCategories();
    }
    
    // Insertar hábitos de ejemplo si no existen
    if (!_prefs!.containsKey('habits')) {
      await _insertDefaultHabits();
    }

    _initialized = true;
  }

  Future<void> _insertDefaultCategories() async {
    final defaultCategories = [
      Category(
        id: 1,
        name: 'Personal',
        iconPath: '👤',
        colorHex: '#FF9F80',
      ),
      Category(
        id: 2,
        name: 'Familiar',
        iconPath: '🏠',
        colorHex: '#80D8FF',
      ),
      Category(
        id: 3,
        name: 'Salud',
        iconPath: '🏥',
        colorHex: '#80CBC4',
      ),
      Category(
        id: 4,
        name: 'Trabajo',
        iconPath: '💼',
        colorHex: '#FFD180',
      ),
    ];

    final categoriesJson = defaultCategories.map((c) => c.toMap()).toList();
    await _prefs!.setString('categories', jsonEncode(categoriesJson));
  }

  Future<void> _insertDefaultHabits() async {
    final defaultHabits = [
      Habit(
        id: 1,
        name: 'Beber 8 vasos de agua',
        categoryId: 3,
        categoryName: 'Salud',
        colorHex: '#80CBC4',
      ),
      Habit(
        id: 2,
        name: 'Ejercicio 30 min',
        categoryId: 3,
        categoryName: 'Salud',
        colorHex: '#80CBC4',
      ),
      Habit(
        id: 3,
        name: 'Leer 20 páginas',
        categoryId: 1,
        categoryName: 'Personal',
        colorHex: '#FF9F80',
      ),
      Habit(
        id: 4,
        name: 'Meditar 10 min',
        categoryId: 1,
        categoryName: 'Personal',
        colorHex: '#FF9F80',
      ),
    ];

    final habitsJson = defaultHabits.map((h) => h.toMap()).toList();
    await _prefs!.setString('habits', jsonEncode(habitsJson));
  }

  // Métodos para Categorías
  Future<List<Category>> getCategories() async {
    await initDatabase();
    
    final categoriesString = _prefs!.getString('categories') ?? '[]';
    final categoriesJson = jsonDecode(categoriesString) as List;
    
    List<Category> categories = categoriesJson
        .map((json) => Category.fromMap(json))
        .toList();
    
    // Actualizar contador de hábitos
    final habits = await getHabits();
    for (var category in categories) {
      final habitCount = habits
          .where((habit) => habit.categoryId == category.id)
          .length;
      category.habitCount = habitCount;
    }
    
    return categories;
  }

  Future<Category> insertCategory(Category category) async {
    await initDatabase();
    
    final categories = await getCategories();
    final nextId = categories.isEmpty ? 1 : categories.map((c) => c.id!).reduce((a, b) => a > b ? a : b) + 1;
    category.id = nextId;
    
    categories.add(category);
    final categoriesJson = categories.map((c) => c.toMap()).toList();
    await _prefs!.setString('categories', jsonEncode(categoriesJson));
    
    return category;
  }

  Future<void> updateCategory(Category category) async {
    await initDatabase();
    
    final categories = await getCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      final categoriesJson = categories.map((c) => c.toMap()).toList();
      await _prefs!.setString('categories', jsonEncode(categoriesJson));
    }
  }

  Future<void> deleteCategory(int id) async {
    await initDatabase();
    
    // Eliminar hábitos de la categoría
    final habits = await getHabits();
    final remainingHabits = habits.where((habit) => habit.categoryId != id).toList();
    final habitsJson = remainingHabits.map((h) => h.toMap()).toList();
    await _prefs!.setString('habits', jsonEncode(habitsJson));
    
    // Eliminar categoría
    final categories = await getCategories();
    final remainingCategories = categories.where((c) => c.id != id).toList();
    final categoriesJson = remainingCategories.map((c) => c.toMap()).toList();
    await _prefs!.setString('categories', jsonEncode(categoriesJson));
  }

  // Métodos para Hábitos
  Future<List<Habit>> getHabits() async {
    await initDatabase();
    
    final habitsString = _prefs!.getString('habits') ?? '[]';
    final habitsJson = jsonDecode(habitsString) as List;
    
    return habitsJson.map((json) => Habit.fromMap(json)).toList();
  }

  Future<List<Habit>> getHabitsByCategory(int categoryId) async {
    final habits = await getHabits();
    return habits.where((habit) => habit.categoryId == categoryId).toList();
  }

  Future<Habit> insertHabit(Habit habit) async {
    await initDatabase();
    
    final habits = await getHabits();
    final nextId = habits.isEmpty ? 1 : habits.map((h) => h.id!).reduce((a, b) => a > b ? a : b) + 1;
    habit.id = nextId;
    
    habits.add(habit);
    final habitsJson = habits.map((h) => h.toMap()).toList();
    await _prefs!.setString('habits', jsonEncode(habitsJson));
    
    return habit;
  }

  Future<void> updateHabit(Habit habit) async {
    await initDatabase();
    
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      final habitsJson = habits.map((h) => h.toMap()).toList();
      await _prefs!.setString('habits', jsonEncode(habitsJson));
    }
  }

  Future<void> deleteHabit(int id) async {
    await initDatabase();
    
    final habits = await getHabits();
    final remainingHabits = habits.where((h) => h.id != id).toList();
    final habitsJson = remainingHabits.map((h) => h.toMap()).toList();
    await _prefs!.setString('habits', jsonEncode(habitsJson));
  }
}
