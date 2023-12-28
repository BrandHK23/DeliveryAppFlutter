import 'package:flutter/cupertino.dart';
import 'package:iris_delivery_app_stable/src/models/address.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/address_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/orders_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  List<Address> address = [];
  AddressProviders _addressProviders = new AddressProviders();
  User user;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;

  bool isCreated;
  Map<String, dynamic> dataIsCreated;

  OrdersProviders _ordersProviders = new OrdersProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _addressProviders.init(context, user);
    _ordersProviders.init(context, user);

    refresh();
  }

  void handleRadioValueChange(int value) async {
    radioValue = value;
    _sharedPref.save('address', address[value]);

    refresh();
    print('Valor del radio: $radioValue');
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProviders.getByUser(user.id);
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue = index;
    }
    print('Direccion guardada: ${a.toJson()}');

    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, 'client/address/create');

    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }

  void createOrder() async {
    // Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    // List<Product> selectedProducts =
    //     Product.fromJsonList(await _sharedPref.read('order')).toList;
    //
    // Order order = new Order(
    //   idClient: user.id,
    //   idAddress: a.id,
    //   products: selectedProducts,
    // );
    // ResponseApi responseApi = await _ordersProviders.create(order);

    Navigator.pushNamed(context, 'client/payments/create');
  }
}
