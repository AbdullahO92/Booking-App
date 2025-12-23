class Apartment {
  final int id;
  final String name;
  final double price;
  final String image;

  String? description;
  String? location;
  //int?rooms;
  final int rooms;
  List<String>? gallery;
String? ownerPhone;
 final String governorate;
  final String city;

  Apartment({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.description,
    this.location,
     required this.rooms,
    this.gallery,
    this.ownerPhone,
      required this.governorate,
    required this.city,
  });
  
}
