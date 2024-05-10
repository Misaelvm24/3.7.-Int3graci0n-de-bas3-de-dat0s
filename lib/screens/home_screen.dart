import 'package:flutter/material.dart';
import 'package:flutter_application_5/screens/catalog_screen.dart';
import 'package:flutter_application_5/screens/login_screen.dart';
import 'package:flutter_application_5/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a MovieMania'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Lógica para cerrar sesión
              await _authService.signOut();
              // Regresar a la pantalla de inicio de sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen()), // Dirige a LoginScreen
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_authService.isUserLoggedIn()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CatalogScreen(), // Dirige a CatalogScreen
                    ),
                  );
                } else {
                  // Mostrar un mensaje si el usuario no está autenticado
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Acceso denegado'),
                      content: Text('Por favor, inicia sesión para continuar.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Ver Catálogo'), // Botón para ver el catálogo
            ),
          ],
        ),
      ),
    );
  }
}
