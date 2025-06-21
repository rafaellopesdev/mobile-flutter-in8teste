import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'phone': TextEditingController(),
    'street': TextEditingController(),
    'number': TextEditingController(),
    'neighborhood': TextEditingController(),
    'zipCode': TextEditingController(),
    'city': TextEditingController(),
    'state': TextEditingController(),
    'stateName': TextEditingController(),
    'observation': TextEditingController(),
  };

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final cartTotal = cartProvider.cartTotal;

    final cartItems = cartProvider.cart?.items ?? [];

    if (cartTotal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não é possível finalizar um pedido com total zerado.'),
          backgroundColor: Colors.red,
        ),
      );
      return; 
    }

    final order = Order(
      productsIds: cartItems.map((item) => ProductOrderItem(id: item.id, quantity: item.quantity)).toList(),
      phone: _controllers['phone']!.text,
      street: _controllers['street']!.text,
      number: int.tryParse(_controllers['number']!.text) ?? 0,
      neighborhood: _controllers['neighborhood']!.text,
      zipCode: _controllers['zipCode']!.text,
      city: _controllers['city']!.text,
      state: _controllers['state']!.text,
      stateName: _controllers['stateName']!.text,
      observation: _controllers['observation']!.text,
      total: cartTotal,
    );

     print("1. [TELA CHECKOUT] Objeto 'Order' criado. JSON: ${order.toJson()}");

    final success = await orderProvider.createOrder(order);

    if (success && mounted) {
      await cartProvider.clearCart();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const OrderSuccessScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao finalizar o pedido. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _controllers['phone'], decoration: const InputDecoration(labelText: 'Telefone'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['street'], decoration: const InputDecoration(labelText: 'Rua'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['number'], decoration: const InputDecoration(labelText: 'Número'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['neighborhood'], decoration: const InputDecoration(labelText: 'Bairro'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['zipCode'], decoration: const InputDecoration(labelText: 'CEP'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['city'], decoration: const InputDecoration(labelText: 'Cidade'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['state'], decoration: const InputDecoration(labelText: 'Estado (UF)'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['stateName'], decoration: const InputDecoration(labelText: 'Nome do Estado'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: _controllers['observation'], decoration: const InputDecoration(labelText: 'Observação (Opcional)')),
              const SizedBox(height: 20),
              Consumer<OrderProvider>(
                builder: (ctx, order, _) => order.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        onPressed: _submitOrder,
                        child: const Text('FINALIZAR PEDIDO'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}