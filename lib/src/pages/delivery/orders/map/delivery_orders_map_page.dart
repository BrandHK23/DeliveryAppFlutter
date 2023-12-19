import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

import 'delivery_orders_map_controller.dart';

class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({Key key}) : super(key: key);

  @override
  State<DeliveryOrdersMapPage> createState() => _DeliveryOrdersMapPageState();
}

class _DeliveryOrdersMapPageState extends State<DeliveryOrdersMapPage> {
  DeliveryOrdersMapController _con = new DeliveryOrdersMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
    _con.init(context, refresh);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _googleMaps()),
          SafeArea(
            child: Column(
              children: [
                _buttonCenterPosition(),
                Spacer(),
                _cardOrederInfo(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardOrederInfo() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.43,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            ]),
        child: Column(
          children: [
            _listTileAddress(
                _con.order?.address?.neighborhood, "Colonia", Icons.map),
            _listTileAddress(
                _con.order?.address?.address, "Dirección", Icons.location_on),
            Divider(
              color: Colors.grey,
              endIndent: 30,
              indent: 30,
            ),
            _clientInfo(),
            _buttonNext()
          ],
        ));
  }

  Widget _clientInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(children: [
        Container(
            height: 50,
            width: 50,
            child: FadeInImage(
              image: _con.order?.client?.image != null
                  ? NetworkImage(_con.order.client?.image)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            )),
        Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.client?.name ?? ''} ${_con.order?.client?.lastname ?? ''}',
              style: TextStyle(fontSize: 13, color: Colors.black),
              maxLines: 1,
            )),
        Container(
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: IconButton(
              onPressed: _con.call,
              icon: Icon(
                Icons.phone,
                color: Colors.white,
                size: 20,
              ),
            ))
      ]),
    );
  }

  Widget _listTileAddress(String title, String subtitle, IconData iconData) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ListTile(
          title: Text(title ?? '', style: TextStyle(fontSize: 13)),
          subtitle: Text(subtitle ?? ''),
          trailing: Icon(iconData, color: MyColors.primaryColor),
        ));
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 7.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: MyColors.primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: ElevatedButton(
          onPressed: _con.updateToDelivered,
          style: ElevatedButton.styleFrom(
            primary: MyColors.accentColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    'Entregar pedido',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 40, top: 3),
                    height: 30,
                    child:
                        Icon(Icons.check_circle, color: Colors.white, size: 30),
                  ))
            ],
          )),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }
}
