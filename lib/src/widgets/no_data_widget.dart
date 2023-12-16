import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String text;

  NoDataWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ajusta el tamaño del contenedor al 100% del ancho de la pantalla
      width: MediaQuery.of(context).size.width,
      child: Column(
        // Ajusta el contenido al centro
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/no_items.png',
            width: MediaQuery.of(context).size.width *
                0.5, // Ejemplo de ajuste de tamaño
          ),
          SizedBox(height: 20), // Ajusta el espacio entre la imagen y el texto
          Text(
            text,
            style: TextStyle(
              fontSize: 18, // Ajusta según tus necesidades
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center, // Asegura que el texto esté centrado
          ),
        ],
      ),
    );
  }
}
