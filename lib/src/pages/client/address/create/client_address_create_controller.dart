import 'package:flutter/cupertino.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/map/client_address_map_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  BuildContext context;
  Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  void openMap() {
    showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage());
  }
}
