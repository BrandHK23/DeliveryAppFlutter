import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

import 'client_restaurant_list_controller.dart';

class ClientRestaurantListPage extends StatefulWidget {
  const ClientRestaurantListPage({Key key}) : super(key: key);

  @override
  State<ClientRestaurantListPage> createState() =>
      _ClientRestaurantListPageState();
}

class _ClientRestaurantListPageState extends State<ClientRestaurantListPage> {
  ClientRestaurantListController _con = new ClientRestaurantListController();

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
              _menuDrawer(),
              SizedBox(height: 20),
              _textFiledSearch(),
            ],
          ),
        ),
      ),
      drawer: _drawer(),
      body: FutureBuilder(
        future: _con.getBusinessAvailable(),
        builder: (context, AsyncSnapshot<List<Business>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return _cardBusiness(snapshot.data[index]);
                },
              );
            } else {
              return NoDataWidget(text: 'No hay negocios disponibles');
            }
          } else {
            return NoDataWidget(text: 'No hay negocios disponibles');
          }
        },
      ),
    );
  }

  Widget _cardBusiness(Business business) {
    return GestureDetector(
      onTap: () {
        // Lógica al hacer tap si es necesaria
      },
      child: Container(
        height: 200, // Altura total del contenedor
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                FadeInImage(
                  // Usamos FadeInImage para una carga elegante
                  placeholder: AssetImage('assets/img/no-image.png'),
                  image: business.logo != null
                      ? NetworkImage(business.logo)
                      : AssetImage('assets/img/no-image.png'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.businessName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "25-30 min",
                        // Tiempo de preparación estático, puede ser dinámico
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          "4.5", // Calificación estática, puede ser dinámica
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.menu,
          // Usa el icono de menú incluido en los iconos de material design
          size: 24, // Tamaño del icono, ajusta según necesites
          color:
              Colors.black, // Color del icono, ajusta según el tema de tu app
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
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.phone ?? '',
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
                      image: _con.user?.image != null
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
            onTap: _con.goToUpdatePage,
            title: Text('Editar Perfil'),
            trailing:
                Icon(Icons.edit, color: MyColors.primaryColor.withOpacity(0.8)),
          ),
          Divider(
            color: MyColors.primaryColor.withOpacity(0.8),
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart, color: Colors.orange),
          ),
          Divider(
            color: MyColors.primaryColor.withOpacity(0.8),
          ),
          _con.user != null
              ? _con.user.roles.length > 1
                  ? ListTile(
                      onTap: _con.goToRoles,
                      title: Text('Cambiar Rol'),
                      trailing:
                          Icon(Icons.person, color: MyColors.primaryColorDark),
                    )
                  : Container()
              : Container(),
          Divider(
            color: MyColors.primaryColor.withOpacity(0.8),
          ),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new, color: Colors.redAccent),
          ),
          Divider(
            color: MyColors.primaryColor.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
