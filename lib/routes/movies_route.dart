import 'package:filmfoliov2/models/movie.dart';
import 'package:filmfoliov2/widgets/movie_dialog_form.dart';
import 'package:filmfoliov2/widgets/movie_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MoviesRoute extends StatefulWidget {
  const MoviesRoute({super.key});

  @override
  State<MoviesRoute> createState() => _MoviesRouteState();
}

class _MoviesRouteState extends State<MoviesRoute> {
  List<Movie> _movies = [];
  final movie = Movie();

  Future<void> fetchMovies() async {
    _movies.clear();
    _movies = await movie.getMovies();
  }

  void _addMovie(){
    setState(() {

    });
  }

  void _updateMovie(){
    setState(() {

    });
  }

  void _removeMovie(String id) async{
    await Movie(movieId: id).deleteMovie();
    setState(() {

    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Movie Deleted!"),
        )
    );
  }

  void _openMovieFormModal(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (ctx) => MovieDialogForm(mode: Mode.create, onAddMovie: _addMovie)
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchMovies(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = Container(
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OOPS!',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize:  50
                    ),
                  ),
                  SizedBox(height:  5),
                  Text(
                      'There are no available movies found. Try adding some!'
                  )
                ],
              ),
            );

            if (_movies.isNotEmpty) {
              mainContent = MovieList(
                onRemoveMovie: _removeMovie,
                movies: _movies,
                onUpdateMovieList: _updateMovie,
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _movies.isNotEmpty ? const Padding(
                  padding: EdgeInsets.only(left:  15, top:  5, bottom:  5),
                  child: Text(
                    'Movies',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize:  23
                    ),
                  ),
                ) : SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xff051650),
              title: const Text(
                'filmfolio.',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize:  24
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      size:  25,
                    )
                )
              ],
            ),
            body: body,
            floatingActionButton: FloatingActionButton(
              onPressed: _openMovieFormModal,
              child: Icon(Icons.add),
            ),
          );
        }
    );
  }
}
