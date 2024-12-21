class Property {
  int id;
  String propertyName;
  String address;
  String location;
  String city;
  String description;
  String propertyType;
  String price;
  String priceType;
  dynamic priceRangeStart;
  dynamic priceRangeStop;
  int availableFlatsRooms;
  dynamic occupiedFlatsRooms;
  String status;
  List<Occupant> occupants;
  String firstImage;
  List<String> images;

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
    required this.occupants,
    required this.firstImage,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        id: json["id"],
        propertyName: json["property_name"],
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
    occupants: List<Occupant>.from(json["occupants"]?.map((x) => Occupant.fromJson(x)) ?? []),
        firstImage: json["first_image"]??'',
        images: List<String>.from(json["images"] ?? [].map((x) => x)),
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
        "occupants": List<dynamic>.from(occupants.map((x) => x.toJson())),
        "first_image": firstImage,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}

class Occupant {
  String id;
  String name;
  String dob;
  String mobileNumber;
  String gender;
  String state;
  String localGovernment;
  int roomNumber;
  String rentDueDate;
  String rentCommencementDate;
  String rentPaid;
  String meshBillPaid;
  String occupationStatus;
  String relationship;
  String profilePic;
  String country;

  Occupant({
    required this.id,
    required this.name,
    required this.dob,
    required this.mobileNumber,
    required this.gender,
    required this.state,
    required this.localGovernment,
    required this.roomNumber,
    required this.rentDueDate,
    required this.rentCommencementDate,
    required this.rentPaid,
    required this.meshBillPaid,
    required this.occupationStatus,
    required this.relationship,
    required this.profilePic,
    required this.country,
  });

  factory Occupant.fromJson(Map<String, dynamic> json) => Occupant(
        id: json["id"].toString(),
        name: json["name"],
        dob: json["dob"]??'',
        mobileNumber: json["mobile_phone"]??'',
        gender: json["gender"]??'',
        state: json["state"]??'',
        localGovernment: json["local_government"]??'',
        roomNumber: json["room_number"]??0,
        rentDueDate: json["rent_expiration_date"]??'',
        rentCommencementDate: json["rent_commencement_date"]??'',
        rentPaid: json["rent_paid"]??'',
        meshBillPaid: json["mesh_bill_paid"]??'',
        occupationStatus: json["occupation_status"]??'',
        relationship: json["relationship"]??'',
        profilePic: json["profile_pic"]??'',
        country: json["country"]??'',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dob": dob!,
        "mobile_phone": mobileNumber,
        "gender": gender,
        "state": state,
        "local_government": localGovernment,
        "room_number": roomNumber,
        "rent_expiration_date": rentDueDate!,
        "rent_commencement_date": rentCommencementDate!,
        "rent_paid": rentPaid,
        "mesh_bill_paid": meshBillPaid,
        "occupation_status": occupationStatus,
        "relationship": relationship,
        "profile_pic": profilePic,
        "country": country,
      };
}
