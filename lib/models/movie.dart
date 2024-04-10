import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmfoliov2/models/mixins/display_mixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final _firebase = FirebaseAuth.instance;
final CollectionReference movies = FirebaseFirestore.instance.collection('movies');

class Movie with DisplayMixin{
  Movie({
    this.title,
    this.year,
    this.genre,
    this.uid,
    this.movieId,
    this.context
  });

  final String? title;
  final String? year;
  final String? genre;
  final BuildContext? context;
  final String? movieId;
  final String? uid;

  factory Movie.fromMap(Map<String, dynamic> data, id) {
    return Movie(
      title: data['title'],
      year: data['year'],
      genre: data['genre'],
      movieId: id,
      uid: data['uid'],
    );
  }

  Future<void> addMovie() async {
    try{
      await movies.add({
        'title': title,
        'genre': genre,
        'year': year,
        'uid': _firebase.currentUser?.uid
      });
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> updateMovie() async {
    try{
      await movies.doc(movieId).update({
        'title': title,
        'genre': genre,
        'year': year
      });
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<void> deleteMovie() async {
    try{
      await movies.doc(movieId).delete();
    } on FirebaseAuthException catch(e){
      showError(
          errorMessage: e.message!,
          errorTitle: 'Database Error!'
      );
      return;
    }
  }

  Future<List<Movie>> getMovies() async {
    QuerySnapshot querySnapshot = await movies.get();
    final allMovies = querySnapshot.docs.map((doc) => Movie.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return allMovies;
  }
}