import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iris_delivery_app_stable/src/models/address.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/map/client_address_map_page.dart';
import 'package:iris_delivery_app_stable/src/provider/address_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();

  Map<String, dynamic> refPoint;

  AddressProviders _addressProviders = new AddressProviders();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _addressProviders.init(context, user);
  }

  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage());
    if (refPoint != null) {
      refPointController.text = refPoint['address'];
      refresh();
    }
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = refPoint['lat'] ?? 0;
    double lng = refPoint['lng'] ?? 0;

    if (addressName.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0) {
      MyAlertDialog.show(context, 'Ingrese todos los campos');
      return;
    }

    Address address = new Address(
      address: addressName,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng,
      idUser: user.id,
    );

    ResponseApi responseApi = await _addressProviders.create(address);

    if (responseApi.success) {
      address.id = responseApi.data;
      _sharedPref.save('address', address);

      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
    } else {
      MyAlertDialog.show(context, responseApi.message);
    }
  }
}
