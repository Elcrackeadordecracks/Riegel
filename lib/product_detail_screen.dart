// lib/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              product.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text('Categoría: ${product.category}'),
            Text('Precio: \$${product.price.toString()}'),
            Text('Ranking: ${product.ranking.toString()}'),
            // Agrega más detalles según sea necesario
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Aquí agregar la lógica para agregar el producto al carrito
                // Puedes utilizar Provider o cualquier otro método para manejar el estado
                // Esto es solo un ejemplo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Producto agregado al carrito'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Agregar al Carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
