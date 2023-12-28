import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_card_token.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_document_type.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/mercado_pago_provider.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class ClientPaymentCreateController {
  BuildContext context;
  Function refresh;
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController documentNumberController = new TextEditingController();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  String expirationYear;
  int expirationMonth;

  List<MercadoPagoDocumentType> documentTypeList = [];
  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  MercadoPagoCardToken cardToken;

  String typeDocument = '';

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    _mercadoPagoProvider.init(context, user);
  }

  void getIdentificationType() async {
    documentTypeList = await _mercadoPagoProvider.getIdentificationType();
    refresh();
  }

  void createCardToken() async {
    // Validación de los campos
    final fields = {
      'Número de la tarjeta': cardNumber,
      'Fecha de expiración': expiryDate,
      'Nombre del titular': cardHolderName,
      'Código de seguridad': cvvCode,
    };

    for (var field in fields.entries) {
      if (field.value.isEmpty) {
        Fluttertoast.showToast(msg: 'Ingrese ${field.key}');
        return;
      }
    }

    // Eliminar espacios en blanco en el número de la tarjeta
    cardNumber = cardNumber.replaceAll(' ', '');

    // Dividir y validar la fecha de expiración
    if (expiryDate.isNotEmpty) {
      List<String> expiryDateParts = expiryDate.split('/');
      if (expiryDateParts.length != 2) {
        Fluttertoast.showToast(msg: 'Formato de fecha de expiración inválido');
        return;
      }

      expirationMonth = int.tryParse(expiryDateParts[0]);
      int year = int.tryParse(expiryDateParts[1]);
      if (year != null) {
        expirationYear = (year < 100) ? '20$year' : year.toString();
      }

      if (expirationMonth == null || year == null || year < 0 || year > 99) {
        Fluttertoast.showToast(msg: 'Fecha de expiración inválida');
        return;
      }
    }

    // Imprime la información de la tarjeta (opcional)
    fields.forEach((key, value) => print('$key: $value'));

    try {
      Response response = await _mercadoPagoProvider.createCardToken(
        cvv: cvvCode,
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expirationMonth: expirationMonth.toString(),
        expirationYear: expirationYear,
      );

      if (response != null) {
        final data = json.decode(response.body);

        if (response.statusCode == 201) {
          cardToken = MercadoPagoCardToken.fromJsonMap(data);
          Fluttertoast.showToast(msg: 'Token creado correctamente');
          Navigator.pushNamed(context, 'client/payments/installments',
              arguments: {
                'card_token': cardToken.toJson(),
              });
        } else {
          handleError(data);
        }
      }
    } catch (e) {
      print('Error al crear el token: $e');
      Fluttertoast.showToast(msg: 'Error al crear el token');
    }
  }

  void handleError(dynamic data) {
    String message = data['message'] ?? data['error'] ?? 'Error desconocido';
    print('Error: $message');
    Fluttertoast.showToast(msg: message);
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    refresh();
  }
}
