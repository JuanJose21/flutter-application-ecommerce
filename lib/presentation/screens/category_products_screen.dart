import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_application_ecommerce/services/index.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreen();
}

class _CategoryProductsScreen extends State<CategoryProductsScreen> {
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  List<String> _categoriesItems = [];
  List<ProductModel> _productsItems = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLoadingProducts = false;
  CategoryEnum? categorySelected;

  @override
  void initState() {
    super.initState();
    setState(() {
      categorySelected = CategoryEnum.electronics;
    });
    _fetchCategoriesItem();
    _fetchProductsByCategory();
  }

  void _fetchCategoriesItem() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await flutterPackageApiFakeStore.getCategories();

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (categoryItems) {
        setState(() {
          _categoriesItems = categoryItems;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _fetchProductsByCategory() async {
    setState(() {
      _isLoadingProducts = true;
      _errorMessage = null;
    });

    print(categoryValues.reverse[categorySelected]);

    final result = await flutterPackageApiFakeStore
        .getCategoryProducts(categorySelected ?? CategoryEnum.electronics);

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (categoryItems) {
        setState(() {
          _productsItems = categoryItems;
        });
      },
    );

    setState(() {
      _isLoadingProducts = false;
    });
  }

  void redirectProductScreen(int productId) {
    Navigation.navigateTo(context, ProductScreen(productId: productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Productos de "${categoryValues.reverse[categorySelected]}"',
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
              : _categoriesItems.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        CategoryList(
                            categories: _categoriesItems
                                .map(
                                    (category) => categoryValues.map[category]!)
                                .toList(),
                            onCategorySelected: (category) {
                              setState(() {
                                categorySelected = category;
                              });
                              _fetchProductsByCategory();
                            }),
                        const SizedBox(height: 16.0),
                        _isLoadingProducts
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _productsItems.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: _productsItems.length,
                                      itemBuilder: (context, index) {
                                        final product = _productsItems[index];
                                        return GestureDetector(
                                          onTap: () => redirectProductScreen(
                                              product.id!),
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
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                        'No hay productos en la categoría.'),
                                  )
                      ]))
                  : const Center(
                      child: Text('No hay categorias por mostrar.'),
                    ),
    );
  }
}
