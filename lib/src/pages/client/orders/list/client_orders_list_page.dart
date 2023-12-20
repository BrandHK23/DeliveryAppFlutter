import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:iris_delivery_app_stable/src/utils/relative_time_util.dart';
import 'package:iris_delivery_app_stable/src/widgets/no_data_widget.dart';

import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({Key key}) : super(key: key);

  @override
  _ClientOrdersListPageState createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage> {
  ClientOrdersListController _con = new ClientOrdersListController();

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
    return DefaultTabController(
      length: _con.status?.length,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              title: Text(
                'Mis Ordenes',
                style: TextStyle(
                    color: MyColors.accentColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NimbusSans',
                    fontSize: 20),
              ),
              // automaticallyImplyLeading: false,
              bottom: TabBar(
                indicatorColor: MyColors.primaryColorLight,
                labelColor: MyColors.accentColor,
                unselectedLabelColor: Colors.white,
                isScrollable: true,
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                    child: Text(_con.status[index] ?? ''),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: _con.status.map((String status) {
              return FutureBuilder(
                  future: _con.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOrder(snapshot.data[index]);
                            });
                      } else {
                        return NoDataWidget(text: 'No hay ordenes');
                      }
                    } else {
                      return NoDataWidget(text: 'No hay ordenes');
                    }
                  });
            }).toList(),
          )),
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order);
      },
      child: Container(
        height: 160,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: MyColors.accentColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Orden #${order.id}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans',
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Fecha: ${RelativeTimeUtil.getRelativeTime(order.timestamp)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Repartidor: ${order.delivery?.name ?? 'Sin asignar'} ${order.delivery?.lastname ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NimbusSans',
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Dirección de entrega: ${order.address?.address ?? ''} ${order.address?.neighborhood ?? ''}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NimbusSans',
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
