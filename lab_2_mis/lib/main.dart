import 'package:flutter/material.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:lab_2_mis/screens/favourite-meals-screen.dart';
import 'package:lab_2_mis/screens/login-screen.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import './service/notification-service.dart';

// Screens
import 'package:lab_2_mis/screens/home-screen.dart';
import 'package:lab_2_mis/screens/meal-screen.dart';
import 'package:lab_2_mis/screens/profile-screen.dart';
import 'package:lab_2_mis/screens/recipe-screen.dart';
import 'package:lab_2_mis/screens/register-screen.dart';
import 'package:lab_2_mis/service/api-service.dart';

import 'models/meal.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  NotificationService.onNotificationTap = () async {
    try {
      ApiService apiService = ApiService();
      Meal randomMeal = await apiService.getMealById(null);

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => RecipeScreen(),
          settings: RouteSettings(arguments: randomMeal),
        ),
      );
    } catch (e) {
      print('Error fetching random meal: $e');
    }
  };

  await notificationService.scheduleDailyRecipeNotification(hour: 9, minute: 0);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginPage(),
        "/home": (context) => HomeScreen(),
        "/mealsByCategory": (context) => MealScreen(),
        "/mealDetails": (context) => RecipeScreen(),
        "/favouriteMeals": (context) => FavouriteMealsScreen(),
        "/profile": (context) => ProfilePage(),
        "/register": (context) => RegisterPage()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
    return Scaffold(body: HomeScreen());
  }
}
