import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product initialProduct =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // Buscar el producto actualizado en la lista de provider
        final product = provider.products.firstWhere(
          (p) => p.id == initialProduct.id,
          orElse: () => initialProduct,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/form',
                    arguments: product,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text(
                          '¿Seguro que quieres eliminar este producto?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await provider.deleteProduct(product.id!);
                      if (context.mounted) {
                        Navigator.pop(context); // volver a la lista
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Producto eliminado')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Producto eliminado localmente (API devolvió error)')),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.thumbnail != null)
                    Center(
                      child: Image.network(
                        product.thumbnail!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precio: \$${product.price}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (product.brand != null) Text('Marca: ${product.brand!}'),
                  if (product.category != null)
                    Text('Categoría: ${product.category!}'),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
