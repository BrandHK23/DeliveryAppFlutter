import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({Key key}) : super(key: key);

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {
  ClientOrdersCreateController _con = new ClientOrdersCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Orden'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(children: [
          Divider(
            color: Colors.grey[400],
            endIndent: 30,
            indent: 30,
          ),
          _textTotalPrice(),
          _buttonNext(),
        ]),
      ),
      body: _con.selectedProducts.length > 0
          ? ListView(
              children: _con.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList(),
            )
          : NoDataWidget(
              text: 'No hay productos',
            ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? '',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              _addOrRemoveItem(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.goToAddress,
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
                  height: 50,
                  child: Text(
                    'Confirmar orden',
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
                    margin: EdgeInsets.only(left: 40, top: 8),
                    height: 30,
                    child:
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                  ))
            ],
          )),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total: ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          Text('\$ ${_con.total}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        icon: Icon(Icons.delete, color: Colors.red[400], size: 30),
        onPressed: () {
          _con.deleteItem(product);
        });
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '${product?.price * product?.quantity ?? 0}',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[600]),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
        width: 90,
        height: 90,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200],
        ),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.contain,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ));
  }

  Widget _addOrRemoveItem(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _con.removeItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Colors.grey[200]),
            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Text('${product?.quantity ?? 0}'),
        ),
        GestureDetector(
          onTap: () {
            _con.addItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.grey[200]),
            child: Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
