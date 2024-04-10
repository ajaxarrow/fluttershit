import 'package:filmfoliov2/models/movie.dart';
import 'package:flutter/material.dart';

enum Mode {update, create}

class MovieDialogForm extends StatefulWidget {
  const MovieDialogForm({
    super.key,
    this.onAddMovie,
    this.onUpdateMovie,
    this.movie,
    this.mode
  });

  final void Function()? onAddMovie;
  final void Function()? onUpdateMovie;
  final Mode? mode;
  final Movie? movie;

  @override
  State<MovieDialogForm> createState() => _MovieDialogFormState();
}

class _MovieDialogFormState extends State<MovieDialogForm> {
  final _form = GlobalKey<FormState>();
  final movieTitleController = TextEditingController();
  final movieGenreController = TextEditingController();
  final movieYearController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.movie != null){
      movieYearController.text = widget.movie!.year!;
      movieTitleController.text = widget.movie!.title!;
      movieGenreController.text = widget.movie!.genre!;
    }

  }

  void addMovie(Movie movie) async{
    await movie.addMovie();
    widget.onAddMovie!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Movie Added!"),
    ));
  }

  void updateMovie(Movie movie) async{
    await movie.updateMovie();
    widget.onUpdateMovie!();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Movie Updated!"),
    ));
  }

  void submitMovie(){
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();
    final movie = Movie(
      title: movieTitleController.text,
      year: movieYearController.text,
      genre: movieGenreController.text,
      movieId: widget.movie?.movieId
    );
    if (widget.mode == Mode.create) {
      addMovie(movie);
    } else {
      updateMovie(movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 30
              ),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.mode == Mode.create
                              ? 'Add Movie'
                              : 'Update Movie',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_rounded))
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text('Title:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value){
                        if (value!.trim().isEmpty || value == null ){
                          return 'Title must not be empty';
                        }
                        return null;
                      },
                      controller: movieTitleController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.movie_filter),
                          hintText: 'Enter Movie Title'
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text('Year:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value){
                        if (value!.trim().isEmpty || value == null ){
                          return 'Year must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: movieYearController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range_rounded),
                          hintText: 'Enter Movie Year'
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text('Genre:', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value){
                        if (value!.trim().isEmpty || value == null ){
                          return 'Genre must not be empty';
                        }
                        return null;
                      },
                      controller: movieGenreController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.local_movies_outlined),
                          hintText: 'Enter Movie Genre'
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffdae2f3),
                                  padding: const EdgeInsets.symmetric(vertical: 19)
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff3b5ba9)
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 19)
                              ),
                              onPressed: submitMovie,
                              child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  )
                              )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
