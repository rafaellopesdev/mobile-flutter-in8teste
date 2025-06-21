import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import '../../data/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cartProvider, _) {
          if (cartProvider.isLoading && cartProvider.cart == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = cartProvider.cart?.items ?? [];

          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Seu carrinho está vazio.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: cartItems.length,
                      itemBuilder: (ctx, i) {
                        final item = cartItems[i];
                        return CartItemTile(item: item);
                      },
                    ),
                  ),
                  
                  CartSummary(total: cartProvider.cartTotal),
                ],
              ),

              if (cartProvider.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


// WIDGETS AUXILIARES (para facilitar o 'copiar e colar')

class CartSummary extends StatelessWidget {
  final double total;
  const CartSummary({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 20)),
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: total > 0
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) => const CheckoutScreen()),
                      );
                    }
                  : null,
              child: const Text('COMPLETAR PEDIDO'),
            )
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(item.gallery.first),
            onBackgroundImageError: (exception, stackTrace) {},
          ),
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Preço: R\$${item.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () {
                  if (item.quantity > 1) {
                    cartProvider.updateQuantity(item.id, item.quantity - 1);
                  } else {
                    cartProvider.deleteProduct(item.id);
                  }
                },
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  cartProvider.updateQuantity(item.id, item.quantity + 1);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.black54),
                tooltip: 'Remover item',
                onPressed: () {
                  cartProvider.deleteProduct(item.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}