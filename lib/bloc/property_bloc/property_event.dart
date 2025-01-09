part of 'property_bloc.dart';

@immutable
sealed class PropertyEvent {}

class GetPropertyEvent extends PropertyEvent {
  GetPropertyEvent();
}

class GetSinglePropertyEvent extends PropertyEvent {
  final String propertyId;

  GetSinglePropertyEvent(this.propertyId);
}

class DeletePropertyEvent extends PropertyEvent {
  final String propertyId;

  DeletePropertyEvent(this.propertyId);
}

class DeleteOccupantEvent extends PropertyEvent {
  final String occupantId;

  DeleteOccupantEvent(this.occupantId);
}

class AddOccupantEvent extends PropertyEvent {
  final Map<String, String> formData;
  final XFile image;
  final String propertyId;

  AddOccupantEvent(this.formData, this.image, this.propertyId);
}

class UpdateOccupantEvent extends PropertyEvent {
  final Map<String, String> formData;
  final XFile image;
  final String propertyId;
  final String occupantId;

  UpdateOccupantEvent(
      this.formData, this.image, this.propertyId, this.occupantId);
}

class AddPropertyEvent extends PropertyEvent {
  final String propertyName;
  final String propertyType;
  final String availableFlatsRooms;
  final String address;
  final String city;
  final String description;
  final String location;
  final List<XFile> propertyImages;
  final String priceType;
  final String? price;
  final String? priceRangeStart;
  final String? priceRangeStop;

  AddPropertyEvent(
    this.propertyName,
    this.propertyType,
    this.availableFlatsRooms,
    this.address,
    this.city,
    this.description,
    this.location,
    this.propertyImages,
    this.priceType,
    this.price,
    this.priceRangeStart,
    this.priceRangeStop,
  );
}

class UpdatePropertyEvent extends PropertyEvent {
  final String propertyName;
  final String propertyType;
  final String availableFlatsRooms;
  final String address;
  final String city;
  final String description;
  final String location;
  final List<XFile> propertyImages;
  final String priceType;
  final String? price;
  final String? priceRangeStart;
  final String? priceRangeStop;
  final String propertyId;
  final bool isToggled;

  UpdatePropertyEvent(
      this.propertyName,
      this.propertyType,
      this.availableFlatsRooms,
      this.address,
      this.city,
      this.description,
      this.location,
      this.propertyImages,
      this.priceType,
      this.price,
      this.priceRangeStart,
      this.priceRangeStop,
      this.propertyId,
      this.isToggled);
}
