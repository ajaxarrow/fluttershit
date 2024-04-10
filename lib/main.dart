import 'package:filmfoliov2/firebase_options.dart';
import 'package:filmfoliov2/routes/auth_route.dart';
import 'package:filmfoliov2/routes/movies_route.dart';
import 'package:filmfoliov2/routes/redirect_route.dart';
import 'package:filmfoliov2/routes/users_route.dart';
import 'package:filmfoliov2/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/redirect',
      routes: {
        '/redirect': (context) => const RedirectRoute(),
        '/auth': (context) => const AuthRoute(),
        '/chat': (context) => const MoviesRoute(),
        '/users': (context) => const UsersRoute(),
      },
    );
  }
}
