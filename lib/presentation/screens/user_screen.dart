import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/services/index.dart';
import 'package:flutter_application_ecommerce/utils/navigation.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await flutterPackageApiFakeStore.getUser(1);

    result.fold(
      (error) {
        setState(() {
          _errorMessage = error;
        });
      },
      (userInfo) {
        setState(() {
          _user = userInfo;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> logout() async {
    await AuthService().logoutUser();
    redirectHome();
  }

  void redirectHome() {
    Navigation.navigateTo(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil de usuario'),
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
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${_user?.name?.firstname} ${_user?.name?.lastname}',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Email: ${_user?.email}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Username: ${_user?.username}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Phone: ${_user?.phone}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '${_user?.address?.street}, ${_user?.address?.city}, ${_user?.address?.zipcode}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(label: 'Cerrar sesión', onPressed: logout)
                      ],
                    ),
                  ));
  }
}
