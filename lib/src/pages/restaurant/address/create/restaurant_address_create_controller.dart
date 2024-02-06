import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iris_delivery_app_stable/src/models/business_address.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/address/map/restaurant_address_map_page.dart';
import 'package:iris_delivery_app_stable/src/provider/business_address_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestaurantAddressCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController idBusinessController = new TextEditingController();
  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();

  Map<String, dynamic> refPoint;

  BusinessAddressProviders _businessAddressProvider =
      new BusinessAddressProviders();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _businessAddressProvider.init(context, user);
  }

  void createBusinessAddress() async {
    String address = addressController.text.trim();
    String neighborhood = neighborhoodController.text.trim();
    String idBusiness = idBusinessController.text.trim();
    double lat = refPoint['lat'] ?? 0;
    double lng = refPoint['lng'] ?? 0;

    if (address.isEmpty || neighborhood.isEmpty) {
      Fluttertoast.showToast(msg: 'Todos los campos son obligatorios');
      return;
    }

    BusinessAddress businessAddress = new BusinessAddress(
      businessAddress: address,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng,
      idBusiness: idBusiness,
    );

    ResponseApi responseApi =
        await _businessAddressProvider.create(businessAddress);
    if (responseApi.success) {
      print("Ubicación seleccionada: $refPoint");
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pushNamedAndRemoveUntil(
          context, 'restaurant/orders/list', (route) => false);
    } else {
      Fluttertoast.showToast(msg: responseApi.message ?? "Error en el proceso");
    }
  }

  void openMap(BuildContext context) async {
    refPoint = await showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) => RestaurantAddressMapPage());

    if (refPoint != null) {
      refPointController.text = refPoint['address'];
      // Imprime la ubicación seleccionada
      print("Ubicación seleccionada: ${refPoint['address']}");
      refresh();
    }
  }
}
