import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/pages/register/register_controller.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController _con = new RegisterController();

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
        body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              _imageUser(),
              _textFieldEmail(),
              _textFieldName(),
              _textFieldLastName(),
              _textFieldPhone(),
              _textFieldPassword(),
              _textFieldConfirmPassword(),
              _buttonRegister(),
              _buttonBack(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo electrónico',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.lastnameController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.deliveryGray,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            hintStyle: TextStyle(color: MyColors.chatDarkBlue),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.irisGreen,
            )),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.register : null,
        child: Text('Registrarse',
            style: TextStyle(
                color: MyColors.chatDarkBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
            primary: MyColors.chatOrange,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _buttonBack() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancelar',
          style: TextStyle(color: MyColors.irisBlue, fontSize: 16),
        ),
        style:
            TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30)),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : AssetImage('assets/img/user_profile.png'),
        radius: 50,
        backgroundColor: MyColors.deliveryGray,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
