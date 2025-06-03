import 'package:pim/model/plan_model.dart';
import 'package:pim/model/subscription_model.dart';

class CurrentPlan {
  CurrentPlan({
    required this.hasActiveSubscription,
    required this.plan,
    required this.subscription,
    required this.usage,
    required this.daysRemaining,
    required this.expiresAt,
  });

  final bool? hasActiveSubscription;
  final Plan? plan;
  final Subscription? subscription;
  final Usage? usage;
  final int? daysRemaining;
  final DateTime? expiresAt;

  factory CurrentPlan.fromJson(Map<String, dynamic> json) {
    return CurrentPlan(
      hasActiveSubscription: json["has_active_subscription"],
      plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
      subscription: json["subscription"] == null
          ? null
          : Subscription.fromJson(json["subscription"]),
      usage: json["usage"] == null ? null : Usage.fromJson(json["usage"]),
      daysRemaining: json["days_remaining"],
      expiresAt: DateTime.tryParse(json["expires_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "has_active_subscription": hasActiveSubscription,
        "plan": plan?.toJson(),
        "subscription": subscription?.toJson(),
        "usage": usage?.toJson(),
        "days_remaining": daysRemaining,
        "expires_at": expiresAt?.toIso8601String(),
      };
}

class Usage {
  Usage({
    required this.propertiesCount,
    required this.totalPropertySpacesCount,
    required this.totalPropertyImagesCount,
    required this.totalPropertySpaceImagesCount,
    required this.limitsInfo,
    required this.lastUpdated,
  });

  final int? propertiesCount;
  final int? totalPropertySpacesCount;
  final int? totalPropertyImagesCount;
  final int? totalPropertySpaceImagesCount;
  final LimitsInfo? limitsInfo;
  final DateTime? lastUpdated;

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      propertiesCount: json["properties_count"],
      totalPropertySpacesCount: json["total_property_spaces_count"],
      totalPropertyImagesCount: json["total_property_images_count"],
      totalPropertySpaceImagesCount: json["total_property_space_images_count"],
      limitsInfo: json["limits_info"] == null
          ? null
          : LimitsInfo.fromJson(json["limits_info"]),
      lastUpdated: DateTime.tryParse(json["last_updated"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "properties_count": propertiesCount,
        "total_property_spaces_count": totalPropertySpacesCount,
        "total_property_images_count": totalPropertyImagesCount,
        "total_property_space_images_count": totalPropertySpaceImagesCount,
        "limits_info": limitsInfo?.toJson(),
        "last_updated": lastUpdated?.toIso8601String(),
      };
}

class LimitsInfo {
  LimitsInfo({
    required this.planName,
    required this.properties,
    required this.propertySpacesPerProperty,
    required this.propertyImages,
    required this.propertySpaceImages,
    required this.features,
  });

  final String? planName;
  final Properties? properties;
  final PropertyLimit? propertySpacesPerProperty;
  final PropertyLimit? propertyImages;
  final PropertyLimit? propertySpaceImages;
  final Features? features;

  factory LimitsInfo.fromJson(Map<String, dynamic> json) {
    return LimitsInfo(
      planName: json["plan_name"],
      properties: json["properties"] == null
          ? null
          : Properties.fromJson(json["properties"]),
      propertySpacesPerProperty: json["property_spaces_per_property"] == null
          ? null
          : PropertyLimit.fromJson(json["property_spaces_per_property"]),
      propertyImages: json["property_images"] == null
          ? null
          : PropertyLimit.fromJson(json["property_images"]),
      propertySpaceImages: json["property_space_images"] == null
          ? null
          : PropertyLimit.fromJson(json["property_space_images"]),
      features:
          json["features"] == null ? null : Features.fromJson(json["features"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "plan_name": planName,
        "properties": properties?.toJson(),
        "property_spaces_per_property": propertySpacesPerProperty?.toJson(),
        "property_images": propertyImages?.toJson(),
        "property_space_images": propertySpaceImages?.toJson(),
        "features": features?.toJson(),
      };
}

class Features {
  Features({
    required this.sendingEmail,
    required this.occupantImage,
    required this.propertyListing,
  });

  final bool? sendingEmail;
  final bool? occupantImage;
  final bool? propertyListing;

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      sendingEmail: json["sending_email"],
      occupantImage: json["occupant_image"],
      propertyListing: json["property_listing"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sending_email": sendingEmail,
        "occupant_image": occupantImage,
        "property_listing": propertyListing,
      };
}

class Properties {
  Properties({
    required this.used,
    required this.limit,
    required this.remaining,
  });

  final int? used;
  final int? limit;
  final int? remaining;

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      used: json["used"],
      limit: json["limit"],
      remaining: json["remaining"],
    );
  }

  Map<String, dynamic> toJson() => {
        "used": used,
        "limit": limit,
        "remaining": remaining,
      };
}

class PropertyLimit {
  PropertyLimit({
    required this.limit,
  });

  final int? limit;

  factory PropertyLimit.fromJson(Map<String, dynamic> json) {
    return PropertyLimit(
      limit: json["limit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "limit": limit,
      };
}
