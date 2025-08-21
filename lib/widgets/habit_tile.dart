import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String title;
  final String category;
  final Color color;
  final bool active;

  const HabitTile(this.title, this.category, this.color, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          radius: 18,
          child: CircleAvatar(
            backgroundColor: color,
            radius: 6,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          category,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: Switch(
          value: active,
          activeColor: color,
          onChanged: (_) {},
        ),
      ),
    );
  }
}
