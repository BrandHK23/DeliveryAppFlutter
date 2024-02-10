import 'dart:convert';

Business businessFromJson(String str) => Business.fromJson(json.decode(str));

String businessToJson(Business data) => json.encode(data.toJson());

class Business {
  String idBusiness;
  String businessName;
  String email;
  String phone;
  String logo;
  bool isAvailable = false;
  bool isActive = false;
  String sessionToken;
  String idUser;
  List<Business> toList = [];

  Business({
    this.idBusiness,
    this.businessName,
    this.email,
    this.phone,
    this.logo,
    this.isAvailable,
    this.isActive,
    this.sessionToken,
    this.idUser,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        idBusiness: json["id_business"],
        businessName: json["business_name"],
        email: json["email"],
        phone: json["phone"],
        logo: json["logo"],
        isAvailable: json["is_available"],
        isActive: json["is_active"],
        sessionToken: json["session_token"],
        idUser: json["id_user"],
      );

  Business.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Business business = Business.fromJson(item);
      toList.add(business);
    });
  }

  Map<String, dynamic> toJson() => {
        "id_business": idBusiness,
        "business_name": businessName,
        "email": email,
        "phone": phone,
        "logo": logo,
        "is_available": isAvailable,
        "is_active": isActive,
        "session_token": sessionToken,
        "id_user": idUser,
      };
}
