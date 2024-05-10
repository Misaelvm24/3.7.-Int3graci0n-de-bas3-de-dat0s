import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMovies() {
    return _firestore.collection('movies').snapshots();
  }

  Future<void> addMovie(Map<String, dynamic> movieData) async {
    try {
      await _firestore.collection('movies').add(movieData);
    } catch (e) {
      print('Error al agregar la película: $e');
    }
  }

  Future<void> removeMovie(String movieId) async {
    try {
      await _firestore.collection('movies').doc(movieId).delete();
    } catch (e) {
      print('Error al eliminar la película: $e');
    }
  }
}
