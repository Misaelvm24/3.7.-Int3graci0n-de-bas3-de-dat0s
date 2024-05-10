import 'package:flutter/material.dart';
import 'package:flutter_application_5/services/firestore_service.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _movieData =
      {}; // Donde se guardan los datos de la película

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Películas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _movieData['title'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Año'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el año';
                  }
                  return null;
                },
                onSaved: (value) {
                  _movieData['year'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Director'),
                onSaved: (value) {
                  _movieData['director'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Género'),
                onSaved: (value) {
                  _movieData['genre'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sinopsis'),
                onSaved: (value) {
                  _movieData['synopsis'] = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Imagen (URL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la URL de la imagen';
                  }

                  var uri =
                      Uri.tryParse(value); // Intenta analizar el valor como URI
                  if (uri == null || !uri.hasAbsolutePath) {
                    // Verifica que no sea null y tenga ruta absoluta
                    return 'Por favor, ingresa una URL válida';
                  }

                  return null; // No hay error
                },
                onSaved: (value) {
                  _movieData['image'] = value; // Guarda el valor
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _firestoreService.addMovie(_movieData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Película agregada')),
                    );
                  }
                },
                child: Text('Agregar Película'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para eliminar películas si es necesario
                },
                child: Text('Eliminar Película'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
