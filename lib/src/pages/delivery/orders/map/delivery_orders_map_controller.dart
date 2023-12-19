import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/orders_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrdersMapController {
  BuildContext context;
  Function refresh;
  Position _position;
  StreamSubscription<Position> _positionStream;

  String addressName;
  LatLng addressLatLng;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(19.4357435, -100.3591198),
    zoom: 14,
  );

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Order order;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrdersProviders _ordersProviders = new OrdersProviders();
  User user;
  SharedPref _sharedPref = new SharedPref();

  double _distanceBetween;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    deliveryMarker =
        await createMarkerImageFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerImageFromAsset('assets/img/home.png');
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProviders.init(context, user);
    order = Order.fromJson(
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    print('Order: ${order.toJson()}');

    checkGPS();
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(_position.latitude,
        _position.longitude, order.address.lat, order.address.lng);
    print('Distancia: $_distanceBetween');
  }

  void updateToDelivered() async {
    if (_distanceBetween <= 200) {
      ResponseApi responseApi = await _ordersProviders.updateToDelivered(order);
      if (responseApi.success) {
        Fluttertoast.showToast(msg: responseApi.message);
        Navigator.pushNamedAndRemoveUntil(
            context, 'delivery/orders/list', (route) => false);
      }
    } else {
      Fluttertoast.showToast(msg: 'Aún no estás en dirección de entrega');
    }
  }

  Future<void> setPolyLines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFrom, pointTo);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: MyColors.primaryColor,
        points: points,
        width: 6);

    polylines.add(polyline);
    refresh();
  }

  void dispose() {
    _positionStream?.cancel();
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: title,
        snippet: content,
      ),
    );
    markers[id] = marker;

    refresh();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      animateCameraToPosition(_position.latitude, _position.longitude);
      addMarker('delivery', _position.latitude, _position.longitude,
          'Tu posisción', '', deliveryMarker);
      addMarker('home', order.address.lat, order.address.lng,
          'Dirección de entrega', '', homeMarker);

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(order.address.lat, order.address.lng);
      setPolyLines(from, to);

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        _position = position;
        addMarker('delivery', _position.latitude, _position.longitude,
            'Tu posisción', '', deliveryMarker);

        animateCameraToPosition(_position.latitude, _position.longitude);
        isCloseToDeliveryPosition();
        refresh();
      });
    } catch (e) {
      print('Error ' + e);
    }
  }

  void call() {
    launch('tel://${order.client.phone}');
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool result = await Geolocator.openLocationSettings();
      _getCurrentLocation();
      if (result) {
        updateLocation();
      }
    }
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 19,
          bearing: 0,
        ),
      ));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position2) {
      if (position2 != null) {
        setState(() {
          _position = position2;
          animateCameraToPosition(_position.latitude, _position.longitude);
        });
      } else {
        print('No se pudo obtener la posición actual');
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      try {
        List<Placemark> address = await placemarkFromCoordinates(lat, lng);
        if (address != null) {
          if (address.length > 0) {
            String direction = address[0].thoroughfare;
            String street = address[0].subThoroughfare;
            String city = address[0].locality;
            String department = address[0].administrativeArea;
            String country = address[0].country;

            addressName = '$direction $street, $city, $department, $country';
            addressLatLng = new LatLng(lat, lng);

            print('LAT: ${addressLatLng.latitude}');
            print('LNG: ${addressLatLng.longitude}');

            refresh();
          }
        }
      } catch (e) {
        print('Error al obtener la dirección: $e');
      }
    }
  }

  void setState(Null Function() param0) {}

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng.latitude,
      'lng': addressLatLng.longitude,
    };
    Navigator.pop(context, data);
  }
}
