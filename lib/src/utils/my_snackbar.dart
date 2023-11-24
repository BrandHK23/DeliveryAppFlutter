import 'package:flutter/material.dart';

class MySnackbar {
  static void show(BuildContext context, String message) {
    if (context == null) return;

    // Envolver el contenido en un Builder
    Builder(
      builder: (BuildContext innerContext) {
        FocusScope.of(innerContext).requestFocus(new FocusNode());

        Scaffold.of(innerContext).removeCurrentSnackBar();
        Scaffold.of(innerContext).showSnackBar(
          SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ),
        );
        return Container(); // Este container no se mostrará, es solo para completar el builder
      },
    );
  }
}

