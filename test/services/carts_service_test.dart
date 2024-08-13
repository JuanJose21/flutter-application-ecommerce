import 'dart:convert';

import 'package:flutter_application_ecommerce/models/cart_item_model.dart';
import 'package:flutter_application_ecommerce/services/carts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    CartService.clearCart();
  });

  group('CartService', () {
    final product = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: CategoryEnum.electronics,
      image: 'https://via.placeholder.com/150',
    );
    test('Debe agregar un producto al carrito', () async {
      await CartService.addProductToCart(product);

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 1);
      expect(cartItems[0].product.id, product.id);
      expect(cartItems[0].quantity, 1);
    });

    test('Debe incrementar la cantidad del producto si ya existe en el carrito',
        () async {
      await CartService.addProductToCart(product);
      await CartService.addProductToCart(product);

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 1);
      expect(cartItems[0].product.id, product.id);
      expect(cartItems[0].quantity, 2);
    });

    test('Debe eliminar el producto del carrito si la cantidad es 0', () async {
      await CartService.addProductToCart(product);
      await CartService.removeProductFromCart(product);

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 0);
    });

    test('Debe guardar los items del carrito en SharedPreferences', () async {
      await CartService.addProductToCart(product);
      await CartService.saveCartItems();

      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cartItems');
      expect(cartData, isNotNull);

      final List<dynamic> decodedData = jsonDecode(cartData!);
      expect(decodedData.length, 1);
      expect(decodedData[0]['product']['id'], product.id);
      expect(decodedData[0]['quantity'], 1);
    });

    test('Debe cargar los items del carrito desde SharedPreferences', () async {
      await CartService.addProductToCart(product);
      await CartService.saveCartItems();

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 1);
      expect(cartItems[0].product.id, product.id);
      expect(cartItems[0].quantity, 1);
    });

    test(
        'Debe limpiar el carrito y eliminar los datos guardados en SharedPreferences',
        () async {
      await CartService.addProductToCart(product);
      await CartService.clearCart();

      final cartItems = CartService.getCartItems();
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cartItems');

      expect(cartItems.length, 0);
      expect(cartData, isNull);
    });

    test(
        'Debe obtener la cantidad de un producto en el carrito, si no existe debe retornar 0',
        () async {
      await CartService.addProductToCart(product);
      await CartService.addProductToCart(product);

      final quantity = CartService.getQuantityProduct(product);

      expect(quantity, 2);
    });

    test('Debe cargar los items del carrito desde SharedPreferences', () async {
      final cartItem = CartItemModel(product: product, quantity: 2);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cartItems', jsonEncode([cartItem.toJson()]));
      await CartService.loadCartItems();

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 1);
      expect(cartItems[0].product.id, product.id);
      expect(cartItems[0].quantity, 2);
    });

    test('No debe cargar ningún item si SharedPreferences está vacío',
        () async {
      await CartService.loadCartItems();

      final cartItems = CartService.getCartItems();
      expect(cartItems.length, 0);
    });
  });
}
