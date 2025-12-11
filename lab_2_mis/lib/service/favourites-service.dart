import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_2_mis/service/api-service.dart';
import 'package:lab_2_mis/models/meal.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final ApiService _apiService;

  FavoritesService(this._apiService);

  String get userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  Future<void> addFavorite(String mealId) async {
    try {
      await _firestore.collection('favourite-meals').doc(userId).set({
        'mealIds': FieldValue.arrayUnion([mealId])
      }, SetOptions(merge: true));
      print('Added favorite: $mealId for user: $userId');
    } catch (e) {
      print('Error adding favorite: $e');
      throw e;
    }
  }

  Future<void> removeFavorite(String mealId) async {
    try {
      await _firestore.collection('favourite-meals').doc(userId).update({
        'mealIds': FieldValue.arrayRemove([mealId])
      });
      print('Removed favorite: $mealId');
    } catch (e) {
      print('Error removing favorite: $e');
      throw e;
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('favourite-meals').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        List<dynamic> mealIds = (doc.data() as Map<String, dynamic>)['mealIds'] ?? [];
        return mealIds.map((id) => id.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  Future<List<Meal>> getFavoriteMeals() async {
    List<String> mealIds = await getFavorites();

    if (mealIds.isEmpty) {
      return [];
    }

    List<int?> ids = mealIds.map((id) => int.tryParse(id)).toList();

    List<Future<Meal>> mealFutures = ids
        .where((id) => id != null)
        .map((id) => _apiService.getMealById(id))
        .toList();

    try {
      List<Meal> meals = await Future.wait(mealFutures);
      return meals;
    } catch (e) {
      print('Error fetching favorite meals: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String mealId) async {
    try {
      List<String> favorites = await getFavorites();
      return favorites.contains(mealId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  Stream<List<String>> favoritesStream() {
    return _firestore
        .collection('favourite-meals')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        List<dynamic> mealIds = doc.data()!['mealIds'] ?? [];
        return mealIds.map((id) => id.toString()).toList();
      }
      return [];
    });
  }
}