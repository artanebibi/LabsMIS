class Ingredient {
  final String name;
  final String? measure;

  Ingredient({
    required this.name,
    this.measure,
  });

  @override
  String toString() =>
      (measure == null || measure!.trim().isEmpty) ? name : '${measure!} $name';
}

class Meal {
  // for
  final int id;
  final String name;
  final String thumbnail;

  final String? instructions;
  final List<Ingredient>? ingredients;
  final String? youtubeLink;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions,
    this.ingredients,
    this.youtubeLink,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final rawId = json['idMeal'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final List<Ingredient> parsedIngredients = [];

    for (var i = 1; i <= 20; i++) {
      final ingredientKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';

      final ingredientRaw = json[ingredientKey]?.toString().trim() ?? '';
      final measureRaw = json[measureKey]?.toString().trim();

      if (ingredientRaw.isEmpty) {
        continue;
      }

      parsedIngredients.add(
        Ingredient(
          name: ingredientRaw,
          measure: (measureRaw != null && measureRaw.isNotEmpty)
              ? measureRaw
              : null,
        ),
      );
    }

    return Meal(
      id: id,
      name: json['strMeal']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      instructions: json['strInstructions']?.toString(),
      ingredients: parsedIngredients.isEmpty ? null : parsedIngredients,
      youtubeLink: (json['strYoutube']?.toString().trim().isEmpty ?? true)
          ? null
          : json['strYoutube'].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
    };

    if (instructions != null) {
      map['strInstructions'] = instructions;
    }
    if (youtubeLink != null) {
      map['strYoutube'] = youtubeLink;
    }

    if (ingredients != null) {
      for (var i = 0; i < 20; i++) {
        final ingredientKey = 'strIngredient${i + 1}';
        final measureKey = 'strMeasure${i + 1}';

        if (i < ingredients!.length) {
          map[ingredientKey] = ingredients![i].name;
          map[measureKey] = ingredients![i].measure ?? '';
        } else {
          map[ingredientKey] = '';
          map[measureKey] = '';
        }
      }
    }

    return map;
  }
}
