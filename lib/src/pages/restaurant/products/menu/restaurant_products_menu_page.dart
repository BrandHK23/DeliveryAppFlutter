import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/products/menu/restaurant_products_menu_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

class RestaurantProductsMenuPage extends StatefulWidget {
  const RestaurantProductsMenuPage({Key key}) : super(key: key);

  @override
  State<RestaurantProductsMenuPage> createState() =>
      _RestaurantProductsMenuPageState();
}

class _RestaurantProductsMenuPageState
    extends State<RestaurantProductsMenuPage> {
  RestaurantProductMenuController _con = new RestaurantProductMenuController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _con.init(context, refresh); // Inicializar el controlador
      await _con.loadBusinessData(); // Cargar los datos del negocio
      refresh(); // Actualizar la UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length ?? 0,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: Column(
                children: [
                  SizedBox(height: 55),
                  _menuDrawer(),
                  SizedBox(height: 20),
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
          drawer: _drawer(),
          body: TabBarView(
            children: _con.categories.map((Category category) {
              return FutureBuilder(
                  future:
                      _con.getProducts(category.id, _con.business.idBusiness),
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
      onTap: () {},
      child: Container(
        height: 250,
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 150,
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(20),
                      child: FadeInImage(
                        image: product.image1 != null
                            ? NetworkImage(product.image1)
                            : AssetImage('assets/img/no-image.png'),
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: Text(
                        product.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NimbusSans',
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        '\$ ${product.price ?? ''}',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NimbusSans',
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: MyColors.primaryColor),
              child: Column(
                children: [
                  Text(
                    '${_con.business?.businessName ?? ''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    _con.business?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Text(
                    _con.business?.phone ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _con.business?.logo != null
                          ? NetworkImage(_con.user?.image)
                          : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ],
              )),
          ListTile(
            onTap: _con.goToOrders,
            title: Text('Ordenes'),
            trailing: Icon(Icons.list, color: Colors.blue),
          ),
          Divider(
            color: MyColors.primaryColor,
          ),
          ListTile(
            onTap: _con.goToCategoryCreate,
            title: Text('Crear categoría'),
            trailing: Icon(Icons.category, color: Colors.purple),
          ),
          Divider(
            color: MyColors.primaryColor,
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear producto'),
            trailing: Icon(Icons.fastfood, color: Colors.orange),
          ),
          Divider(
            color: MyColors.primaryColor,
          ),
          _con.user != null
              ? _con.user.roles.length > 1
                  ? ListTile(
                      onTap: _con.goToRoles,
                      title: Text('Cambiar Rol'),
                      trailing:
                          Icon(Icons.person, color: MyColors.primaryColorLight),
                    )
                  : Container()
              : Container(),
          Divider(
            color: MyColors.primaryColor,
          ),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new, color: Colors.red),
          ),
          Divider(
            color: MyColors.primaryColor,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
