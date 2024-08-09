import 'package:flutter/material.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  List<CartModel> _cartItems = [];
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await flutterPackageApiFakeStore.getCartByUser('1');

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (cartItems) {
        setState(() {
          _cartItems = cartItems;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = _cartItems[index];
                        return ExpansionTile(
                          title: Text('Carrito ID: ${cartItem.id}'),
                          subtitle: Text('Usuario ID: ${cartItem.userId}'),
                          children: cartItem.products.map((product) {
                            return ListTile(
                              title: Text('Producto ID: ${product.quantity}'),
                              subtitle: Text('Cantidad: ${product.quantity}'),
                            );
                          }).toList(),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No hay productos en el carrito.'),
                    ),
    );
  }
}
