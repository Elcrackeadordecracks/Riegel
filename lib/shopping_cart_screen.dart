// lib/shopping_cart_screen.dart
import 'package:flutter/material.dart';
import 'product_model.dart';

class ShoppingCartScreen extends StatelessWidget {
  final List<ProductModel> cartItems;

  ShoppingCartScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;

    // Calcular el precio total
    cartItems.forEach((product) {
      totalPrice += product.price;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  child: ListTile(
                    leading: Image.network(
                      cartItems[index].imageUrl,
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItems[index].title),
                    subtitle: Text('\$${cartItems[index].price.toString()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        // Aquí agregar la lógica para eliminar el producto del carrito
                        // Puedes utilizar Provider o cualquier otro método para manejar el estado
                        // Esto es solo un ejemplo
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Producto eliminado del carrito'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
