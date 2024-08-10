import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/models/cart_item_model.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/services/carts_service.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    setState(() {
      _cartItems = CartService.getCartItems();
    });
  }

  void _addItemToCart(ProductModel product) async {
    await CartService.addProductToCart(product);
    _loadCartItems();
  }

  void _removeItemFromCart(ProductModel product) async {
    await CartService.removeProductFromCart(product);
    _loadCartItems();
  }

  void _checkout() async {
    if (_cartItems.isEmpty) {
      showSnackBar('No hay productos en el carrito.');
      return;
    }

    await CartService.clearCart();
    setState(() {
      _cartItems = [];
      redirectHomeScreen();
      showSnackBar('Compra realizada con éxito.');
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void redirectHomeScreen() {
    Navigation.navigateTo(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool isPopInvoked) {
          setState(() {});
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Carrito de Compras'),
          ),
          body: _cartItems.isEmpty
              ? const Center(
                  child: Text('No hay productos en el carrito.'),
                )
              : ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return ListTile(
                      leading: Image.network(item.product.image),
                      title: Text(item.product.title),
                      subtitle: Text('Cantidad: ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeItemFromCart(item.product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _addItemToCart(item.product),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          bottomNavigationBar: BottomAppBar(
            child: CustomButton(
                label: 'Realizar pedido',
                onPressed: () {
                  _checkout();
                }),
          ),
        ));
  }
}
