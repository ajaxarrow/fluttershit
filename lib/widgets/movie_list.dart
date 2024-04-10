import 'package:filmfoliov2/models/movie.dart';
import 'package:filmfoliov2/widgets/movie_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    super.key,
    required this.onRemoveMovie,
    required this.movies,
    required this.onUpdateMovieList
  });

  final void Function(String id) onRemoveMovie;
  final List<Movie> movies;
  final Function() onUpdateMovieList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                confirmDismiss: (direction) async {
                  if (FirebaseAuth.instance.currentUser?.uid != movies[index].uid){
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text("Deletion Prohibited! You cannot delete someone's post"),
                        ));
                    return false;
                  }
                  else{
                    return true;
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.error.withOpacity(0.85),
                  ),

                  margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16

                  ),

                ),
                key: ValueKey(movies[index]),
                onDismissed: (direction){
                  onRemoveMovie(movies[index].movieId!);
                },
                child: MovieItem(
                  movie: movies[index],
                  onUpdateMovieList: onUpdateMovieList,
                )
            )
    );
  }
}
