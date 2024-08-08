import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_application_ecommerce/services/auth_service.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  String? _errorMessage;
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _errorMessage = null;
        _isLoading = true;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      final result = await flutterPackageApiFakeStore
          .login(AuthPostModel(username: username, password: password));

      result.fold(
          (error) => {
                setState(() {
                  _errorMessage = error;
                })
              },
          (token) => {loginSuccess(token)});

      setState(() {
        _isLoading = false;
      });

      _usernameController.clear();
      _passwordController.clear();
    }
  }

  Future<void> loginSuccess(TokenModel token) async {
    await AuthService().saveToken(token.token);
    redirectHome();
  }

  void redirectHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Iniciar sesión',
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Nombre de usuario',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre de usuario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                labelText: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const CustomLoading()
                  : CustomButton(
                      label: 'Iniciar sesión', onPressed: _submitForm),
              const SizedBox(height: 32.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
