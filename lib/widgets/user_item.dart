import 'package:filmfoliov2/models/app_user.dart';
import 'package:filmfoliov2/widgets/user_details_modal.dart';
import 'package:filmfoliov2/widgets/user_dialog_form.dart';
import 'package:flutter/material.dart';
class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.user,
    required this.onUpdateUserList
  });

  final AppUser user;
  final Function() onUpdateUserList;


  @override
  Widget build(BuildContext context) {

    void openUpdateUserDialog(){
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (ctx) => UserDialogForm(
          onUpdateUser: onUpdateUserList,
          mode: Mode.update,
          user: user,
        )
      );
    }

    void openUserDetailsDialog(){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
          ),
          builder: (ctx) => UserDetailsModal(user: user)
      );
    }


    return GestureDetector(
      onTap: openUserDetailsDialog,
      child: Card(
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
                      user.username!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      )
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: openUpdateUserDialog,
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit_rounded,
                          size: 16)
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(user.email!),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
