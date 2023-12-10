import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantProductsCreatePage> createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {

  RestaurantProductsCreateController _con = new RestaurantProductsCreateController();

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
        title: Text('Nuevo Producto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            _textFieldCategorieName(),
            _textFieldCategorieDescription(),
            _textFieldCategoriePrice(),
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardImage(_con.imageFile1, 1),
                  _cardImage(_con.imageFile2, 2),
                  _cardImage(_con.imageFile3, 3),
                ],
              ),
            ),
            _dropDownCategories(_con.categories),
          ],
        ),
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: Text('Crear nuevo producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  Widget _textFieldCategorieName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(Icons.fastfood_outlined,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }

  Widget _textFieldCategorieDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: 'Descripción',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(Icons.description_outlined,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }

  Widget _textFieldCategoriePrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(Icons.attach_money_outlined,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }

  Widget _cardImage(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: (){
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
        elevation: 3,
        child: Container(
          height: 100,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.26,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      )
          : Card(
        elevation: 3,
        child: Container(
          height: 150,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.26,
          child: Image(
            image: AssetImage('assets/img/add_image.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
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
              Row(
                children: [
                  Icon(
                      Icons.search,
                      color: MyColors.primaryColor
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Categorias',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      ),
                    ),
                    elevation: 3,
                    isExpanded: true,
                    hint: Text('Seleccione una categoria',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16
                      ),
                    ),
                    items: _dropDownItems(categories),
                    value: _con.idCategory,
                    onChanged: (option){
                      setState((){
                        print('Categoria seleccionada: $option');
                        _con.idCategory = option;
                      });
                      },

                  ),
              )
            ],
          ),
        )
        ,
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category){
      list.add(DropdownMenuItem(
        child: Text(category.name),
        value: category.id,
      ));
    });

    return list;
  }

  void refresh(){
    setState(() {});
  }
}
