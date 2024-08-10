import 'dart:convert';
import 'package:flutter_application_ecommerce/models/cart_item_model.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static final List<CartItemModel> _cartItems = [];

  static getQuantityProduct(ProductModel product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );
    return existingItem.quantity;
  }

  static Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    if (cartData != null) {
      final List<dynamic> decodedData = jsonDecode(cartData);
      _cartItems.clear();
      _cartItems.addAll(
          decodedData.map((item) => CartItemModel.fromJson(item)).toList());
    }
  }

  static Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData =
        jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', cartData);
  }

  static List<CartItemModel> getCartItems() {
    return _cartItems;
  }

  static Future<void> addProductToCart(ProductModel product) async {
    final existingItem = _cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItemModel(product: product, quantity: 0));

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItemModel(product: product));
    }
    await saveCartItems();
  }

  static Future<void> removeProductFromCart(ProductModel product) async {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItemModel(product: product, quantity: 0),
    );

    existingItem.quantity--;
    if (existingItem.quantity == 0) {
      _cartItems.remove(existingItem);
      return;
    }
    if (!_cartItems.contains(existingItem)) {
      _cartItems.add(existingItem);
    }
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cartItems');
    _cartItems.clear();
  }
}
