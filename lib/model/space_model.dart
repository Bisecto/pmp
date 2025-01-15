class Space {
  final int id;
  final String spaceNumber;
  final String spaceType;
  final bool isOccupied;
  final String description;
  final double price;

  Space({
    required this.id,
    required this.spaceNumber,
    required this.spaceType,
    required this.isOccupied,
    required this.description,
    required this.price,
  });

  // Factory constructor for JSON serialization
  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'] as int,
      spaceNumber: json['space_number'] as String,
      spaceType: json['space_type'] as String,
      isOccupied: json['is_occupied'] as bool,
      description: json['description'] as String,
      price: double.parse(json['price']),
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
    };
  }
}
