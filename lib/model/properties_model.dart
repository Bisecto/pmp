

import 'package:pim/model/property_model.dart';

class PropertiesModel {
  int totalProperties;
  int totalTenants;
  int totalAvailableSpaces;
  List<Property> properties;

  PropertiesModel({
    required this.totalProperties,
    required this.totalTenants,
    required this.totalAvailableSpaces,
    required this.properties,
  });

  factory PropertiesModel.fromJson(Map<String, dynamic> json) => PropertiesModel(
    totalProperties: json["total_properties"],
    totalTenants: json["total_tenants"],
    totalAvailableSpaces: json["total_available_spaces"],
    properties: List<Property>.from(json["properties"].map((x) => Property.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_properties": totalProperties,
    "total_tenants": totalTenants,
    "total_available_spaces": totalAvailableSpaces,
    "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
  };
}

