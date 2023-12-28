import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:iris_delivery_app_stable/src/models/address.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_card_token.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_document_type.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_installment.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_issuer.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_payment.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_payment_method_installments.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/mercado_pago_provider.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientPaymentInstallmentsController {
  BuildContext context;
  Function refresh;

  List<MercadoPagoDocumentType> documentTypeList = [];
  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  MercadoPagoCardToken cardToken;
  List<Product> selectedProducts = [];
  double totalPayment = 0;

  MercadoPagoPaymentMethodInstallments installments;
  List<MercadoPagoInstallment> installmentList = [];
  MercadoPagoIssuer issuer;
  MercadoPagoPayment creditCardPayment;

  String selectedInstallment;

  Address address;

  ProgressDialog progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      cardToken = MercadoPagoCardToken.fromJsonMap(arguments['card_token']);
      print('Card Token arguments: ${cardToken?.toJson()}');
    } else {
      print('Error: Argumentos de CardToken son null');
    }

    progressDialog = ProgressDialog(context: context);

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order'))?.toList ?? [];
    user = User.fromJson(await _sharedPref.read('user'));
    address = Address.fromJson(await _sharedPref.read('address'));

    _mercadoPagoProvider.init(context, user);
    getTotalPayment();
    getInstallments();
  }

  void getInstallments() async {
    installments = await _mercadoPagoProvider.getInstallments(
        cardToken.firstSixDigits, totalPayment);
    print('Installments: ${installments.toJson()}');
    installmentList = installments.payerCosts;
    issuer = installments.issuer;

    refresh();
  }

  void getTotalPayment() {
    selectedProducts.forEach((product) {
      totalPayment += product.price * product.quantity;
    });
    refresh();
  }

  void createPay() async {
    if (selectedInstallment == null) {
      Fluttertoast.showToast(
          msg: 'Selecciona el número de cuotas',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    Order order = new Order(
      idAddress: address.id,
      idClient: user.id,
      products: selectedProducts,
    );

    progressDialog.show(max: 100, msg: 'Procesando pago...');

    Response response = await _mercadoPagoProvider.createPayment(
      cardId: cardToken.cardId,
      transactionAmount: totalPayment,
      installments: int.parse(selectedInstallment),
      paymentMethodId: installments.paymentMethodId,
      paymentTypeId: installments.paymentTypeId,
      issuerId: installments.issuer.id,
      emailCustomer: user.email,
      cardToken: cardToken.id,
      order: order,
    );

    progressDialog.close();

    if (response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        print('Pago realizado con éxito: ${response.body}');

        creditCardPayment = MercadoPagoPayment.fromJsonMap(data);
        Navigator.pushNamedAndRemoveUntil(
            context, 'client/payments/status', (route) => false,
            arguments: creditCardPayment.toJson());
        print('Credit Card Payment: ${creditCardPayment.toJson()}');
      } catch (e) {
        print('Error al decodificar la respuesta: $e');
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      final data = json.decode(response.body);
      if (data != null && data.containsKey('err')) {
        if (data['err']['status'] == 400) {
          badRequestProcess(data);
        } else {
          badTokenProcess(data['status'], installments);
        }
      } else {
        print('Error desconocido: ${response.body}');
      }
    }
  }

  ///SI SE RECIBE UN STATUS 400
  void badRequestProcess(dynamic data) {
    Map<String, String> paymentErrorCodeMap = {
      '3034': 'Informacion de la tarjeta invalida',
      '205': 'Ingresa el número de tu tarjeta',
      '208': 'Digita un mes de expiración',
      '209': 'Digita un año de expiración',
      '212': 'Ingresa tu documento',
      '213': 'Ingresa tu documento',
      '214': 'Ingresa tu documento',
      '220': 'Ingresa tu banco emisor',
      '221': 'Ingresa el nombre y apellido',
      '224': 'Ingresa el código de seguridad',
      'E301': 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302': 'Revisa el código de seguridad',
      '316': 'Ingresa un nombre válido',
      '322': 'Revisa tu documento',
      '323': 'Revisa tu documento',
      '324': 'Revisa tu documento',
      '325': 'Revisa la fecha',
      '326': 'Revisa la fecha'
    };
    String errorMessage;
    print('CODIGO ERROR ${data['err']['cause'][0]['code']}');

    if (paymentErrorCodeMap.containsKey('${data['err']['cause'][0]['code']}')) {
      print('ENTRO IF');
      errorMessage = paymentErrorCodeMap['${data['err']['cause'][0]['code']}'];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.pop(context);
  }

  void badTokenProcess(
      String status, MercadoPagoPaymentMethodInstallments installments) {
    Map<String, String> badTokenErrorCodeMap = {
      '106': 'No puedes realizar pagos a usuarios de otros paises.',
      '109':
          '${installments.paymentMethodId} no procesa pagos en ${selectedInstallment} cuotas',
      '126': 'No pudimos procesar tu pago.',
      '129':
          '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145': 'No pudimos procesar tu pago',
      '150': 'No puedes realizar pagos',
      '151': 'No puedes realizar pagos',
      '160': 'No pudimos procesar tu pago',
      '204':
          '${installments.paymentMethodId} no está disponible en este momento.',
      '801':
          'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
    };
    String errorMessage;
    if (badTokenErrorCodeMap.containsKey(status.toString())) {
      errorMessage = badTokenErrorCodeMap[status];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0); // Navigator.pop(context);
  }
}
