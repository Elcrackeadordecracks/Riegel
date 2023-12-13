import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List productsList = [];
  List cartList = [];
  List reservedList = [];

  // reference our box
  final _productsBox = Hive.box('productsBox');
  final _cartBox = Hive.box('cartBox');
  final _reservedBox = Hive.box('reservedBox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    productsList = [
      {
        "id": 1,
        "title": "Dried apricots",
        "description": "Artificial selection - Taste sweet",
        "category": "fruit",
        "calories": 90,
        "additives": 3,
        "vitamins": 8,
        "price": 9.43,
        "rank": 4,
        "images": ["image1", "image2"],
        "quantity": 300,
        "liked": true,
        "addedToCart": false
      },
    ];
  }

  void createInitialDataCart() {
    cartList = [];
  }

  void createInitialDataReserved() {
    reservedList = [];
  }

  void loadData() {
    productsList = _productsBox.get("productsList", defaultValue: []);
  }

  void loadDataCart() {
    cartList = _cartBox.get("cartList", defaultValue: []);
  }

  void loadDataReserved() {
    reservedList = _reservedBox.get("reservedList", defaultValue: []);
  }

  void updateDataBase() {
    _reservedBox.put("reservedList", reservedList);
    _cartBox.put("cartList", cartList);
    _productsBox.put("productsList", productsList);
  }

  void addToCart() {
    _cartBox.put("cartList", cartList);
  }

  void addToReserved() {
    _reservedBox.put("reservedList", reservedList);
  }

  void cartFill() {
    cartList = [];
  }

  void reserveFill() {
    reservedList = [];
  }
}
