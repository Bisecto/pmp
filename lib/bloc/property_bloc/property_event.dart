part of 'property_bloc.dart';

@immutable
sealed class PropertyEvent {}

class GetPropertyEvent extends PropertyEvent {
  GetPropertyEvent();
}

class AddPropertyEvent extends PropertyEvent {
  final String propertyName;
  final String propertyType;
  final String availableFlatsRooms;
  final String occupiedRooms;
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
      this.priceRangeStop, this.occupiedRooms);
}
