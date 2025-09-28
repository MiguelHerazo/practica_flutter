import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Práctica Flutter - CRUD',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ProductListScreen(),
          '/detail': (context) => const ProductDetailScreen(),
          '/form': (context) => const ProductFormScreen(),
        },
      ),
    );
  }
}
