import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  ClientProductListController _con = new ClientProductListController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Business business =
          ModalRoute.of(context).settings.arguments as Business;
      // Aquí, pasas el objeto 'business' al controlador
      _con.init(context, business, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(170),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [_shoppingBag()],
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 55),
                  _back(),
                  SizedBox(height: 20),
                  _textFiledSearch(),
                ],
              ),
              bottom: TabBar(
                indicatorColor: MyColors.primaryColorLight,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.categories.length, (index) {
                  return Tab(
                    child: Text(_con.categories[index].name ?? ''),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: _con.categories.map((Category category) {
              return FutureBuilder(
                  future: _con.getProducts(category.id, _con.productName),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardProduct(snapshot.data[index]);
                            });
                      } else {
                        return NoDataWidget(text: 'No hay productos');
                      }
                    } else {
                      return NoDataWidget(text: 'No hay productos');
                    }
                  });
            }).toList(),
          )),
    );
  }

  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250, // Altura total del contenedor
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    // Margen alrededor de la imagen
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      // Bordes redondeados de la imagen
                      child: Stack(
                        children: [
                          FadeInImage(
                            height: 110,
                            // Altura ajustada de la imagen
                            width: MediaQuery.of(context).size.width * 0.5 - 20,
                            // Ancho ajustado con margen
                            image: product.image1 != null
                                ? NetworkImage(product.image1)
                                : AssetImage('assets/img/no-image.png'),
                            fit: BoxFit.cover,
                            fadeInDuration: Duration(milliseconds: 50),
                            placeholder: AssetImage('assets/img/no-image.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      product.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'NimbusSans',
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      '\$ ${product.price ?? ''}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'NimbusSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrdersCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 15),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          Positioned(
            right: 22,
            top: 15,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30)),
            ),
          )
        ],
      ),
    );
  }

  Widget _textFiledSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: _con.onChangeText,
        decoration: InputDecoration(
            hintText: 'Buscar',
            suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
            hintStyle: TextStyle(fontSize: 17, color: Colors.grey[500]),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey[300])),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey[300])),
            contentPadding: EdgeInsets.all(15)),
      ),
    );
  }

  Widget _back() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios, color: Colors.black),
            Text('Volver', style: TextStyle(color: Colors.black, fontSize: 17))
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
