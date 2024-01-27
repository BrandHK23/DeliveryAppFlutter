import 'dart:convert';

BusinessAddress businessAddressFromJson(String str) =>
    BusinessAddress.fromJson(json.decode(str));

String businessAddressToJson(BusinessAddress data) =>
    json.encode(data.toJson());

class BusinessAddress {
  String id;
  String idBusiness;
  String businessAddress;
  String neighborhood;
  double lat;
  double lng;

  BusinessAddress({
    this.id,
    this.idBusiness,
    this.businessAddress,
    this.neighborhood,
    this.lat,
    this.lng,
  });

  factory BusinessAddress.fromJson(Map<String, dynamic> json) =>
      BusinessAddress(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idBusiness: json["id_business"],
        businessAddress: json["business_address"],
        neighborhood: json["neighborhood"],
        lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
        lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_business": idBusiness,
        "business_address": businessAddress,
        "neighborhood": neighborhood,
        "lat": lat,
        "lng": lng,
      };
}
