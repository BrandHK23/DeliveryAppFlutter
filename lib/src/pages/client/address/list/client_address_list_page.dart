import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key key}) : super(key: key);

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  ClientAddressListController _con = new ClientAddressListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
    _con.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis direcciones'),
        actions: [
          _iconAdd(),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _textSelectAddress(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: NoDataWidget(
                text: 'No hay direcciones registradas',
              ),
            ),
            _buttonNewAddress(),
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _buttonNewAddress() {
    return Container(
        height: 40,
        child: ElevatedButton(
          onPressed: _con.goToNewAddress,
          child: Text('Nueva Dirección'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
        ));
  }

  Widget _buttonAccept() {
    return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Aceptar'),
          style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ));
  }

  Widget _textSelectAddress() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Text('Selecciona una dirección',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _iconAdd() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: _con.goToNewAddress,
    );
  }

  void refresh() {
    setState(() {});
  }
}
