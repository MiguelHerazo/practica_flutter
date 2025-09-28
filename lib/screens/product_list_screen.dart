import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _query = '';

@override
void initState() {
  super.initState();
  // Esperar un frame antes de llamar a fetchProducts
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<ProductProvider>();
    provider.fetchProducts();
  });

  // scroll infinito
  _scrollController.addListener(() {
    final provider = context.read<ProductProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMore &&
        !provider.isLoading) {
      provider.fetchProducts();
    }
  });
}


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          final filtered = provider.products
              .where((p) =>
                  p.title.toLowerCase().contains(_query.toLowerCase()))
              .toList();

          return Column(
            children: [
              // buscador
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar producto...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filtered.length + 1,
                  itemBuilder: (context, index) {
                    if (index < filtered.length) {
                      final Product product = filtered[index];
                      return ListTile(
                        leading: product.thumbnail != null
                            ? Image.network(product.thumbnail!,
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(product.title),
                        subtitle: Text('\$${product.price}'),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail',
                              arguments: product);
                        },
                      );
                    } else {
                      return provider.hasMore
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
