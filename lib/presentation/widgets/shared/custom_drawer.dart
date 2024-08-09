import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/services/auth_service.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    userIsLogin();
  }

  Future<void> userIsLogin() async {
    String? token = await AuthService().getUserToken();

    setState(() {
      _isLoggedIn = token != null;
    });
  }

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
              redirectProductScreen(const CategoryProductsScreen());
            },
          ),
          if (!_isLoggedIn) ...[
            ListTile(
              title: const Text('Iniciar sesión'),
              onTap: () {
                redirectProductScreen(const LoginScreen());
              },
            ),
            ListTile(
              title: const Text('Registrarse'),
              onTap: () {
                redirectProductScreen(const AddUserScreen());
              },
            ),
          ] else ...[
            ListTile(
              title: const Text('Perfil'),
              onTap: () {
                redirectProductScreen(const UserScreen());
              },
            ),
            ListTile(
              title: const Text('Carrito de compras'),
              onTap: () {
                redirectProductScreen(const CartScreen());
              },
            ),
            ListTile(
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await AuthService().logoutUser();
                redirectProductScreen(const HomeScreen());
              },
            ),
          ],
          ListTile(
            title: const Text('Contacto y soporte'),
            onTap: () {
              redirectProductScreen(const SupportContactScreen());
            },
          ),
        ],
      ),
    );
  }
}
