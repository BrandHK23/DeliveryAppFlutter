import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:iris_delivery_app_stable/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class ClientPaymentStatusPage extends StatefulWidget {
  const ClientPaymentStatusPage({Key key}) : super(key: key);

  @override
  State<ClientPaymentStatusPage> createState() =>
      _ClientPaymentStatusPageState();
}

class _ClientPaymentStatusPageState extends State<ClientPaymentStatusPage> {
  ClientPaymentStatusController _con = ClientPaymentStatusController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, () {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _clipPathOval(),
        _textCardDetail(),
        _textCardStatus(),
      ]),
      bottomNavigationBar: Container(
        height: 100,
        child: _buttonNext(),
      ),
    );
  }

  Widget _textCardDetail() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: _con.mercadoPagoPayment?.status == 'approved'
          ? Text(
              'Detalles de la tarjeta ( ${_con.mercadoPagoPayment?.paymentMethodId?.toUpperCase() ?? ''} **** ${_con.mercadoPagoPayment?.card?.lastFourDigits ?? ''})',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            )
          : Text(
              'Detalles de la tarjeta',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _textCardStatus() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: _con.mercadoPagoPayment?.status == 'approved'
          ? Text(
              'Mira el estado de tu compra en la sección "Mis pedidos"',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            )
          : Text(
              _con.errorMessage ?? '',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: MyColors.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              _con.mercadoPagoPayment.status == 'approved'
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 160,
                    )
                  : Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 160,
                    ),
              Text(
                _con.mercadoPagoPayment.status == 'approved'
                    ? 'Pago aprobado'
                    : 'Pago rechazado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.finishShopping,
          style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
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
                    'Finalizar compra',
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
                    margin: EdgeInsets.only(left: 40),
                    height: 30,
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 30),
                  ))
            ],
          )),
    );
  }

  void refresh() {
    setState(() {});
  }
}
