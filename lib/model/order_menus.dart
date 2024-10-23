import 'package:hive/hive.dart';

part 'order_menus.g.dart';

@HiveType(typeId: 7)
class OrderMenus {
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
  late int? quantity;

  @HiveField(8)
  late int isPrepared;

  @HiveField(10)
  String? orderTrackId;

  OrderMenus({
    this.id,
    this.img,
    this.name,
    this.dsc,
    this.price,
    this.rate,
    this.country,
    this.quantity = 1,
    this.isPrepared = 1,
    this.orderTrackId,
  });

  // Optional: JSON serialization/deserialization
  OrderMenus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    name = json['name'];
    dsc = json['dsc'];
    price = json['price']?.toDouble();
    rate = json['rate'];
    country = json['country'];
    quantity = 1;
    isPrepared = 1;
    orderTrackId = "";
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
    data['order_track_id'] = orderTrackId;
    return data;
  }

  // copyWith method for creating a modified instance of OrderMenus
  OrderMenus copyWith({
    String? id,
    String? img,
    String? name,
    String? dsc,
    double? price,
    int? rate,
    String? country,
    int? quantity,
    int? isPrepared,
    String? orderTrackId,
  }) {
    return OrderMenus(
      id: id ?? this.id,
      img: img ?? this.img,
      name: name ?? this.name,
      dsc: dsc ?? this.dsc,
      price: price ?? this.price,
      rate: rate ?? this.rate,
      country: country ?? this.country,
      quantity: quantity ?? this.quantity,
      isPrepared: isPrepared ?? this.isPrepared,
      orderTrackId: orderTrackId ?? this.orderTrackId,
    );
  }
}
