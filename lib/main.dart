import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rigel/screens/camara.dart';
import 'screens/home_screen.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  try {
    // open boxes
    var productsBox = await Hive.openBox('productsBox');
    var cartBox = await Hive.openBox('cartBox');
    var reservedBox = await Hive.openBox('reservedBox');

    print('Products Box: $productsBox');
    print('Cart Box: $cartBox');

    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    runApp(const MyApp());
  } catch (e) {
    print('Error al iniciar Hive: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}
