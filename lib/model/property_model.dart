import 'package:pim/model/space_model.dart';

class Property {
  int id;
  String propertyName;
  String address;
  String location;
  String city;
  String description;
  String propertyType;
  dynamic price;
  String priceType;
  dynamic priceRangeStart;
  dynamic priceRangeStop;
  int availableFlatsRooms;
  dynamic occupiedFlatsRooms;
  String status;
  bool advertise;
  List<Occupant> occupants;
  List<Space> spaces;

  String firstImage;
  List<ImageUrl> imageUrls;

  Property({
    required this.id,
    required this.propertyName,
    required this.address,
    required this.location,
    required this.city,
    required this.description,
    required this.propertyType,
    required this.price,
    required this.priceType,
    required this.priceRangeStart,
    required this.priceRangeStop,
    required this.availableFlatsRooms,
    required this.occupiedFlatsRooms,
    required this.status,
    required this.advertise,
    required this.occupants,
    required this.firstImage,
    required this.imageUrls,
    required this.spaces,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        propertyName: json["property_name"] ?? '',
        address: json["address"] ?? '',
        location: json["location"] ?? '',
        city: json["city"] ?? '',
        description: json["description"] ?? '',
        propertyType: json["property_type"] ?? '',
        price: json["price"] ?? 0,
        priceType: json["price_type"] ?? 'Static',
        priceRangeStart: json["price_range_start"] ?? 0,
        priceRangeStop: json["price_range_stop"] ?? 0,
        availableFlatsRooms: json["available_flats_rooms"] ?? 0,
        occupiedFlatsRooms: json["occupied_flats_rooms"] ?? 0,
        status: json["status"] ?? '',
        advertise: json["advertise"] ?? false,
        occupants: (json["occupants"] as List<dynamic>?)
                ?.map((x) => Occupant.fromJson(x))
                .toList() ??
            [],
        firstImage: json["first_image"] ?? '',
        imageUrls: (json["image_urls"] as List<dynamic>?)
                ?.map((x) => ImageUrl.fromJson(x))
                .toList() ??
            [],
        spaces: (json["spaces"] as List<dynamic>?)
                ?.map((x) => Space.fromJson(x))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "property_name": propertyName,
        "address": address,
        "location": location,
        "city": city,
        "description": description,
        "property_type": propertyType,
        "price": price,
        "price_type": priceType,
        "price_range_start": priceRangeStart,
        "price_range_stop": priceRangeStop,
        "available_flats_rooms": availableFlatsRooms,
        "occupied_flats_rooms": occupiedFlatsRooms,
        "status": status,
        "advertise": advertise,
        "occupants": List<dynamic>.from(occupants.map((x) => x.toJson())),
        "spaces": List<dynamic>.from(spaces.map((x) => x.toJson())),
        "first_image": firstImage,
        "image_urls": List<dynamic>.from(imageUrls.map((x) => x.toJson())),
      };
}

class Occupant {
  final String id;
  final String fullName;
  final String email;
  final String apartmentType;
  final String roomNumber;
  final String mobilePhone;
  final String rentExpirationDate;
  final String rentDueDeadlineCountdown;
  final String profilePic;
  final String title;
  final String dob;
  final String state;
  final String localGovernment;
  final String country;
  final String rentCommencementDate;
  final String rentTimeline;
  final String rentPaid;
  final String meshBillPaid;
  final String occupationStatus;
  final String relationship;
  final String gender;
  final String paymentStatus;

  Occupant({
    required this.id,
    required this.fullName,
    required this.email,
    required this.apartmentType,
    required this.roomNumber,
    required this.mobilePhone,
    required this.rentExpirationDate,
    required this.rentDueDeadlineCountdown,
    required this.profilePic,
    required this.title,
    required this.dob,
    required this.state,
    required this.localGovernment,
    required this.country,
    required this.rentCommencementDate,
    required this.rentTimeline,
    required this.rentPaid,
    required this.meshBillPaid,
    required this.occupationStatus,
    required this.relationship,
    required this.gender,
    required this.paymentStatus,
  });

  // Factory for deserializing from JSON
  factory Occupant.fromJson(Map<String, dynamic> json) {
    return Occupant(
      id: json['id'].toString(),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      apartmentType: json['apartment_type'] ?? 'a',
      roomNumber: json['space_number'].toString() ?? '',
      mobilePhone: json['mobile_phone'] ?? '',
      rentExpirationDate: json['rent_expiration_date'] ?? '',
      rentDueDeadlineCountdown: json['rent_due_deadline_countdown'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      title: json['title'] ?? '',
      dob: json['dob'] ?? '',
      state: json['state'] ?? '',
      localGovernment: json['local_government'] ?? '',
      country: json['country'] ?? '',
      rentCommencementDate: json['rent_commencement_date'] ?? '',
      rentTimeline: json['rent_timeline'] ?? '',
      rentPaid: json['rent_paid'] ?? '',
      meshBillPaid: json['mesh_bill_paid'] ?? '',
      occupationStatus: json['occupation_status'] ?? '',
      relationship: json['relationship'] ?? '',
      gender: json['gender'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  // Method for serializing to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'apartment_type': apartmentType,
      'space_number': roomNumber,
      'mobile_phone': mobilePhone,
      'rent_expiration_date': rentExpirationDate,
      'rent_due_deadline_countdown': rentDueDeadlineCountdown,
      'profile_pic': profilePic,
      'title': title,
      'dob': dob,
      'state': state,
      'local_government': localGovernment,
      'country': country,
      'rent_commencement_date': rentCommencementDate,
      'rent_timeline': rentTimeline,
      'rent_paid': rentPaid,
      'mesh_bill_paid': meshBillPaid,
      'occupation_status': occupationStatus,
      'relationship': relationship,
      'gender': gender,
      'payment_status': paymentStatus,
    };
  }
}

class ImageUrl {
  int id;
  String url;

  ImageUrl({
    required this.id,
    required this.url,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
