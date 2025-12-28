class Apartment {
  final int id;
  final String name;
  final double price;
  final String image;
  final int rooms;
  final String governorate;
  final String city;

  String? description;
  String? location;
  List<String>? gallery;
  String? ownerPhone;
  String? status;

  Apartment({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rooms,
    required this.governorate,
    required this.city,
    this.description,
    this.location,
    this.gallery,
    this.ownerPhone,
    this.status,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    // تحويل السعر من String أو num إلى double
    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // تحويل الغرف من String أو num إلى int
    int parseRooms(dynamic value) {
      if (value == null) return 1;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 1;
      return 1;
    }

    return Apartment(
      id: json['id'] ?? 0,
      name: json['title'] ?? json['name'] ?? '',
      price: parsePrice(json['price_per_day'] ?? json['price']),
      image: json['main_image'] ?? json['image'] ?? '',
      rooms: parseRooms(json['rooms']),
      governorate: json['governorate']?['name'] ?? json['governorate'] ?? '',
      city: json['city']?['name'] ?? json['city'] ?? '',
      description: json['description'],
      location: json['location'],
      ownerPhone: json['owner']?['phone'] ?? json['owner_phone'],
      status: json['status'],
      gallery: json['images'] != null
          ? List<String>.from(json['images'].map((img) => img['url'] ?? img['image_path'] ?? img))
          : null,
    );
  }
}