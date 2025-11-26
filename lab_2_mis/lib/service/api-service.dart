import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lab_2_mis/models/meal.dart';
import '../models/category.dart';

class ApiService {
  Future<List<MealCategory>> getAllCategories() async {
    final response = await http.get(
      Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed fetching categories");
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final responseList = decoded["categories"] as List<dynamic>;

    return responseList
        .map(
          (category) => MealCategory.fromJson(category as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<Meal>> getAllMealsByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName",
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed fetching categories");
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final responseList = decoded["meals"] as List<dynamic>;

    return responseList
        .map((m) => Meal.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<Meal> getMealById(int? id) async {
    String uri = (id != null)
        ? 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'
        : 'https://www.themealdb.com/api/json/v1/1/random.php';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode != 200) {
      throw Exception("Failed fetching meal by ID");
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final responseList = decoded["meals"] as List<dynamic>;
    print(responseList);

    if (responseList.isEmpty || responseList.first == null) {
      throw Exception("Meal not found");
    }

    return Meal.fromJson(responseList.first as Map<String, dynamic>);
  }
}
