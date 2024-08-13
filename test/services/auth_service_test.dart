import 'package:flutter_application_ecommerce/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthService authService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    authService = AuthService();
  });

  group('AuthService', () {
    test('Debe guardar el token correctamente', () async {
      const testToken = 'test_token';
      await authService.saveToken(testToken);

      final storedToken = await authService.getUserToken();
      expect(storedToken, equals(testToken));
    });

    test('Debe obtener el token guardado', () async {
      const testToken = 'test_token';
      await authService.saveToken(testToken);

      final token = await authService.getUserToken();
      expect(token, testToken);
    });

    test('Debe devolver null si no hay token guardado', () async {
      final token = await authService.getUserToken();
      expect(token, isNull);
    });

    test('Debe eliminar el token al cerrar sesión', () async {
      const testToken = 'test_token';
      await authService.saveToken(testToken);

      await authService.logoutUser();
      final token = await authService.getUserToken();
      expect(token, isNull);
    });
  });
}
