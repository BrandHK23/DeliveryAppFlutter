import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {_con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              _lottieAnimation(),
              _textFieldEmail(),
              _textFieldPassword(),
              _buttonLogin(),
              _rowTexts(),
            ],
          ),
        ),
      ),
    );
  }



  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(top: 80, bottom: MediaQuery.of(context).size.height * 0.2),
      child: Image.asset(
        'assets/img/delivery.png',
        width: 200,
        height: 200,
      ),
    );
  }
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          hintStyle: TextStyle(
          color: MyColors.primaryColorDark
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(Icons.email,
            color: MyColors.primaryColor,)
        ),
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(Icons.lock,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }

  Widget _lottieAnimation(){
    return Container(
      margin: EdgeInsets.only(top: 100, bottom: MediaQuery.of(context).size.height * 0.1),
      child: Lottie.asset('assets/json/Animation.json',
      width: 450,
      height: 200,
      fit: BoxFit.fill,
      ),
    );
  }

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: ElevatedButton(
        onPressed: _con.login,
        child: Text('Iniciar sesión'),
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.symmetric(horizontal: 50)
        )
      ),
    );
  }

  Widget _rowTexts(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes cuenta?'),
        SizedBox(width: 5),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text('Regístrate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.primaryColor
          ),
          ),
        )
        ],
    );
  }
}
