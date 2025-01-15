import 'package:pim/model/property_model.dart';

class Space {
  final int id;
  final String spaceNumber;
  final String spaceType;
  final bool isOccupied;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String? propertyName; // New field
  final String? occupantName; // New field (nullable)
  final bool advertise; // New field

  Space({
    required this.id,
    required this.spaceNumber,
    required this.spaceType,
    required this.isOccupied,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.propertyName,
    this.occupantName,
    required this.advertise,
  });

  // Factory constructor for JSON serialization
  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'] ?? 0,
      spaceNumber: json['space_number'] ?? '',
      spaceType: json['space_type'] ?? '',
      isOccupied: json['is_occupied'] ?? false,
      description: json['description'] ?? '',
      price: double.parse(json['price']),
      imageUrls: (json["added_images"] as List<dynamic>?)
          ?.map((x) => x as String)
          .toList() ??
          [],
      propertyName: json['property_name'] ?? '',
      occupantName: json['occupant_name'] ?? 'No occupant added yet',
      advertise: json['advertise'] ?? false,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'space_number': spaceNumber,
      'space_type': spaceType,
      'is_occupied': isOccupied,
      'description': description,
      'price': price,
      //"image_urls": List<dynamic>.from(imageUrls.map((x) => x.toJson())),
      'property_name': propertyName,
      'occupant_name': occupantName,
      'advertise': advertise,
    };
  }
}
