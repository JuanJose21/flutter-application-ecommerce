import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/product_screen.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_application_ecommerce/services/carts_service.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreen();
}

class _AllProductsScreen extends State<AllProductsScreen> {
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  List<ProductModel> _productsItems = [];
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProductsItems();
  }

  void _fetchProductsItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await flutterPackageApiFakeStore.getProducts();

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (productsItems) {
        setState(() {
          _productsItems = productsItems;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void redirectProductScreen(int productId) {
    Navigation.navigateTo(
      context,
      ProductScreen(productId: productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Todos los productos',
      ),
      drawer: const CustomDrawer(),
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
              : _productsItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _productsItems.length,
                      itemBuilder: (context, index) {
                        final product = _productsItems[index];
                        return GestureDetector(
                          onTap: () => redirectProductScreen(product.id!),
                          child: ProductCard(
                            imageUrl: product.image,
                            title: product.title,
                            price: product.price.toString(),
                            onAddToCart: () {
                              CartService.addToCart();
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No hay productos en el carrito.'),
                    ),
    );
  }
}
