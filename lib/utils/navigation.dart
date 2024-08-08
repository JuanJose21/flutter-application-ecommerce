import 'package:flutter/material.dart';

class Navigation {
  /// Navega a una nueva pantalla. Este método empuja una nueva ruta a la pila de navegación.
  ///
  /// Parámetros:
  /// - `context`: El contexto actual.
  /// - `screen`: El widget de la pantalla a la que se desea navegar.
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Navega hacia atrás en la pila de navegación. Este método elimina la ruta superior de la pila de navegación,
  /// volviendo a la pantalla anterior.
  ///
  /// Parámetros:
  /// - `context`: El contexto actual.
  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
