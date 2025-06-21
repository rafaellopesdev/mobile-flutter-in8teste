import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/presentation/providers/auth_provider.dart';
import 'app/presentation/screens/auth_or_home_screen.dart';
import 'app/presentation/providers/cart_provider.dart';
import 'app/presentation/providers/order_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (ctx) => CartProvider(),
          update: (ctx, auth, previousCartProvider) {
            if (!auth.isLoggedIn && (previousCartProvider?.isUserLoggedIn ?? false)) {
              previousCartProvider?.clearCart();
            }
            previousCartProvider?.setIsUserLoggedIn(auth.isLoggedIn);
            return previousCartProvider!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'in8store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthOrHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}