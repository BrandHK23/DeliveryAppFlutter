import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/products/detail/restaurant_products_detail_controller.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class RestaurantProductsDetailPage extends StatefulWidget {
  Product product;

  RestaurantProductsDetailPage({Key key, @required this.product})
      : super(key: key);

  @override
  State<RestaurantProductsDetailPage> createState() =>
      _RestaurantProductsDetailPageState();
}

class _RestaurantProductsDetailPageState
    extends State<RestaurantProductsDetailPage> {
  RestaurantProductsDetailController _con =
      new RestaurantProductsDetailController();
  bool _isEditableName = false;
  bool _isEditableDescription = false;
  bool _isEditablePrice = false;

  ProductsProviders _productsProvider = new ProductsProviders();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _productsProvider.init(context, _con.user);
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Envuelve tu contenido en un SafeArea
        child: SingleChildScrollView(
          // Permite el desplazamiento
          child: ConstrainedBox(
            // Asegura que el contenido se ajuste al espacio disponible
            constraints: BoxConstraints(
              // Asegura que el contenido mínimo se extienda al tamaño disponible
              minHeight: MediaQuery.of(context).size.height * 0.89,
            ),
            child: IntrinsicHeight(
              // Permite que el contenido crezca según su contenido interno
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Ajusta el tamaño al mínimo necesario
                children: [
                  _imageSlideShow(),
                  _editableNameField(),
                  _editableDescriptionField(),
                  _editablePriceFieldAndSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _editableNameField() {
    return Row(
      children: [
        _textFieldContainer(), // Widget para el campo de texto
        _editIconButton(), // Widget para el botón de editar
      ],
    );
  }

  Widget _textFieldContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: MyColors.deliveryGray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: _con.nameController,
          enabled: _isEditableName,
          decoration: InputDecoration(
            labelText: "Nombre del producto",
            labelStyle: TextStyle(color: MyColors.deliveryNavy),
            contentPadding:
                EdgeInsets.only(left: 15, right: 0, top: 15, bottom: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyColors.primaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _editIconButton() {
    // Asume que hay una única variable booleana para controlar la edición de todos los campos
    bool _isEditing =
        _isEditableName || _isEditableDescription || _isEditablePrice;

    return Container(
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: _isEditing ? MyColors.irisGreen : MyColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(_isEditing ? Icons.check : Icons.edit),
        onPressed: () {
          setState(() {
            // Cambia el estado de edición de todos los campos
            _isEditableName = !_isEditableName;
            _isEditableDescription = !_isEditableDescription;
            _isEditablePrice = !_isEditablePrice;

            // Si se está desactivando el modo de edición, guarda los cambios localmente
            if (!_isEditableName &&
                !_isEditableDescription &&
                !_isEditablePrice) {
              _con.saveLocalChanges();
            }
          });
        },
      ),
    );
  }

  Widget _editablePriceField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: MyColors.deliveryGray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: _con.priceController,
          enabled: _isEditablePrice,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          // Asegúrate de que el teclado sea numérico
          decoration: InputDecoration(
            labelText: "Precio del producto",
            labelStyle: TextStyle(color: MyColors.deliveryNavy),
            contentPadding:
                EdgeInsets.only(left: 15, right: 0, top: 15, bottom: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyColors.primaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
            ),
            border: InputBorder.none,
            prefixText: "\$",
            // Aquí agregas el símbolo $
            prefixStyle: TextStyle(
                color: MyColors.deliveryNavy,
                fontSize: 16), // Estilo para el símbolo $
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Expanded(
      child: Container(
        height: 60, // Ajusta la altura según necesites
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          onPressed: () {
            // Lógica para guardar todos los cambios realizados
            _con.saveChanges();
          },
          style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor, // Color del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "Guardar",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _editablePriceFieldAndSaveButton() {
    return Row(
      children: [
        _editablePriceField(),
        _saveButton(),
      ],
    );
  }

  Widget _editableDescriptionField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: MyColors.deliveryGray.withOpacity(0.5),
              // Usa el color adecuado de tu tema
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: _con.descriptionController,
              enabled: _isEditableDescription,
              maxLines: null,
              // Esto permitirá que el campo se expanda verticalmente
              minLines: 5,
              // Mínimo de líneas para mostrar
              keyboardType: TextInputType.multiline,
              // Asegura que el teclado sea adecuado para entrada de texto multilínea
              decoration: InputDecoration(
                labelText: "Descripción del producto",
                labelStyle: TextStyle(color: MyColors.deliveryNavy),
                contentPadding:
                    EdgeInsets.only(left: 15, right: 0, top: 15, bottom: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: MyColors.primaryColor,
                      width: 1), // Borde cuando está habilitado
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: MyColors.primaryColor,
                      width: 2), // Borde cuando está enfocado
                ),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {
                // Aquí puedes manejar la acción de guardar cuando se finaliza la edición
              },
            ),
          ),
        ),
      ],
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
