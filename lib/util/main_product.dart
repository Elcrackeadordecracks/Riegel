import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rigel/screens/productDetails_sceen.dart';
import 'package:rigel/screens/shoopingCart_screen.dart';

class MainProduct extends StatelessWidget {
  final int id;
  final String title;
  final bool liked;
  final double price;
  final int quantity;
  final int rank;
  final String img;
  Function(bool?)? onChanged;

  MainProduct({
    Key? key,
    required this.id,
    required this.title,
    required this.liked,
    required this.price,
    required this.quantity,
    required this.rank,
    required this.img,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenWidth * 0.9,
          height: screenWidth * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey,
                Colors.grey.shade500,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.30,
                height: screenWidth * 0.30,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(img),
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      print('Error loading image: $error');
                      print('StackTrace: $stackTrace');
                      return const Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.06),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Text(
                            "\$${price.toStringAsFixed(2)} / $quantity g",
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < rank ? Icons.star : Icons.star_border,
                                color: index < rank
                                    ? Colors.yellow
                                    : Colors.yellow,
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.03),
                          ElevatedButton(
                            onPressed: () {
                              _addToCartButtonPressed(context);
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart),
                                SizedBox(width: 8),
                                Text("Add to cart"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: liked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        onChanged?.call(!liked);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCartButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedProductScreen(id: id),
      ),
    );
    print(id);
  }
}
