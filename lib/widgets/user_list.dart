import 'package:filmfoliov2/models/app_user.dart';
import 'package:filmfoliov2/widgets/user_item.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({
    super.key,
    required this.onRemoveUser,
    required this.users,
    required this.onUpdateUserList
  });

  final Function() onRemoveUser;
  final List<AppUser> users;
  final Function() onUpdateUserList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) =>
            Dismissible(
                // confirmDismiss: (direction) async {
                //   if (FirebaseAuth.instance.currentUser?.uid != movies[index].uid){
                //     ScaffoldMessenger.of(context).clearSnackBars();
                //     ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           duration: Duration(seconds: 2),
                //           content: Text("Deletion Prohibited! You cannot delete someone's post"),
                //         ));
                //     return false;
                //   }
                //   else{
                //     return true;
                //   }
                // },
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
                key: ValueKey(users[index]),
                onDismissed: (direction){
                  users[index].deleteUser();
                  onRemoveUser();
                },
                child: UserItem(
                  user: users[index],
                  onUpdateUserList: onUpdateUserList,
                )
            )
    );
  }
}
