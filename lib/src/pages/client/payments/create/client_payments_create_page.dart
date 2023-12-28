import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:iris_delivery_app_stable/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class ClientPaymentCreatePage extends StatefulWidget {
  const ClientPaymentCreatePage({Key key}) : super(key: key);

  @override
  State<ClientPaymentCreatePage> createState() =>
      _ClientPaymentCreatePageState();
}

class _ClientPaymentCreatePageState extends State<ClientPaymentCreatePage> {
  ClientPaymentCreateController _con = ClientPaymentCreateController();

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
        appBar: AppBar(
          title: Text('Método de pago'),
        ),
        body: ListView(
          children: [
            CreditCardWidget(
              cardNumber: _con.cardNumber,
              expiryDate: _con.expiryDate,
              cardHolderName: _con.cardHolderName,
              cvvCode: _con.cvvCode,
              showBackView: _con.isCvvFocused,
              cardBgColor: MyColors.primaryColor,
              obscureCardNumber: true,
              obscureCardCvv: true,
              height: 175,
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              labelCardHolder: 'Nombre del titular',
            ),
            CreditCardForm(
              cvvCode: '',
              cardHolderName: '',
              cardNumber: '',
              expiryDate: '',
              formKey: _con.keyForm,
              // Required
              onCreditCardModelChange: _con.onCreditCardModelChange,
              // Required
              themeColor: Colors.red,
              obscureCvv: true,
              obscureNumber: true,
              cardNumberDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número de la tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expiración',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre del titular',
              ),
            ),
            _buttonNext(),
          ],
        ));
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.createCardToken,
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
                    'Continuar',
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
