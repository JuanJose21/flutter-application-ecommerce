import 'package:flutter_application_ecommerce/models/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

void main() {
  group('CartItemModel', () {
    final product = ProductModel(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: CategoryEnum.electronics,
      image: 'https://via.placeholder.com/150',
    );

    test('Debe crear un CartItemModel correctamente', () {
      final cartItem = CartItemModel(product: product, quantity: 2);

      expect(cartItem.product, isA<ProductModel>());
      expect(cartItem.product.title, 'Test Product');
      expect(cartItem.quantity, 2);
    });

    test('Debe convertir CartItemModel a JSON correctamente', () {
      final cartItem = CartItemModel(product: product, quantity: 2);
      final json = cartItem.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['product']['title'], 'Test Product');
      expect(json['quantity'], 2);
    });

    test('Debe crear CartItemModel desde JSON correctamente', () {
      final json = {
        'product': {
          'id': 1,
          'title': 'Test Product',
          'price': 99.99,
          'description': 'Test Description',
          'category': 'electronics',
          'image': 'https://via.placeholder.com/150',
        },
        'quantity': 2
      };

      final cartItem = CartItemModel.fromJson(json);

      expect(cartItem.product, isA<ProductModel>());
      expect(cartItem.product.title, 'Test Product');
      expect(cartItem.quantity, 2);
    });

    test('Debe crear CartItemModel con la cantidad por defecto igual a 1', () {
      final cartItem = CartItemModel(product: product);

      expect(cartItem.quantity, 1);
    });
  });
}
