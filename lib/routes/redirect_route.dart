import 'package:filmfoliov2/routes/auth_route.dart';
import 'package:filmfoliov2/routes/movies_route.dart';
import 'package:filmfoliov2/routes/users_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RedirectRoute extends StatelessWidget {
  const RedirectRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot){
        if (snapshot.hasData) {
          return const UsersRoute();
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else{
          return const AuthRoute();
        }
      }
    );
  }
}
