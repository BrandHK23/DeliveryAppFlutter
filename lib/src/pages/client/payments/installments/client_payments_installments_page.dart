import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_installment.dart';
import 'package:iris_delivery_app_stable/src/pages/client/payments/installments/client_payments_installments_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class ClientPaymentInstallmentsPage extends StatefulWidget {
  const ClientPaymentInstallmentsPage({Key key}) : super(key: key);

  @override
  State<ClientPaymentInstallmentsPage> createState() =>
      _ClientPaymentInstallmentsPageState();
}

class _ClientPaymentInstallmentsPageState
    extends State<ClientPaymentInstallmentsPage> {
  ClientPaymentInstallmentsController _con =
      ClientPaymentInstallmentsController();

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
        title: Text('Cuotas'),
      ),
      body: Column(children: [
        _textDescription(),
        _dropDownInstallments(),
      ]),
      bottomNavigationBar: Container(
        height: 140,
        child: Column(
          children: [
            _textTotalPrice(),
            _buttonNext(),
          ],
        ),
      ),
    );
  }

  Widget _dropDownInstallments() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: 'Cuotas',
            labelStyle: TextStyle(color: MyColors.primaryColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.primaryColor),
            ),
          ),
          style: TextStyle(color: MyColors.primaryColor),
          value: _con.selectedInstallment,
          items: _dropDownItems(_con.installmentList),
          onChanged: (opt) {
            setState(() {
              _con.selectedInstallment = opt;
            });
          }),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoInstallment> installmentsList) {
    List<DropdownMenuItem<String>> list = [];
    installmentsList.forEach((installment) {
      list.add(DropdownMenuItem(
        child: Container(
          child: Text('${installment.installments}'),
        ),
        value: '${installment.installments}',
      ));
    });
    return list;
  }

  Widget _textDescription() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          'Selecciona el número de cuotas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total a pagar: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            ' ${_con.totalPayment}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.createPay,
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
                    'Confirmar Pago',
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
