import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:pim/model/properties_model.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/space_model.dart';
import 'package:pim/res/apis.dart';

import '../../model/property_model.dart';
import '../../repository/repository.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'property_event.dart';

part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyBloc() : super(PropertyInitial()) {
    on<GetSinglePropertyEvent>(getSinglePropertyEvent);
    on<GetSingleOccupantEvent>(getSingleOccupantEvent);
    on<GetSingleSpaceEvent>(getSingleSpaceEvent);
    on<GetSinglePropertyOccupantsEvent>(getSinglePropertyOccupantsEvent);
    on<DeletePropertyEvent>(deletePropertyEvent);
    on<DeleteSpaceEvent>(deleteSpaceEvent);
    //on<DeleteOccupantEvent>(deleteOccupantEvent);
    on<GetPropertyEvent>(getPropertyEvent);
    on<AddPropertyEvent>(addPropertyEvent);
    on<UpdatePropertyEvent>(updatePropertyEvent);
    on<AddOccupantEvent>(addOccupantEvent);
    on<UpdateOccupantEvent>(updateOccupantEvent);
    on<UpdateSpaceEvent>(updateSpaceEvent);
    //on<AddSpaceEvent>(addSpaceEvent);
    // on<PropertyEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> getPropertyEvent(
      GetPropertyEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      var listPropertyResponse = await appRepository.getRequestWithToken(
          accessToken, AppApis.propertiesListApi);
      // var res = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
      //   accessToken: accessToken,
      // );
      //print(res.body);
      print(" status Code ${listPropertyResponse.statusCode}");
      print(" Data ${listPropertyResponse.body}");
      print(json.decode(listPropertyResponse.body));
      if (listPropertyResponse.statusCode == 200 ||
          listPropertyResponse.statusCode == 201) {
        PropertiesModel propertiesModel =
            PropertiesModel.fromJson(json.decode(listPropertyResponse.body));

        //updateData(customerProfile);
        print(propertiesModel);
        emit(PropertySuccessState(
            propertiesModel)); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(listPropertyResponse.body))));
        print(json.decode(listPropertyResponse.body));
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while fetching property."));
      print(e);
    }
  }

  FutureOr<void> addPropertyEvent(
      AddPropertyEvent event, Emitter<PropertyState> emit) async {
    emit(PropertyLoadingState());

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      Map<String, String> formData = {
        'property_name': event.propertyName,
        'property_type': event.propertyType,
        'total_space': event.availableFlatsRooms,
        // 'occupied_flats_rooms': event.occupiedRooms,
        'address': event.address,
        'city': event.city,
        'description': event.description,
        'location': event.location,
        'price_type': event.priceType,
        'price_range_stop': event.priceRangeStop!,
        'price_range_start': event.priceRangeStart!,
        'price': event.price.toString(),
      };
      print(formData);
      var addPropertyResponse =
          await appRepository.appPostRequestWithMultipleImages(
        formData,
        AppApis.addPropertyApi,
        event.propertyImages,
        accessToken,
      );

      print(" status Code ${addPropertyResponse.statusCode}");
      print(" Data ${addPropertyResponse.body}");
      print(json.decode(addPropertyResponse.body));
      if (addPropertyResponse.statusCode == 200 ||
          addPropertyResponse.statusCode == 201) {
        // PropertiesModel propertiesModel =
        //     PropertiesModel.fromJson(json.decode(listPropertyResponse.body));

        //updateData(customerProfile);
        print(addPropertyResponse);
        emit(AddPropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(addPropertyResponse.body))));
        print(json.decode(addPropertyResponse.body));
        emit(PropertyInitial());
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while adding property."));
      emit(PropertyInitial());
      print(e);
    }
  }

  FutureOr<void> getSinglePropertyEvent(
      GetSinglePropertyEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    //try {
    var singlePropertyResponse = await appRepository.getRequestWithToken(
        accessToken, AppApis.singlePropertyApi + event.propertyId);
    // var res = await appRepository.appGetRequest(
    //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
    //   accessToken: accessToken,
    // );
    //print(res.body);
    print(" status Code ${singlePropertyResponse.statusCode}");
    print(" Data ${singlePropertyResponse.body}");
    print(json.decode(singlePropertyResponse.body));
    if (singlePropertyResponse.statusCode == 200 ||
        singlePropertyResponse.statusCode == 201) {
      Property property =
          Property.fromJson(json.decode(singlePropertyResponse.body));

      print(property);
      emit(
          SinglePropertySuccessState(property)); // Emit success state with data
    } else {
      emit(PropertyErrorState(AppUtils.getAllErrorMessages(
          json.decode(singlePropertyResponse.body))));
      print(json.decode(singlePropertyResponse.body));
    }
    // } catch (e) {
    //   emit(PropertyErrorState("An error occurred while fetching property detail."));
    //   print(e);
    // }
  }

  FutureOr<void> addOccupantEvent(
      AddOccupantEvent event, Emitter<PropertyState> emit) async {
    emit(PropertyLoadingState());

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      //Map<String, String> formData = json.decode(event.occupant);
      var addPropertyResponse =
          await appRepository.appPostRequestWithSingleImages(
        event.formData,
        '${AppApis.addOccupantApi + event.selectedSpaceId}/',
        event.image,
        accessToken,
      );

      print(" status Code ${addPropertyResponse.statusCode}");
      print(" Data ${addPropertyResponse.body}");
      print(json.decode(addPropertyResponse.body));
      if (addPropertyResponse.statusCode == 200 ||
          addPropertyResponse.statusCode == 201) {
        print(addPropertyResponse);
        emit(AddPropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(addPropertyResponse.body))));
        print(json.decode(addPropertyResponse.body));
        emit(PropertyInitial());
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while adding occupant."));
      emit(PropertyInitial());
      print(e);
    }
  }

  FutureOr<void> updatePropertyEvent(
      UpdatePropertyEvent event, Emitter<PropertyState> emit) async {
    emit(PropertyLoadingState());

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      Map<String, String> formData = {
        'property_name': event.propertyName,
        'property_type': event.propertyType,
        'available_flats_rooms': event.availableFlatsRooms,
        // 'occupied_flats_rooms': event.occupiedRooms,
        'address': event.address,
        'city': event.city,
        'description': event.description,
        'location': event.location,
        'price_type': event.priceType,
        'price_range_stop': event.priceRangeStop!,
        'price_range_start': event.priceRangeStart!,
        'price': event.price.toString(),
        'advertise': event.isToggled ? "True" : "False",
      };
      var addPropertyResponse =
          await appRepository.appPutRequestWithMultipleImages(
        formData,
        '${AppApis.updatePropertyApi}${event.propertyId}/',
        event.propertyImages,
        accessToken,
      );

      print(" status Code ${addPropertyResponse.statusCode}");
      print(" Data ${addPropertyResponse.body}");
      print(json.decode(addPropertyResponse.body));
      if (addPropertyResponse.statusCode == 200 ||
          addPropertyResponse.statusCode == 201) {
        // PropertiesModel propertiesModel =
        //     PropertiesModel.fromJson(json.decode(listPropertyResponse.body));

        //updateData(customerProfile);
        print(addPropertyResponse);
        emit(AddPropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(addPropertyResponse.body))));
        print(json.decode(addPropertyResponse.body));
        emit(PropertyInitial());
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while updating property."));
      emit(PropertyInitial());
      print(e);
    }
  }

  FutureOr<void> updateOccupantEvent(
      UpdateOccupantEvent event, Emitter<PropertyState> emit) async {
    emit(PropertyLoadingState());

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      //Map<String, String> formData = json.decode(event.occupant);
      var addPropertyResponse =
          await appRepository.appPatchRequestWithSingleImages(
        event.formData,
        '${AppApis.updateOccupantApi + event.occupantId}/',
        event.image,
        accessToken,
      );

      print(" status Code ${addPropertyResponse.statusCode}");
      print(" Data ${addPropertyResponse.body}");
      print(json.decode(addPropertyResponse.body));
      if (addPropertyResponse.statusCode == 200 ||
          addPropertyResponse.statusCode == 201) {
        print(addPropertyResponse);
        emit(AddPropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(addPropertyResponse.body))));
        print(json.decode(addPropertyResponse.body));
        emit(PropertyInitial());
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while updating occupant."));
      emit(PropertyInitial());
      print(e);
    }
  }

  FutureOr<void> deletePropertyEvent(
      DeletePropertyEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      // var deletePropertyResponse = await appRepository.getRequestWithToken(
      //     accessToken, AppApis.singlePropertyApi+event.propertyId);
      var singlePropertyResponse = await appRepository.deleteRequestWithToken(
          accessToken, '${AppApis.singlePropertyApi}${event.propertyId}/');
      // var res = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
      //   accessToken: accessToken,
      // );
      //print(res.body);
      print(" status Code ${singlePropertyResponse.statusCode}");
      //print(" Data ${singlePropertyResponse.body}");
      //print(json.decode(singlePropertyResponse.body));
      if (singlePropertyResponse.statusCode == 200 ||
          singlePropertyResponse.statusCode == 204) {
        //print(property);
        emit(DeletePropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(singlePropertyResponse.body))));
        print(json.decode(singlePropertyResponse.body));
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while deleting property."));
      print(e);
    }
  }

  // FutureOr<void> deleteOccupantEvent(DeleteOccupantEvent event, Emitter<PropertyState> emit) async  {
  //   emit(
  //       PropertyLoadingState()); // Emit loading state at the start of the event
  //
  //   AppRepository appRepository = AppRepository();
  //   String accessToken = await SharedPref.getString('access-token');
  //   try {
  //     // var deletePropertyResponse = await appRepository.getRequestWithToken(
  //     //     accessToken, AppApis.singlePropertyApi+event.propertyId);
  //     var singlePropertyResponse = await appRepository.deleteRequestWithToken(
  //         accessToken, '${AppApis.singlePropertyApi}${event.propertyId}/');
  //     // var res = await appRepository.appGetRequest(
  //     //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
  //     //   accessToken: accessToken,
  //     // );
  //     //print(res.body);
  //     print(" status Code ${singlePropertyResponse.statusCode}");
  //     //print(" Data ${singlePropertyResponse.body}");
  //     print(json.decode(singlePropertyResponse.body));
  //     if (singlePropertyResponse.statusCode == 200 ||
  //         singlePropertyResponse.statusCode == 204) {
  //
  //       //print(property);
  //       emit(
  //           DeletePropertySuccessState()); // Emit success state with data
  //     } else {
  //       emit(PropertyErrorState(AppUtils.getAllErrorMessages(
  //           json.decode(singlePropertyResponse.body))));
  //       print(json.decode(singlePropertyResponse.body));
  //     }
  //   } catch (e) {
  //     emit(PropertyErrorState("An error occurred while deleting property."));
  //     print(e);
  //   }
  // }

  FutureOr<void> getSinglePropertyOccupantsEvent(
      GetSinglePropertyOccupantsEvent event,
      Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    //try {
    var singlePropertyResponse = await appRepository.getRequestWithToken(
        accessToken, AppApis.singlePropertyApi + event.propertyId);
    // var res = await appRepository.appGetRequest(
    //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
    //   accessToken: accessToken,
    // );
    //print(res.body);
    print(" status Code ${singlePropertyResponse.statusCode}");
    print(" Data ${singlePropertyResponse.body}");
    print(json.decode(singlePropertyResponse.body));
    if (singlePropertyResponse.statusCode == 200 ||
        singlePropertyResponse.statusCode == 201) {
      Property property =
          Property.fromJson(json.decode(singlePropertyResponse.body));

      print(property);
      emit(
          SinglePropertySuccessState(property)); // Emit success state with data
    } else {
      emit(PropertyErrorState(AppUtils.getAllErrorMessages(
          json.decode(singlePropertyResponse.body))));
      print(json.decode(singlePropertyResponse.body));
    }
    // } catch (e) {
    //   emit(PropertyErrorState("An error occurred while fetching property detail."));
    //   print(e);
    // }
  }

  FutureOr<void> getSingleSpaceEvent(
      GetSingleSpaceEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    //try {
    var singleSpaceResponse = await appRepository.getRequestWithToken(
        accessToken,
        "${AppApis.singleSpaceApi}${event.propertyid}/spaces/${event.spaceId}/");
    // var res = await appRepository.appGetRequest(
    //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
    //   accessToken: accessToken,
    // );
    //print(res.body);
    print(" status Code ${singleSpaceResponse.statusCode}");
    print(" Data ${singleSpaceResponse.body}");
    print(json.decode(singleSpaceResponse.body));
    if (singleSpaceResponse.statusCode == 200 ||
        singleSpaceResponse.statusCode == 201) {
      Space space = Space.fromJson(json.decode(singleSpaceResponse.body));

      print(space);
      emit(SingleSpaceSuccessState(space)); // Emit success state with data
    } else {
      emit(PropertyErrorState(
          AppUtils.getAllErrorMessages(json.decode(singleSpaceResponse.body))));
      print(json.decode(singleSpaceResponse.body));
    }
    // } catch (e) {
    //   emit(PropertyErrorState("An error occurred while fetching property detail."));
    //   print(e);
    // }
  }

  FutureOr<void> deleteSpaceEvent(
      DeleteSpaceEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      var singlePropertyResponse = await appRepository.deleteRequestWithToken(
          accessToken,
          '${AppApis.singleSpaceApi}${event.propertyId}/spaces/${event.spaceId}/');

      print(" status Code ${singlePropertyResponse.statusCode}");
      //print(" Data ${singlePropertyResponse.body}");
      print(json.decode(singlePropertyResponse.body));
      if (singlePropertyResponse.statusCode == 200 ||
          singlePropertyResponse.statusCode == 204 ||
          singlePropertyResponse.statusCode == 201) {
        //print(property);
        emit(DeleteSpaceSuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(singlePropertyResponse.body))));
        print(json.decode(singlePropertyResponse.body));
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while deleting property."));
      print(e);
    }
  }

  FutureOr<void> updateSpaceEvent(
      UpdateSpaceEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      var singlePropertyResponse =
          await appRepository.appPutRequestWithMultipleImages(
              event.formData,
              '${AppApis.singleSpaceApi}${event.propertyId}/spaces/${event.spaceId}/',
              event.images,
              accessToken);

      print(" status Code ${singlePropertyResponse.statusCode}");
      //print(" Data ${singlePropertyResponse.body}");
      print(json.decode(singlePropertyResponse.body));
      if (singlePropertyResponse.statusCode == 200 ||
          singlePropertyResponse.statusCode == 204 ||
          singlePropertyResponse.statusCode == 201) {
        //print(property);
        emit(AddPropertySuccessState()); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(singlePropertyResponse.body))));
        print(json.decode(singlePropertyResponse.body));
      }
    } catch (e) {
      emit(PropertyErrorState("An error occurred while deleting property."));
      print(e);
    }
  }

  // FutureOr<void> addSpaceEvent(AddSpaceEvent event, Emitter<PropertyState> emit) async {
  //   emit(
  //       PropertyLoadingState()); // Emit loading state at the start of the event
  //
  //   AppRepository appRepository = AppRepository();
  //   String accessToken = await SharedPref.getString('access-token');
  //   try {
  //
  //     var singlePropertyResponse = await appRepository.appPostRequestWithMultipleImages(event.formData,
  //         '${AppApis.singleSpaceApi}${event.propertyId}/spaces/${event.spaceId}/',event.images,accessToken);
  //
  //     print(" status Code ${singlePropertyResponse.statusCode}");
  //     //print(" Data ${singlePropertyResponse.body}");
  //     print(json.decode(singlePropertyResponse.body));
  //     if (singlePropertyResponse.statusCode == 200 ||
  //         singlePropertyResponse.statusCode == 204||
  //         singlePropertyResponse.statusCode == 201) {
  //       //print(property);
  //       emit(AddPropertySuccessState()); // Emit success state with data
  //     } else {
  //       emit(PropertyErrorState(AppUtils.getAllErrorMessages(
  //           json.decode(singlePropertyResponse.body))));
  //       print(json.decode(singlePropertyResponse.body));
  //     }
  //   } catch (e) {
  //     emit(PropertyErrorState("An error occurred while deleting property."));
  //     print(e);
  //   }
  // }

  FutureOr<void> getSingleOccupantEvent(
      GetSingleOccupantEvent event, Emitter<PropertyState> emit) async {
    emit(
        PropertyLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      var singleOccupantResponse = await appRepository.getRequestWithToken(
          accessToken, AppApis.singleOccupantApi + event.occupantId);
      print(" status Code ${singleOccupantResponse.statusCode}");
      print(" Data ${singleOccupantResponse.body}");
      print(json.decode(singleOccupantResponse.body));
      if (singleOccupantResponse.statusCode == 200 ||
          singleOccupantResponse.statusCode == 201) {
        Occupant occupant =
            Occupant.fromJson(json.decode(singleOccupantResponse.body));

        print(occupant);
        emit(SingleOccupantSuccessState(
            occupant)); // Emit success state with data
      } else {
        emit(PropertyErrorState(AppUtils.getAllErrorMessages(
            json.decode(singleOccupantResponse.body))));
        print(json.decode(singleOccupantResponse.body));
      }
    } catch (e) {
      emit(PropertyErrorState(
          "An error occurred while fetching property detail."));
      print(e);
    }
  }
}
