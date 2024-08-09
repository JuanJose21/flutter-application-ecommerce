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
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: _productsItems.length,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () =>
                            redirectProductScreen(_productsItems[i].id!),
                        child: ProductCard(
                          imageUrl: _productsItems[i].image,
                          title: _productsItems[i].title,
                          price: _productsItems[i].price.toString(),
                          onAddToCart: () {
                            CartService.addToCart();
                          },
                        ),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    )
                  : const Center(
                      child: Text('No hay productos en el carrito.'),
                    ),
    );
  }
}
