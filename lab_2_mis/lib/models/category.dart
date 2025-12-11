class MealCategory {
  int id;
  String name;
  String thumbnail;
  String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  MealCategory.fromJson(Map<String, dynamic> jsonData)
    : id = int.parse(jsonData["idCategory"]),
      name = jsonData["strCategory"],
      thumbnail = jsonData["strCategoryThumb"],
      description = jsonData["strCategoryDescription"];

  Map<String, dynamic> toJson() => {
    "idCategory": id,
    "strCategory": name,
    "strCategoryThumb": thumbnail,
    "strCategoryDescription": description,
  };
}
