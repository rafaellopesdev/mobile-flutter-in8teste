import 'package:flutter/material.dart';
import 'package:mobile_flutter_in8teste/app/presentation/widgets/product_grid_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'login_screen.dart';

class AuthOrHomeScreen extends StatefulWidget {
  const AuthOrHomeScreen({super.key});

  @override
  State<AuthOrHomeScreen> createState() => _AuthOrHomeScreenState();
}

class _AuthOrHomeScreenState extends State<AuthOrHomeScreen> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    _authFuture = Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: _authFuture,
      builder: (ctx, authSnapshot) {
        if (auth.isLoggedIn) {
          return FutureBuilder(
            future: Provider.of<CartProvider>(context, listen: false).fetchCart(),
            builder: (ctx, cartSnapshot) {
              if (cartSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              return const ProductGridScreen();
            },
          );
        }

        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        return const LoginScreen();
      },
    );
  }
}