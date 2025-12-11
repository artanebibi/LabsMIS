import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_2_mis/service/api-service.dart';
import 'package:lab_2_mis/service/favourites-service.dart';
import 'package:lab_2_mis/widgets/meal-grid.dart';
import 'dart:async';

import '../models/meal.dart';

class FavouriteMealsScreen extends StatefulWidget {
  const FavouriteMealsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavouriteMealsScreenState();
}

class _FavouriteMealsScreenState extends State<FavouriteMealsScreen> {
  final ApiService _apiService = ApiService();
  late final FavoritesService _favoritesService = FavoritesService(_apiService);

  List<Meal> meals = [];
  bool _isLoading = true;

  StreamSubscription<List<String>>? _favoritesSubscription;

  @override
  void initState() {
    super.initState();
    _startFavoritesListener();
  }

  void _startFavoritesListener() {
    _favoritesSubscription = _favoritesService.favoritesStream().listen(
      (mealIds) {
        _fetchMealsFromIds(mealIds);
      },
      onError: (error) {
        print('Error in favorites stream: $error');
        setState(() {
          _isLoading = false;
        });
      },
      onDone: () => print('Favorites stream closed'),
    );
  }

  void _fetchMealsFromIds(List<String> mealIds) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    List<Future<Meal>> mealFutures = mealIds
        .map((idString) => int.tryParse(idString))
        .where((id) => id != null)
        .map((id) => _apiService.getMealById(id))
        .toList();

    try {
      final fetchedMeals = await Future.wait(mealFutures);

      setState(() {
        meals = fetchedMeals;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch meals after stream update: $e');
      setState(() {
        meals = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (meals.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Your Favourite Meals")),
        body: const Center(child: Text('No favorite meals found.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Your Favourite Meals")),
      body: MealGrid(meals: meals),
    );
  }
}
