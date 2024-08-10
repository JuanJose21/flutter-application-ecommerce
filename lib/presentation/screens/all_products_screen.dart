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
  List<ProductModel> _filteredProductsItems = [];
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
          _filteredProductsItems = productsItems;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProductsItems = _productsItems.where((product) {
        final titleLower = product.title.toLowerCase();
        final descriptionLower = product.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
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
              : _filteredProductsItems.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Buscar productos...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (query) {
                              setState(() {
                                _filterProducts(query);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: _filteredProductsItems.length,
                            itemBuilder: (ctx, i) => GestureDetector(
                              onTap: () => redirectProductScreen(
                                  _filteredProductsItems[i].id!),
                              child: ProductCard(
                                labelButton: 'Agregar',
                                imageUrl: _filteredProductsItems[i].image,
                                title: _filteredProductsItems[i].title,
                                price:
                                    _filteredProductsItems[i].price.toString(),
                                onAddToCart: () async {
                                  await CartService.addProductToCart(
                                      _filteredProductsItems[i]);
                                  setState(() {});
                                },
                                onRemoveToCart: () async {
                                  await CartService.removeProductFromCart(
                                      _filteredProductsItems[i]);
                                  setState(() {});
                                },
                                quantity: CartService.getQuantityProduct(
                                  _filteredProductsItems[i],
                                ),
                              ),
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                          'No hay productos que coincidan con la búsqueda.'),
                    ),
    );
  }
}
