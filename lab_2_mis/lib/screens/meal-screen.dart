import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lab_2_mis/models/meal.dart';
import 'package:lab_2_mis/service/api-service.dart';
import 'package:lab_2_mis/widgets/meal-grid.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final ApiService _apiService = ApiService();
  List<Meal> _meals = [];
  late final String categoryName;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      categoryName =
      ModalRoute.of(context)!.settings.arguments as String;
      fetchMeals();
      _initialized = true;
    }
  }

  void fetchMeals() async {
    final meals = await _apiService.getAllMealsByCategory(categoryName);
    setState(() {
      _meals = meals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Recipe App"),
        ),
      ),
      body: MealGrid(meals: _meals),
    );
  }
}
