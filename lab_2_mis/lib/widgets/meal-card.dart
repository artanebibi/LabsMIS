import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/mealDetails", arguments: meal);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Center(child: Image.network(meal.thumbnail),),
            Divider(),
            Expanded(child: Text(meal.name)),
          ]),
        ),
      ),
    );
  }
}
