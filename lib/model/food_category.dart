class FoodCategory {
  String name;
  String imagePath;

  FoodCategory({required this.name, required this.imagePath});

  // This factory constructor is useful if you're getting category data from a JSON file or API
  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }

  // For converting to JSON if necessary
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
    };
  }
}

final List<FoodCategory> categories = [
  FoodCategory(name: 'bbqs', imagePath: 'assets/icons/bbq.png'),
  FoodCategory(name: 'burgers', imagePath: 'assets/icons/burger.png'),
  FoodCategory(name: 'desserts', imagePath: 'assets/icons/desserts.png'),
  FoodCategory(name: 'drinks', imagePath: 'assets/icons/drink.png'),
  FoodCategory(
      name: 'fried chickens', imagePath: 'assets/icons/fried_chicken.png'),
  FoodCategory(name: 'pizzas', imagePath: 'assets/icons/pizza.png'),
  FoodCategory(name: 'sandwiches', imagePath: 'assets/icons/sandwich.png'),
];
