import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/database.dart';

class ReservedScreen extends StatefulWidget {
  ReservedScreen({Key? key});

  @override
  State<ReservedScreen> createState() => _ReservedScreenState();
}

class _ReservedScreenState extends State<ReservedScreen> {
  final _productsBox = Hive.box('productsBox');
  final _reservedBox = Hive.box('reservedBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_productsBox.get("productsList") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    if (_reservedBox.get("reservedList") == null) {
      db.createInitialDataReserved();
    } else {
      db.loadDataReserved();
    }

    super.initState();
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var reservedItem in db.reservedList) {
      int productId = reservedItem[0];
      int quantity = reservedItem[1];

      if (productId >= 0 && productId < db.productsList.length) {
        var product = db.productsList[productId];

        if (product.containsKey("images") &&
            product["images"] is List &&
            (product["images"] as List).isNotEmpty) {
          String imagePath = (product["images"] as List)[0];
          File imageFile = File(imagePath);

          totalPrice += product["price"] * quantity;
        } else {
          print("Invalid images for product with id $productId");
        }
      } else {
        print("Invalid productId: $productId");
      }
    }
    return totalPrice;
  }

  double calculateTwentyPercent() {
    double totalPrice = calculateTotalPrice();
    return totalPrice * 0.20;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fondo gris oscuro
      appBar: AppBar(
        title: Text('Reserved Products'),
        backgroundColor: Colors.white, // Barra de navegación negra
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (var reservedItem in db.reservedList)
              Card(
                elevation: 3,
                color: Colors.grey[800], // Card gris oscuro
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      File(db.productsList[reservedItem[0]]["images"][0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    db.productsList[reservedItem[0]]["title"],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "\$${db.productsList[reservedItem[0]]["price"]}",
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
                            reservedItem[1]--;
                            if (reservedItem[1] < 1) {
                              db.reservedList.remove(reservedItem);
                            }
                          });
                        },
                      ),
                      Text(
                        "${reservedItem[1]}",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            reservedItem[1]++;
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
            primary: Colors.grey[800], // Botón gris oscuro
            onPrimary: Colors.yellow, // Texto amarillo
            elevation: 0,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${db.reservedList.length} : Items ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  "\Reserve It Now\n       (\$${calculateTwentyPercent().toStringAsFixed(2)})",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
