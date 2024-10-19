import 'package:hive/hive.dart';

part 'food_category.g.dart';

@HiveType(typeId: 4) // Choose a unique typeId for this class
class FoodCategory {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imagePath;

  FoodCategory({required this.name, required this.imagePath});

  // Factory constructor to create FoodCategory from JSON
  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }

  // Convert FoodCategory to JSON
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
