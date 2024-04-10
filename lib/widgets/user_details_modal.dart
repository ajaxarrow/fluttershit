import 'package:filmfoliov2/models/app_user.dart';
import 'package:flutter/material.dart';

class UserDetailsModal extends StatelessWidget {
  const UserDetailsModal({super.key, required this.user});

  final AppUser user;

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
              child: Column(
                children: [
                  Text('User Details',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Name: ${user.username}'),
                  Text('Email: ${user.email}'),
                ],
              )
            ),
          )
      ),
    );

  }
}
