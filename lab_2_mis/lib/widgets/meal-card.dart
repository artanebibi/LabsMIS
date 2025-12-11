import 'package:flutter/material.dart';
import 'package:lab_2_mis/service/api-service.dart';
import '../models/meal.dart';
import '../service/favourites-service.dart';

class MealCard extends StatefulWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late final ApiService _apiService = ApiService();
  late final FavoritesService _favService = FavoritesService(_apiService);
  bool isFavorited = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    try {
      String mealId = widget.meal.id.toString();
      bool result = await _favService.isFavorite(mealId);
      setState(() {
        isFavorited = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error checking favorite: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      String mealId = widget.meal.id.toString();

      if (isFavorited) {
        await _favService.removeFavorite(mealId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed from favorites'), duration: Duration(seconds: 1)),
          );
        }
      } else {
        await _favService.addFavorite(mealId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to favorites'), duration: Duration(seconds: 1)),
          );
        }
      }

      setState(() {
        isFavorited = !isFavorited;
        _checkFavorite();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      print('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/mealDetails", arguments: widget.meal);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Flexible(
                child: Image.network(
                  widget.meal.thumbnail,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              Text(
                widget.meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}