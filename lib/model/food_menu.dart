class FoodMenu {
  String? id;
  String? img;
  String? name;
  String? dsc;
  double? price;
  int? rate;
  String? country;
  late int quantity;

  FoodMenu(
      {this.id,
      this.img,
      this.name,
      this.dsc,
      this.price,
      this.rate,
      this.country,
      this.quantity = 1});

  FoodMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    name = json['name'];
    dsc = json['dsc'];
    price = json['price']?.toDouble();
    rate = json['rate'];
    country = json['country'];
    quantity = json['quantity'] ?? 1;
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
    return data;
  }
}
