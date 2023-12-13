import 'dart:io';
import 'package:flutter/material.dart';

class MiniProduct extends StatelessWidget {
  final String img;
  final VoidCallback onTap;

  MiniProduct({
    Key? key,
    required this.img,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.blue.shade900,
              ],
            ),
          ),
          child: ClipOval(
            child: Image.file(
              File(img),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
