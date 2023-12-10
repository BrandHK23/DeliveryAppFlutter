import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/pages/client/products/detail/client_product_detail_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class ClientProductDetailPage extends StatefulWidget {
  Product product;

  ClientProductDetailPage({Key key, @required this.product}) : super(key: key);

  @override
  State<ClientProductDetailPage> createState() =>
      _ClientProductDetailPageState();
}

class _ClientProductDetailPageState extends State<ClientProductDetailPage> {
  ClientProductsDetailController _con = new ClientProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.89,
      child: Column(
        children: [
          _imageSlideShow(),
          _textName(),
          _textDescription(),
          Spacer(),
          _addOrRemoveItem(),
          _standartDelivery(),
          _buttonSoppingBag(),
        ],
      ),
    );
  }

  Widget _buttonSoppingBag() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.addToBag,
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
                    'Agregar a la bolsa',
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
                    margin: EdgeInsets.only(left: 20, top: 7),
                    height: 30,
                    child:
                        Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  ))
            ],
          )),
    );
  }

  Widget _standartDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.delivery_dining),
          SizedBox(width: 10),
          Text('Envío estándar', style: TextStyle(color: Colors.green)),
          Spacer(),
        ],
      ),
    );
  }

  Widget _addOrRemoveItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: _con.removeItem,
          ),
          Text('${_con.counter}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              )),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: _con.addItem,
          ),
          Spacer(),
          Container(
              margin: EdgeInsets.only(right: 20),
              child: Text(
                '\$${_con.productPrice ?? 0.0}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Text(
        _con.product?.description ?? '',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        _con.product?.name ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _imageSlideShow() {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      initialPage: 0,
      indicatorColor: MyColors.primaryColor,
      indicatorBackgroundColor: Colors.grey,
      children: [
        FadeInImage(
          image: _con.product?.image1 != null
              ? NetworkImage(_con.product.image1)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.cover, //fill o cover según el diseño
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
        FadeInImage(
          image: _con.product?.image2 != null
              ? NetworkImage(_con.product.image2)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.cover, //fill o cover según el diseño
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
        FadeInImage(
          image: _con.product?.image3 != null
              ? NetworkImage(_con.product.image3)
              : AssetImage('assets/img/no-image.png'),
          fit: BoxFit.cover, //fill o cover según el diseño
          fadeInDuration: Duration(milliseconds: 50),
          placeholder: AssetImage('assets/img/no-image.png'),
        ),
      ],
      onPageChanged: (value) {
        print('Page changed: $value');
      },
      autoPlayInterval: 8000,
    );
  }

  void refresh() {
    setState(() {});
  }
}
