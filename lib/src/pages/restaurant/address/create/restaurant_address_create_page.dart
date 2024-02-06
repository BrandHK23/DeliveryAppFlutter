import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/address/create/restaurant_address_create_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class RestaurantAddressCreatePage extends StatefulWidget {
  const RestaurantAddressCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantAddressCreatePage> createState() =>
      _RestaurantAddressCreatePageState();
}

class _RestaurantAddressCreatePageState
    extends State<RestaurantAddressCreatePage> {
  RestaurantAddressCreateController _conAddress =
      new RestaurantAddressCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _conAddress.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              _idNegocio(),
              _addressField(),
              _neighborhoodField(),
              _pointOnMap(),
              _buttonRegister(),
              _buttonBack(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _idNegocio() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _conAddress.idBusinessController,
        decoration: InputDecoration(
            hintText: 'ID del negocio',
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _addressField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _conAddress.addressController,
        decoration: InputDecoration(
            hintText: 'Calle',
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.map,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _neighborhoodField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _conAddress.neighborhoodController,
        decoration: InputDecoration(
            hintText: 'Colonia',
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.map,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _pointOnMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _conAddress.refPointController,
        onTap: () => openMap(context),
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
            hintText: 'Ubicación en el mapa',
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.location_on,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  void openMap(BuildContext context) {
    _conAddress.openMap(context);
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _conAddress.createBusinessAddress,
        child: Text('Agregar dirección',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _buttonBack() {
    return Container(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
        },
        child: Text(
          'Cancelar',
          //Set text Color red
          style: TextStyle(color: Colors.red, fontSize: 19),
        ),
        style:
            TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
