import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/presentation/widgets/shared/index.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';

class SupportContactScreen extends StatelessWidget {
  const SupportContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Soporte y Contacto',
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contáctanos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Si tienes alguna pregunta o necesitas ayuda, no dudes en contactarnos a través de los siguientes medios:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Correo electrónico:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'support@mail.com',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'Teléfono:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '+1 234 567 890',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    'Dirección:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Calle 1, Ciudad, Medellín',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Formulario de Contacto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                labelText: 'Nombre',
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                labelText: 'Correo Electrónico',
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                labelText: 'Mensaje',
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  onPressed: () {},
                  label: 'Enviar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
