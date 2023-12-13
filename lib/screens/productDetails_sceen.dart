import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/database.dart';
import 'package:rigel/screens/shoopingCart_screen.dart';
import '../screens/reserve_screen.dart';

class DetailedProductScreen extends StatefulWidget {
  final int id;

  const DetailedProductScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailedProductScreen> createState() => _DetailedProductScreenState();
}

class _DetailedProductScreenState extends State<DetailedProductScreen> {
  // reference the hive box
  final _productsBox = Hive.box('productsBox');
  final _cartBox = Hive.box('cartBox');
  final _reservedBox = Hive.box('reservedBox');
  //int _selectedMiniProductIndex = 0; // Track the selected MiniProduct index

  ToDoDataBase db = ToDoDataBase();

  int selectedQuantity = 1; // Initialize with a default value

  @override
  void initState() {
    if (_productsBox.get("productsList") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    if (_cartBox.get("cartList") == null) {
      db.createInitialDataCart();
    } else {
      // there already exists data
      db.loadDataCart();
    }
    if (_reservedBox.get("reservedList") == null) {
      db.createInitialDataReserved();
    } else {
      // there already exists data
      db.loadDataReserved();
    }

    super.initState();
  }

  double calculateTotalPrice() {
    double price = db.productsList[widget.id]["price"];
    return price * selectedQuantity;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400], // Fondo gris claro
      appBar: AppBar(
        title: Text("Product Description"),
        backgroundColor: Colors.white, // Barra de navegación gris oscuro
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var product in db.productsList[widget.id]["images"])
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 150,
                      child: Image.file(
                        File(product),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                db.productsList[widget.id]["title"],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      db.productsList[widget.id]["description"],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int starIndex = 0; starIndex < 5; starIndex++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              db.productsList[widget.id]["rank"] =
                                  starIndex + 1;
                            });
                          },
                          child: Icon(
                            starIndex < db.productsList[widget.id]["rank"]
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Capacity",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var nutrient in [
                    {
                      "name": 'Calories',
                      "value": db.productsList[widget.id]["calories"].toString()
                    },
                    {
                      "name": 'Additive',
                      "value":
                          db.productsList[widget.id]["additives"].toString()
                    },
                    {
                      "name": 'Vitamin',
                      "value": db.productsList[widget.id]["vitamins"].toString()
                    },
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                          color: Colors.white, // Fondo blanco
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              nutrient["name"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              nutrient["value"]!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Rounded Small Modal with Quantity Information
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(children: [
                Text(
                  "Quantity(${db.productsList[widget.id]["quantity"]}g)",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                // Quantity Selection and Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<int>(
                        value: selectedQuantity,
                        onChanged: (value) {
                          setState(() {
                            selectedQuantity = value!;
                          });
                        },
                        items: List.generate(10, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "\$${calculateTotalPrice().toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Add to Cart Button
                // Add to Cart Button
                ElevatedButton(
                  onPressed: () async {
                    bool exist = false;
                    for (final i in db.cartList) {
                      if (!i.contains(widget.id)) {
                        exist = false;
                      } else {
                        exist = true;
                      }
                    }
                    if (!exist) {
                      db.cartList.add([widget.id, selectedQuantity]);
                      db.addToCart();
                      db.updateDataBase();
                      print(db.cartList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product added to the cart'),
                        ),
                      );
                    } else {
                      print(db.cartList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product is already in the cart'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Fondo negro
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool exist =
                        db.reservedList.any((i) => i.contains(widget.id));

                    if (!exist) {
                      db.reservedList.add([widget.id, selectedQuantity]);
                      db.addToReserved();
                      db.updateDataBase();
                      print(db.reservedList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product Reserved correctly'),
                        ),
                      );
                    } else {
                      if (db.reservedList != null) {
                        print(db.reservedList);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Product is already in the reserved list'),
                          ),
                        );
                      } else {
                        print('Error: db.reservedList is null');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Fondo negro
                  ),
                  child: Text(
                    'Reserve product',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),

            // Rounded Small Modal with Quantity Information
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Go to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservedScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Go to Reserved Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
