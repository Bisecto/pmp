part of 'property_bloc.dart';

@immutable
sealed class PropertyState {}

final class PropertyInitial extends PropertyState {}

class PropertyLoadingState extends PropertyState {}

class PropertyErrorState extends PropertyState {
  final String error;

  PropertyErrorState(this.error);
}

class PropertySuccessState extends PropertyState {
  final PropertiesModel propertiesModel;

  PropertySuccessState(this.propertiesModel);
}

class SinglePropertySuccessState extends PropertyState {
  final Property property;

  SinglePropertySuccessState(this.property);
}

class SingleOccupantSuccessState extends PropertyState {
  final Occupant occupant;

  SingleOccupantSuccessState(this.occupant);
}

class SingleSpaceSuccessState extends PropertyState {
  final Space space;

  SingleSpaceSuccessState(this.space);
}

class DeletePropertySuccessState extends PropertyState {
  DeletePropertySuccessState();
}

class DeleteSpaceSuccessState extends PropertyState {
  DeleteSpaceSuccessState();
}

class AddPropertySuccessState extends PropertyState {
  AddPropertySuccessState();
}
