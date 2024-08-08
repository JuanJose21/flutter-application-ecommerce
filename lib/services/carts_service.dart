import 'package:flutter_application_ecommerce/utils/user.dart';

class CartService {
  static addToCart() async {
    if (User.userIsLogin()) {
      print('Product added to cart');
    } else {
      // TODO: redirect to login screen
      print('User is not logged in');
    }
  }
}
