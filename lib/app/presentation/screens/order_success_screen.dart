import 'package:flutter/material.dart';
import 'package:mobile_flutter_in8teste/app/presentation/widgets/product_grid_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Pedido realizado com sucesso!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const ProductGridScreen()),
                  (route) => false,
                );
              },
              child: const Text('VOLTAR AOS PRODUTOS'),
            ),
          ],
        ),
      ),
    );
  }
}