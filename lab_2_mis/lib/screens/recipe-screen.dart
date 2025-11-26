import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../service/api-service.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final ApiService _apiService = ApiService();
  Meal? _fullMeal;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;
    _fetchFullMealDetails(meal.id);
  }

  Future<void> _fetchFullMealDetails(int mealId) async {
    try {
      final meal = await _apiService.getMealById(mealId);
      setState(() {
        _fullMeal = meal;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Meal Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_fullMeal == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Meal Details')),
        body: Center(child: Text('Failed to load meal details')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_fullMeal!.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(_fullMeal!.thumbnail),
            SizedBox(height: 16),
            if (_fullMeal!.ingredients != null) ...[
              Text('Ingredients:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ..._fullMeal!.ingredients!.map((ing) => Text('• ${ing.toString()}')),
              SizedBox(height: 16),
            ],
            if (_fullMeal!.instructions != null) ...[
              Text('Instructions:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(_fullMeal!.instructions!),
            ],
            if (_fullMeal?.youtubeLink != null) ...[
              SizedBox(height: 22,),
              Text('YoutubeURL:', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
              Text(_fullMeal!.youtubeLink!),
            ]
          ],
        ),
      ),
    );
  }
}