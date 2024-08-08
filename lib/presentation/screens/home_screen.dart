import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/all_products_screen.dart';
import 'package:flutter_application_ecommerce/presentation/screens/product_screen.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_application_ecommerce/services/carts_service.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    final result = await flutterPackageApiFakeStore
        .getCategoryProducts(CategoryEnum.electronics);

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
    Navigation.navigateTo(context, ProductScreen(productId: productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Inicio',
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
                  ? Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Productos Electrónicos',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemCount: _productsItems.length,
                              itemBuilder: (ctx, i) => GestureDetector(
                                onTap: () => redirectProductScreen(
                                    _productsItems[i].id!),
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
                                childAspectRatio: 0.54,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                            ),
                          ),
                          Center(
                            child: CustomButton(
                                label: 'Ver todos los productos',
                                onPressed: () => Navigation.navigateTo(
                                    context, const AllProductsScreen())),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('No hay productos en el carrito.'),
                    ),
    );
  }
}
