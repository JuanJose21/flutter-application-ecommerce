import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/screens/index.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';
import 'package:flutter_package_api_fake_store/flutter_package_api_fake_store.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreen();
}

class _AddUserScreen extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final FlutterPackageApiFakeStore flutterPackageApiFakeStore =
      FlutterPackageApiFakeStore();
  bool _isLoading = false;
  String? _errorMessage;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final newUser = UserModel(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        name: NameModel(
          firstname: _firstNameController.text,
          lastname: _lastNameController.text,
        ),
        address: AddressModel(
            city: _cityController.text,
            street: _streetController.text,
            zipcode: _zipcodeController.text,
            geolocation: GeolocationModel(
              lat: 'lat',
              long: 'long',
            ),
            number: 2),
        phone: _phoneController.text,
      );

      final result = await flutterPackageApiFakeStore.addUser(newUser);

      result.fold(
        (error) => setState(() => _errorMessage = error),
        (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario agregado exitosamente')),
          );
          _firstNameController.clear();
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _lastNameController.clear();
          _phoneController.clear();
          _streetController.clear();
          _cityController.clear();
          _zipcodeController.clear();
          redirectLogin();
        },
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  void redirectLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                hintText: 'Nombre',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Apellido',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Nombre de usuario',
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
                hintText: 'Correo electrónico',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su correo electrónico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Teléfono',
                controller: _phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Calle',
                controller: _streetController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su calle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Ciudad',
                controller: _cityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su ciudad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Código postal',
                controller: _zipcodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su código postal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const CustomLoading()
                  : CustomButton(
                      label: 'Crear Usuario', onPressed: _submitForm),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
