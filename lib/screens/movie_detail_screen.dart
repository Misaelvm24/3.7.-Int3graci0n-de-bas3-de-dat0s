import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  MovieDetailScreen({required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  DocumentSnapshot? movieData;

  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  void _loadMovieData() async {
    var document = await FirebaseFirestore.instance
        .collection('movies')
        .doc(widget.movieId)
        .get();

    setState(() {
      movieData = document;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movieData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cargando...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!movieData!.exists) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Película no encontrada'),
        ),
        body: Center(
          child: Text('No se encontró información para esta película'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movieData!['title'] ?? 'Película'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movieData!['image'] != null && movieData!['image'].isNotEmpty)
              Image.network(movieData!['image']),
            SizedBox(height: 16),
            Text(
              'Título: ${movieData!['title']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (movieData!['year'] != null) Text('Año: ${movieData!['year']}'),
            SizedBox(height: 8),
            if (movieData!['director'] != null)
              Text('Director: ${movieData!['director']}'),
            SizedBox(height: 8),
            if (movieData!['genre'] != null)
              Text('Género: ${movieData!['genre']}'),
            SizedBox(height: 8),
            if (movieData!['synopsis'] != null)
              Text('Sinopsis: ${movieData!['synopsis']}'),
          ],
        ),
      ),
    );
  }
}
