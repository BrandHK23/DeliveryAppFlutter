import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/utils/relative_time_util.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

class RestaurantOrdersDetailPage extends StatefulWidget {
  Order order;

  RestaurantOrdersDetailPage({Key key, @required this.order}) : super(key: key);

  @override
  State<RestaurantOrdersDetailPage> createState() =>
      _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState
    extends State<RestaurantOrdersDetailPage> {
  RestaurantOrdersDetailController _con =
      new RestaurantOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si _con.order y _con.order.client no son null antes de construir el widget
    if (_con.order == null || _con.order.client == null) {
      // Retorna un widget alternativo o muestra un mensaje de error
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalles de la Orden'),
        ),
        body: Center(child: Text('Orden o cliente no disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Orden: ${_con.order?.id ?? ''}'),
        backgroundColor: MyColors.primaryColor,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          // Envolver con SingleChildScrollView
          child: Column(children: [
            Divider(color: Colors.grey[400], endIndent: 30, indent: 30),
            _textDescription(),
            _dropDown(_con.users),
            SizedBox(height: 5),
            _textData('Cliente: ',
                '${_con.order.client.name ?? ''} ${_con.order.client.lastname ?? ''}'),
            SizedBox(height: 5),
            _textData('Dirección de entrega: ',
                '${_con.order.address.address ?? ''}'),
            SizedBox(height: 5),
            _textData('Fecha de creación: ',
                '${RelativeTimeUtil.getRelativeTime(_con.order.timestamp ?? 0)}'),
            Divider(color: Colors.grey[400], endIndent: 30, indent: 30),
            _textTotalPrice(),
            _buttonNext(),
          ]),
        ),
      ),
      body: _con.order.products.length > 0
          ? ListView(
              children: _con.order.products.map((Product product) {
                return _cardProduct(product);
              }).toList(),
            )
          : NoDataWidget(
              text: 'No hay productos',
            ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Asignar repartidor',
        style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          color: MyColors.primaryColor,
        ),
      ),
    );
  }

  Widget _dropDown(List<User> users) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delivery_dining,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccione un repartidor',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownItems(users),
                  value: _con.idDelivery,
                  onChanged: (option) {
                    setState(() {
                      print('Repartidor asigando: $option');
                      _con.idDelivery = option;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(20),
                child: FadeInImage(
                  image: user.image != null
                      ? NetworkImage(user.image)
                      : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 50),
                  placeholder: AssetImage('assets/img/no-image.png'),
                )),
            Text(user.name)
          ],
        ),
        value: user.id,
      ));
    });

    return list;
  }

  Widget _textData(String title, String content) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            content,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ));
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
              Text(
                'Cantidad: ${product?.quantity ?? ''}',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          Spacer(),
          Text(
            '\$ ${product?.price * product?.quantity ?? ''}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: ElevatedButton(
          onPressed: () {},
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
                    'Listo para recoger',
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

  Widget _imageProduct(Product product) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[200],
      ),
      child: FadeInImage(
        image: (product.image1 != null && product.image1.isNotEmpty)
            ? NetworkImage(product.image1)
            : AssetImage('assets/img/no-image.png'),
        placeholder: AssetImage('assets/img/no-image.png'),
        // Imagen de carga
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        // Si la imagen principal falla, muestra una imagen de reserva
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/img/no-image.png', fit: BoxFit.contain);
        },
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
