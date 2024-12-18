class Property {
  int id;
  String propertyName;
  String location;
  String city;
  String propertyType;
  String price;
  int availableFlatsRooms;
  dynamic occupiedFlatsRooms;
  String firstImage;

  Property({
    required this.id,
    required this.propertyName,
    required this.location,
    required this.city,
    required this.propertyType,
    required this.price,
    required this.availableFlatsRooms,
    required this.occupiedFlatsRooms,
    required this.firstImage,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    id: json["id"],
    propertyName: json["property_name"],
    location: json["location"],
    city: json["city"],
    propertyType: json["property_type"],
    price: json["price"],
    availableFlatsRooms: json["available_flats_rooms"],
    occupiedFlatsRooms: json["occupied_flats_rooms"],
    firstImage: json["first_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_name": propertyName,
    "location": location,
    "city": city,
    "property_type": propertyType,
    "price": price,
    "available_flats_rooms": availableFlatsRooms,
    "occupied_flats_rooms": occupiedFlatsRooms,
    "first_image": firstImage,
  };
}
