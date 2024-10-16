import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/food_category.dart';
import 'menu.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Example category data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Category')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          FoodCategory category = categories[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => MenuPage(category: category));
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                      child: Icon(
                    Icons.food_bank,
                    size: 50,
                  )),
                  // Expanded(
                  //   child: Image.asset(
                  //     category.imagePath,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
