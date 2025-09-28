import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _brandController;
  late TextEditingController _categoryController;
  late TextEditingController _thumbnailController;

  Product? _editingProduct;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Product) {
      _editingProduct = args;
    }

    _titleController = TextEditingController(text: _editingProduct?.title ?? '');
    _descriptionController = TextEditingController(text: _editingProduct?.description ?? '');
    _priceController = TextEditingController(
        text: _editingProduct != null ? _editingProduct!.price.toString() : '');
    _brandController = TextEditingController(text: _editingProduct?.brand ?? '');
    _categoryController = TextEditingController(text: _editingProduct?.category ?? '');
    _thumbnailController = TextEditingController(text: _editingProduct?.thumbnail ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProductProvider>();

      final newProduct = Product(
        id: _editingProduct?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: num.tryParse(_priceController.text) ?? 0,
        brand: _brandController.text.isEmpty ? null : _brandController.text,
        category: _categoryController.text.isEmpty ? null : _categoryController.text,
        thumbnail: _thumbnailController.text.isEmpty ? null : _thumbnailController.text,
      );

      if (_editingProduct == null) {
        await provider.addProduct(newProduct);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto creado')),
          );
        }
      } else {
        await provider.updateProduct(newProduct.id!, newProduct.toJson());
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingProduct == null ? 'Nuevo Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca (opcional)'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoría (opcional)'),
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(labelText: 'URL Imagen (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
