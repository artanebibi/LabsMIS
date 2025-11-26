import 'package:flutter/material.dart';
import 'package:lab_2_mis/models/category.dart';

class CategoryCard extends StatelessWidget {
  final MealCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/mealsByCategory", arguments: category.name);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(child: Image.network(category.thumbnail)),
              Divider(),
              Text(category.name),
              Text(category.description),
            ],
          ),
        ),
      ),
    );
  }
}
