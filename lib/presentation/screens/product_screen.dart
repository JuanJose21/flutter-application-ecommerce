import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/custom_app_bar.dart';
import 'package:flutter_application_ecommerce/services/carts_service.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class ProductScreen extends StatefulWidget {
  final int productId;

  const ProductScreen({required this.productId, super.key});

  @override
  State<ProductScreen> createState() => _ProductScreen();
}

class _ProductScreen extends State<ProductScreen> {
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  ProductModel? _product;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategoryItems();
  }

  void _fetchCategoryItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result =
        await flutterPackageApiFakeStore.getProduct(widget.productId);

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (productItem) {
        setState(() {
          _product = productItem;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  void redirectProductScreen(int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductScreen(productId: productId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: _product?.title ?? '',
        ),
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
                : _product?.id == null
                    ? const Center(
                        child: Text('No se encontró el producto'),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.network(
                                '${_product?.image}',
                                height: 250.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                '${_product?.title}',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '\$${_product?.price}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                '${_product?.description}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Categoría: ${categoryValues.reverse[_product?.category]}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              if (_product?.rating != null) ...[
                                Text(
                                  'Rating: ${_product?.rating?.rate} (${_product?.rating?.count} reviews)',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16.0),
                              CustomButton(
                                label: 'Agregar al carrito',
                                onPressed: () {
                                  CartService.addToCart();
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
  }
}
