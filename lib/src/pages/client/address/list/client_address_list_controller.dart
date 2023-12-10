import 'package:flutter/cupertino.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  void goToNewAddress() {
    Navigator.pushNamed(context, 'client/address/create');
  }
}
