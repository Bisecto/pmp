import 'package:pim/model/property_model.dart';
import 'package:pim/model/space_model.dart';

class PropertiesModel {
  int totalProperties;
  int totalTenants;
  int totalAvailableSpaces;
  int totalSpaces;

  List<Property> properties;

  //List<Space> spaces;

  PropertiesModel({
    required this.totalProperties,
    required this.totalTenants,
    required this.totalAvailableSpaces,
    required this.totalSpaces,
    required this.properties,
    //required this.spaces,
  });

  factory PropertiesModel.fromJson(Map<String, dynamic> json) =>
      PropertiesModel(
        totalProperties: json["total_properties"],
        totalTenants: json["total_tenants"],
        totalAvailableSpaces: json["total_available_spaces"],
        totalSpaces: json["total_spaces"],
        properties: List<Property>.from(
            json["properties"].map((x) => Property.fromJson(x))),
        //spaces: List<Space>.from(json["spaces"].map((x) => Space.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_properties": totalProperties,
        "total_tenants": totalTenants,
        "total_available_spaces": totalAvailableSpaces,
        "total_spaces": totalSpaces,
        "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
        //"spaces": List<dynamic>.from(spaces.map((x) => x.toJson())),
      };
}
