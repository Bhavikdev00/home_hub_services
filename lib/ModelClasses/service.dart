import 'dart:convert';

class Service {
  final List<String> images;
  final String CategoryName;
  final String address;
  final int price;
  final String name;
  final String description;
  final String service_ids;
  Service({
    required this.CategoryName,
    required this.service_ids,
    required this.images,
    required this.address,
    required this.price,
    required this.name,
    required this.description,
  });

  // Factory method to create a Service object from a map
  factory Service.fromMap(Map<String, dynamic> map) {
    print(map);
    return Service(
      CategoryName: map['CategoryName'] ?? "",
      images: List<String>.from(map['images']) ?? [],
      address: map['address'] ?? "",
      price: map['price'] ?? "",
      name: map['servicesName'] ?? "",
      description: map['description'] ?? "",
      service_ids: map['service_id: '] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "images": jsonEncode(this.images),
      "CategoryName": this.CategoryName,
      "address": this.address,
      "price": this.price,
      "servicesName": this.name,
      "description": this.description,
      "service_id": this.service_ids,
    };
  }
}