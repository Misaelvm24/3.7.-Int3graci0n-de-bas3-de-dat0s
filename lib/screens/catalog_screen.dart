import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_5/screens/movie_detail_screen.dart';
import 'package:flutter_application_5/services/firestore_service.dart';

class CatalogScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Películas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getMovies(), // Recupera datos desde Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Si está cargando, muestra el indicador
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Si hay un error, muestra un mensaje
            return Center(
              child: Text('Error al cargar el catálogo: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Si no hay datos, muestra un mensaje adecuado
            return Center(child: Text('No hay películas disponibles'));
          }

          var movies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              var movie = movies[index];
              var title = movie['title'] ?? 'Título no disponible';
              var imageUrl = movie['image'] ?? '';

              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, width: 50, height: 50)
                    : Icon(Icons.movie),
                title: Text(title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
