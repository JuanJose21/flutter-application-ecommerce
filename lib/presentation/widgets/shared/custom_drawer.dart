import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/all_products_screen.dart';
import 'package:flutter_application_ecommerce/presentation/screens/home_screen.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void redirectProductScreen(Widget screen) {
      Navigation.navigateTo(context, screen);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('Menú',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
          ),
          ListTile(
            title: const Text('Inicio'),
            onTap: () {
              redirectProductScreen(const HomeScreen());
            },
          ),
          ListTile(
            title: const Text('Todos los productos'),
            onTap: () {
              redirectProductScreen(const AllProductsScreen());
            },
          ),
          ListTile(
            title: const Text('Productos por categoría'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Iniciar sesión'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Registrarse'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Carrito de compras'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Perfil'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
