class Plan {
  Plan({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.maxProperties,
    required this.maxPropertySpacesPerProperty,
    required this.maxImagesPerProperty,
    required this.maxImagesPerPropertySpace,
    required this.sendingEmailEnabled,
    required this.occupantImageEnabled,
    required this.propertyListingEnabled,
  });

  final int? id;
  final String? name;
  final String? displayName;
  final String? description;
  final String? price;
  final int? durationDays;
  final int? maxProperties;
  final int? maxPropertySpacesPerProperty;
  final int? maxImagesPerProperty;
  final int? maxImagesPerPropertySpace;
  final bool? sendingEmailEnabled;
  final bool? occupantImageEnabled;
  final bool? propertyListingEnabled;

  factory Plan.fromJson(Map<String, dynamic> json){
    return Plan(
      id: json["id"],
      name: json["name"],
      displayName: json["display_name"],
      description: json["description"],
      price: json["price"],
      durationDays: json["duration_days"],
      maxProperties: json["max_properties"],
      maxPropertySpacesPerProperty: json["max_property_spaces_per_property"],
      maxImagesPerProperty: json["max_images_per_property"],
      maxImagesPerPropertySpace: json["max_images_per_property_space"],
      sendingEmailEnabled: json["sending_email_enabled"],
      occupantImageEnabled: json["occupant_image_enabled"],
      propertyListingEnabled: json["property_listing_enabled"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "display_name": displayName,
    "description": description,
    "price": price,
    "duration_days": durationDays,
    "max_properties": maxProperties,
    "max_property_spaces_per_property": maxPropertySpacesPerProperty,
    "max_images_per_property": maxImagesPerProperty,
    "max_images_per_property_space": maxImagesPerPropertySpace,
    "sending_email_enabled": sendingEmailEnabled,
    "occupant_image_enabled": occupantImageEnabled,
    "property_listing_enabled": propertyListingEnabled,
  };

}
