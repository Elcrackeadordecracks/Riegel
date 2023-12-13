import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor; // Nuevo parámetro para el color del botón

  MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.blue, // Color por defecto es azul
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor, // Usa el color proporcionado
      child: Text(text),
    );
  }
}
