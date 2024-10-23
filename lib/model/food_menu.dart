import 'package:hive/hive.dart';

part 'food_menu.g.dart';

@HiveType(typeId: 2)
class FoodMenu {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? img;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? dsc;

  @HiveField(4)
  double? price;

  @HiveField(5)
  int? rate;

  @HiveField(6)
  String? country;

  @HiveField(7)
  late int quantity;

  @HiveField(8)
  late int isPrepared;

  FoodMenu({
    this.id,
    this.img,
    this.name,
    this.dsc,
    this.price,
    this.rate,
    this.country,
    this.quantity = 1,
    this.isPrepared = 1,
  });

  // Optional: JSON serialization/deserialization
  FoodMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    name = json['name'];
    dsc = json['dsc'];
    price = json['price']?.toDouble();
    rate = json['rate'];
    country = json['country'];
    quantity = 1;
    isPrepared = 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    data['name'] = name;
    data['dsc'] = dsc;
    data['price'] = price;
    data['rate'] = rate;
    data['country'] = country;
    data['quantity'] = quantity;
    data['is_prepared'] = isPrepared;
    return data;
  }

  FoodMenu copyWith({
    String? id,
    String? img,
    String? name,
    String? dsc,
    double? price,
    int? rate,
    String? country,
    int? quantity,
    int? isPrepared,
  }) {
    return FoodMenu(
      id: id ?? this.id,
      img: img ?? this.img,
      name: name ?? this.name,
      dsc: dsc ?? this.dsc,
      price: price ?? this.price,
      rate: rate ?? this.rate,
      country: country ?? this.country,
      quantity: quantity ?? this.quantity,
      isPrepared: isPrepared ?? this.isPrepared,
    );
  }
}
