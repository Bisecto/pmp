import 'package:pim/model/space_model.dart';

import 'occupation_status_model.dart';

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
  int totalSpace;
  int occupiedSpace;
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
    required this.totalSpace,
    required this.occupiedSpace,
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
        totalSpace: json["total_space"] ?? 0,
        occupiedSpace: json["occupied_space"] ?? 0,
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
        "total_space": totalSpace,
        "occupied_space": occupiedSpace,
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
  final String dob;
  final String title;
  final String gender;
  final String state;
  final String localGovernment;
  final String spaceNumber;
  final String mobilePhone;
  final String email;
  final String rentTimeline;
  final String rentCommencementDate;
  final String rentExpirationDate;
  final String rentDueDeadlineCountdown;
  final String rentPaid;
  final String paymentStatus;
  final String meshBillPaid;
  final String occupationStatus;
  final String relationship;
  final String profilePic;
  final String country;
  final String spaceType;
  final int propertySpace;
  final PropertySpaceDetails? propertySpaceDetails;
  final String qrCodeImage;
  final SelfEmployedProfile? selfEmployedProfile;
  final EmployedProfile? employedProfile;
  final StudentProfile? studentProfile;

  Occupant({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.title,
    required this.gender,
    required this.state,
    required this.localGovernment,
    required this.spaceNumber,
    required this.mobilePhone,
    required this.email,
    required this.rentTimeline,
    required this.rentCommencementDate,
    required this.rentExpirationDate,
    required this.rentDueDeadlineCountdown,
    required this.rentPaid,
    required this.paymentStatus,
    required this.meshBillPaid,
    required this.occupationStatus,
    required this.relationship,
    required this.profilePic,
    required this.country,
    required this.spaceType,
    required this.propertySpace,
    this.propertySpaceDetails,
    required this.qrCodeImage,
    this.selfEmployedProfile,
    this.employedProfile,
    this.studentProfile,
  });

  factory Occupant.fromJson(Map<String, dynamic> json) {
    return Occupant(
      id: json['id'].toString() ?? '',
      fullName: json['full_name'] ?? '',
      dob: json['dob'] ?? '',
      title: json['title'] ?? '',
      gender: json['gender'] ?? '',
      state: json['state'] ?? '',
      localGovernment: json['local_government'] ?? '',
      spaceNumber: json['space_number'] ?? '',
      mobilePhone: json['mobile_phone'] ?? '',
      email: json['email'] ?? '',
      rentTimeline: json['rent_timeline'] ?? '',
      rentCommencementDate: json['rent_commencement_date'] ?? '',
      rentExpirationDate: json['rent_expiration_date'] ?? '',
      rentDueDeadlineCountdown: json['rent_due_deadline_countdown'] ?? '',
      rentPaid: json['rent_paid'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      meshBillPaid: json['mesh_bill_paid'] ?? '',
      occupationStatus: json['occupation_status'] ?? '',
      relationship: json['relationship'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      country: json['country'] ?? '',
      spaceType: json['space_type'] ?? '',
      propertySpace: json['property_space'] ?? 0,
      propertySpaceDetails: json['property_space_details'] != null
          ? PropertySpaceDetails.fromJson(json['property_space_details'])
          : null,
      qrCodeImage: json['qr_code_image'] ?? '',
      selfEmployedProfile: json['self_employed_profile'] != null
          ? SelfEmployedProfile.fromJson(json['self_employed_profile'])
          : null,
      employedProfile: json['employed_profile'] != null
          ? EmployedProfile.fromJson(json['employed_profile'])
          : null,
      studentProfile: json['student_profile'] != null
          ? StudentProfile.fromJson(json['student_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'dob': dob,
      'title': title,
      'gender': gender,
      'state': state,
      'local_government': localGovernment,
      'space_number': spaceNumber,
      'mobile_phone': mobilePhone,
      'email': email,
      'rent_timeline': rentTimeline,
      'rent_commencement_date': rentCommencementDate,
      'rent_expiration_date': rentExpirationDate,
      'rent_due_deadline_countdown': rentDueDeadlineCountdown,
      'rent_paid': rentPaid,
      'payment_status': paymentStatus,
      'mesh_bill_paid': meshBillPaid,
      'occupation_status': occupationStatus,
      'relationship': relationship,
      'profile_pic': profilePic,
      'country': country,
      'space_type': spaceType,
      'property_space': propertySpace,
      'property_space_details': propertySpaceDetails?.toJson(),
      'qr_code_image': qrCodeImage,
      'self_employed_profile': selfEmployedProfile?.toJson(),
      'employed_profile': employedProfile?.toJson(),
      'student_profile': studentProfile?.toJson(),
    };
  }
}

class PropertySpaceDetails {
  final String spaceNumber;
  final String spaceType;
  final double price;
  final bool isOccupied;

  PropertySpaceDetails({
    required this.spaceNumber,
    required this.spaceType,
    required this.price,
    required this.isOccupied,
  });

  factory PropertySpaceDetails.fromJson(Map<String, dynamic> json) {
    return PropertySpaceDetails(
      spaceNumber: json['space_number'] ?? '',
      spaceType: json['space_type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isOccupied: json['is_occupied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'space_number': spaceNumber,
      'space_type': spaceType,
      'price': price,
      'is_occupied': isOccupied,
    };
  }
}

class SelfEmployedProfile {
  final String natureOfJob;
  final String jobDescription;

  SelfEmployedProfile({
    required this.natureOfJob,
    required this.jobDescription,
  });

  factory SelfEmployedProfile.fromJson(Map<String, dynamic> json) {
    return SelfEmployedProfile(
      natureOfJob: json['nature_of_job'] ?? '',
      jobDescription: json['job_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nature_of_job': natureOfJob,
      'job_description': jobDescription,
    };
  }
}

class EmployedProfile {
  final String organisation;
  final String position;
  final String employerContact;
  final String organisationLocation;

  EmployedProfile({
    required this.organisation,
    required this.position,
    required this.employerContact,
    required this.organisationLocation,
  });

  factory EmployedProfile.fromJson(Map<String, dynamic> json) {
    return EmployedProfile(
      organisation: json['organisation'] ?? '',
      position: json['position'] ?? '',
      employerContact: json['employer_contact'] ?? '',
      organisationLocation: json['organisation_location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisation': organisation,
      'position': position,
      'employer_contact': employerContact,
      'organisation_location': organisationLocation,
    };
  }
}

class StudentProfile {
  final String university;
  final String studentId;
  final String department;
  final String courseOfStudy;

  StudentProfile({
    required this.university,
    required this.studentId,
    required this.department,
    required this.courseOfStudy,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      university: json['university'] ?? '',
      studentId: json['student_id'] ?? '',
      department: json['department'] ?? '',
      courseOfStudy: json['course_of_study'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'university': university,
      'student_id': studentId,
      'department': department,
      'course_of_study': courseOfStudy,
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
