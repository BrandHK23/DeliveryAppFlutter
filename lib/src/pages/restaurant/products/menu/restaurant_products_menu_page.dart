import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String _selectedCategory;

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
            return RefreshIndicator(
              onRefresh: _con.handleRefresh, // Actualizar la lista de productos
              child: FutureBuilder(
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
                              childAspectRatio: 0.73,
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
                  }),
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _createCategoryButton(),
              _deleteCategoryButton(),
            ],
          ),
        ),
      ),
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
                          Positioned(
                            top: 5,
                            // Margen superior del ícono
                            right: 5,
                            // Margen izquierdo del ícono para alinear a la esquina superior izquierda
                            child: GestureDetector(
                              onTap: () => _confirmDeleteProduct(product),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColors.redDelete,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 25, // Tamaño ajustado del ícono
                                  ),
                                ),
                              ),
                            ),
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

  Widget _deleteCategoryButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 8),
      child: TextButton.icon(
        icon: Icon(Icons.delete_forever, color: Colors.white),
        label: Text(
          "Eliminar Categoría",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: MyColors.redDelete,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        ),
        onPressed: _showDeleteConfirmationDialog,
      ),
    );
  }

  Widget _createCategoryButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 4, bottom: 8),
      child: TextButton.icon(
        icon: Icon(Icons.add, color: Colors.white), // Icono para añadir
        label: Text(
          "Crear Categoría", // Texto del botón
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          // Color de fondo para el botón de crear
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        ),
        onPressed: () {
          // Lógica para crear una nueva categoría
          // Por ejemplo: Navegar a la pantalla de creación de categorías
          _con.goToCategoryCreate();
        },
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.menu,
          size: 24, // Tamaño del icono
          color: Colors.black, // Color del icono
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
              decoration: BoxDecoration(color: MyColors.irisBlue),
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

  void _confirmDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Producto"),
          content: Text("¿Estás seguro de querer eliminar este producto?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Eliminar"),
              onPressed: () {
                _con.deleteProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Categoría"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Selecciona la categoría a eliminar:"),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: Text("Selecciona una categoría"),
                    items: _con.categories
                        .map<DropdownMenuItem<String>>((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () async {
                if (_selectedCategory != null) {
                  // Confirmar antes de eliminar
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Estás seguro?"),
                        content: Text("Esta acción no se puede deshacer."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancelar"),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text("Eliminar"),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete) {
                    bool result = await _con.deleteCategory(_selectedCategory);
                    if (result) {
                      // Mostrar algún mensaje de éxito
                      Fluttertoast.showToast(msg: "Categoría eliminada");
                      // Actualizar la lista de categorías si es necesario
                      _con.getCategories();
                    } else {
                      // Mostrar mensaje de error
                      Fluttertoast.showToast(
                          msg: "Error al eliminar la categoría");
                    }
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
