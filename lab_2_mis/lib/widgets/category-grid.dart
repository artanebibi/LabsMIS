import 'package:flutter/material.dart';
import 'package:lab_2_mis/models/category.dart';
import 'package:lab_2_mis/widgets/category-card.dart';

class CategoryGrid extends StatefulWidget {
  final List<MealCategory> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  State<StatefulWidget> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, idx) {
        var category = widget.categories[idx];
        return Padding(
          padding: EdgeInsets.all(20),
          child: CategoryCard(category: category),
        );
      },
    );
  }
}
