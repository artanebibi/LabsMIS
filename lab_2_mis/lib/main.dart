import 'package:flutter/material.dart';
import 'package:lab_2_mis/screens/home-screen.dart';
import 'package:lab_2_mis/screens/meal-screen.dart';
import 'package:lab_2_mis/screens/recipe-screen.dart';
import 'package:lab_2_mis/service/api-service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      initialRoute: "/",
      routes: {
        "/home": (context) => HomeScreen(),
        "/mealsByCategory": (context) => MealScreen(),
        "/mealDetails": (context) => RecipeScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        ],
      ),
      body: HomeScreen(),
    );
  }
}
