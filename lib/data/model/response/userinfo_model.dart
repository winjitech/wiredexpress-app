import 'package:wired_express/data/model/response/user_subscription_model.dart';

class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  int? updateVersion;
  int? approved;
  bool? hasActiveSubscription;
  String? purchasesPoints;
  int? scheduledDelivery;
  int? bulkOrderDiscounts;
  int? exclusiveDiscounts;
  int? freeDelivery;
  int? nearbyElectricians;
  int? productsEarlyAccess;
  String? subscriptionExpireDate;
  int? priorityBulkOrderFulfillment;
  UserSubscriptionPlanModel? userSubscription;

  UserInfoModel({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.cmFirebaseToken,
    this.updateVersion,
    this.approved,
    this.hasActiveSubscription,
    this.purchasesPoints,
    this.scheduledDelivery,
    this.bulkOrderDiscounts,
    this.exclusiveDiscounts,
    this.freeDelivery,
    this.nearbyElectricians,
    this.productsEarlyAccess,
    this.subscriptionExpireDate,
    this.priorityBulkOrderFulfillment,
    this.userSubscription,
  });

  UserInfoModel.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    updateVersion = json['update_version'];
    approved = json['approved'];
    hasActiveSubscription = json['has_active_subscription'];
    purchasesPoints = json['purchases_points'] == null
        ? "0.0"
        : json['purchases_points'].toString();
    scheduledDelivery = json['scheduled_delivery'];
    bulkOrderDiscounts = json['bulk_order_discounts'];
    exclusiveDiscounts = json['exclusive_discounts'];
    freeDelivery = json['free_delivery'];
    nearbyElectricians = json['nearby_electricians'];
    productsEarlyAccess = json['products_early_access'];
    subscriptionExpireDate = json['subscription_expire_date'];
    priorityBulkOrderFulfillment = json['priority_bulk_order_fulfillment'];

    userSubscription = json['user_subscription'] != null
        ? UserSubscriptionPlanModel.fromJson(json['user_subscription'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['is_phone_verified'] = isPhoneVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['update_version'] = updateVersion;
    data['approved'] = approved;
    data['has_active_subscription'] = hasActiveSubscription;
    data['purchases_points'] = purchasesPoints;
    data['scheduled_delivery'] = scheduledDelivery;
    data['bulk_order_discounts'] = bulkOrderDiscounts;
    data['exclusive_discounts'] = exclusiveDiscounts;
    data['free_delivery'] = freeDelivery;
    data['nearby_electricians'] = nearbyElectricians;
    data['products_early_access'] = productsEarlyAccess;
    data['subscription_expire_date'] = subscriptionExpireDate;
    data['priority_bulk_order_fulfillment'] = priorityBulkOrderFulfillment;

    if (userSubscription != null) {
      data['user_subscription'] = userSubscription?.toJson();
    }
    return data;
  }
}
