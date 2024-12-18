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

class AddPropertySuccessState extends PropertyState {
  AddPropertySuccessState();
}
