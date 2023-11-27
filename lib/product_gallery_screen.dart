// En lib/product_gallery_screen.dart
import 'package:flutter/material.dart';
import 'product_detail_screen.dart'; // Importa la pantalla de detalles
import 'shopping_cart_screen.dart'; // Importa la pantalla del carrito
import 'product_model.dart';

class ProductGalleryScreen extends StatefulWidget {
  @override
  _ProductGalleryScreenState createState() => _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends State<ProductGalleryScreen> {
  List<ProductModel> products = [
    ProductModel(
      title: 'Producto 1',
      category: 'Categoría A',
      imageUrl: 'url_imagen_1',
      price: 20.0,
      ranking: 4,
    ),
    // Agrega más productos según sea necesario
  ];

  List<ProductModel> cartItems = []; // Lista de productos en el carrito

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShoppingCartScreen(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: products[index]),
                ),
              );
            },
            child: Card(
              elevation: 4.0,
              child: ListTile(
                leading: Image.network(
                  products[index].imageUrl,
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  products[index].title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('\$${products[index].price.toString()}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
