import 'package:filmfoliov2/models/movie.dart';
import 'package:filmfoliov2/widgets/movie_dialog_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.movie,
    required this.onUpdateMovieList
  });

  final Movie movie;
  final Function() onUpdateMovieList;

  @override
  Widget build(BuildContext context) {

    void _openUpdateMoviesModal(){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
          builder: (ctx) => MovieDialogForm(
            onUpdateMovie: onUpdateMovieList,
            mode: Mode.update,
            movie: movie,
          )
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    movie.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    )
                ),
                const Spacer(),
                FirebaseAuth.instance.currentUser?.uid == movie.uid ? TextButton.icon(
                    onPressed: _openUpdateMoviesModal,
                    label: const Text('Edit'),
                    icon: const Icon(Icons.edit_rounded,
                        size: 16)
                ) : Container()
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(movie.year!),
                const Spacer(),
                Text(movie.genre!)
              ],
            )
          ],
        ),
      ),
    );
  }
}
