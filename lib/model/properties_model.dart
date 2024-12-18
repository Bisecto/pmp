

import 'package:pim/model/property_model.dart';

class PropertiesModel {
  int totalProperties;
  int totalTenants;
  int totalAvailableRooms;
  int totalOccupiedRooms;
  List<Property> properties;

  PropertiesModel({
    required this.totalProperties,
    required this.totalTenants,
    required this.totalAvailableRooms,
    required this.totalOccupiedRooms,
    required this.properties,
  });

  factory PropertiesModel.fromJson(Map<String, dynamic> json) => PropertiesModel(
    totalProperties: json["total_properties"],
    totalTenants: json["total_tenants"],
    totalAvailableRooms: json["total_available_rooms"],
    totalOccupiedRooms: json["total_occupied_rooms"],
    properties: List<Property>.from(json["properties"].map((x) => Property.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_properties": totalProperties,
    "total_tenants": totalTenants,
    "total_available_rooms": totalAvailableRooms,
    "total_occupied_rooms": totalOccupiedRooms,
    "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
  };
}

