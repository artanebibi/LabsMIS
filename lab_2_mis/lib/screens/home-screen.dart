import 'package:flutter/material.dart';
import 'package:lab_2_mis/models/category.dart';
import 'package:lab_2_mis/screens/favourite-meals-screen.dart';
import 'package:lab_2_mis/screens/notification-test-screen.dart';
import 'package:lab_2_mis/screens/profile-screen.dart';
import 'package:lab_2_mis/widgets/category-grid.dart';

import '../service/api-service.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<MealCategory> _categories = [];
  List<MealCategory> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchCategories() async {
    final categoriesList =
    (await _apiService.getAllCategories()).cast<MealCategory>();
    setState(() {
      _categories = categoriesList;
      _filteredCategories = _categories;
    });
  }

  void filterCategories(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories.where((c) {
          return c.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            tooltip: 'Random Meal',
            onPressed: () async {
              try {
                final apiService = ApiService();
                final randomMeal = await apiService.getMealById(null);
                Navigator.pushNamed(context, "/mealDetails", arguments: randomMeal);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load random meal')),
                );
              }
            },
          ),
          IconButton(onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FavouriteMealsScreen())),
              icon: Icon(Icons.favorite_outlined, color: Colors.red.shade700)),
          IconButton(onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfilePage())),
              icon: Icon(Icons.person, color: Colors.black)),
          IconButton(onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NotificationTestScreen())),
              icon: Icon(Icons.notifications, color: Colors.black)),


        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search category...",
                border: OutlineInputBorder(),
              ),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: CategoryGrid(categories: _filteredCategories),
          ),
        ],
      ),
    );
  }
}
