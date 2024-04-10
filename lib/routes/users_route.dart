import 'package:filmfoliov2/widgets/user_dialog_form.dart';
import 'package:filmfoliov2/widgets/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';

class UsersRoute extends StatefulWidget {
  const UsersRoute({super.key});

  @override
  State<UsersRoute> createState() => _UsersRouteState();
}

class _UsersRouteState extends State<UsersRoute> {
  List<AppUser> _users = [];
  final user = AppUser();

  Future<void> fetchUsers() async{
    _users.clear();
    _users = await user.getUsers();

  }

  void _refreshList(){
    setState(() {

    });
  }

  void _openUserDialogForm(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (ctx) => UserDialogForm(
          mode: Mode.create,
          onAddUser: _refreshList,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUsers(),
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
                      'There are no available users found. Try adding some!'
                  )
                ],
              ),
            );

            if (_users.isNotEmpty) {
              mainContent = UserList(
                  onRemoveUser: _refreshList,
                  users: _users,
                  onUpdateUserList: _refreshList
              );
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height:  10),
                _users.isNotEmpty ?  Padding(
                  padding: const EdgeInsets.only(left:  15, top:  5, bottom:  5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Users',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize:  23
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          AppUser().deleteUserAccount();
                        },
                        child: const Text('Delete Current Account')
                      )
                    ],
                  )
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
                'users',
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
              onPressed: _openUserDialogForm,
              child: Icon(Icons.add),
            ),
          );
        }
    );
  }
}
