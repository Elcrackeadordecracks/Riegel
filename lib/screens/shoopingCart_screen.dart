import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rigel/models/database.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _productsBox = Hive.box('productsBox');
  final _cartBox = Hive.box('cartBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_productsBox.get("productsList") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    if (_cartBox.get("cartList") == null) {
      db.createInitialDataCart();
    } else {
      db.loadDataCart();
    }

    super.initState();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var cartItem in db.cartList) {
      int productId = cartItem[0];
      int quantity = cartItem[1];
      double productPrice = db.productsList[productId]["price"];
      totalPrice += productPrice * quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            for (var cartItem in db.cartList)
              Card(
                elevation: 3,
                color: Colors.grey[900],
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      File(db.productsList[cartItem[0]]["images"][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    db.productsList[cartItem[0]]["title"],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "\$${db.productsList[cartItem[0]]["price"]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            cartItem[1]--;
                            if (cartItem[1] < 1) {
                              db.cartList.remove(cartItem);
                            }
                          });
                        },
                      ),
                      Text(
                        "${cartItem[1]}",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            cartItem[1]++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Implement any action when the Buy Now button is pressed
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black, // background color
            onPrimary: Colors.yellow, // text color
            elevation: 0, // remove button elevation
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Items: ${db.cartList.length}",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "\$${calculateTotalPrice().toStringAsFixed(2)} Buy Now",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
