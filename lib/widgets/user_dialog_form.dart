import 'package:filmfoliov2/main.dart';
import 'package:filmfoliov2/models/app_user.dart';
import 'package:flutter/material.dart';

enum Mode{update, create}

class UserDialogForm extends StatefulWidget {
  const UserDialogForm({
    super.key,
    this.onAddUser,
    this.onUpdateUser,
    this.mode,
    this.user
  });


  final void Function()? onAddUser;
  final void Function()? onUpdateUser;
  final Mode? mode;
  final AppUser? user;

  @override
  State<UserDialogForm> createState() => _UserDialogFormState();
}

class _UserDialogFormState extends State<UserDialogForm> {
  final _form = GlobalKey<FormState>();
  bool showPassword = true;
  bool isRegister = true;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.user != null){
      emailController.text = widget.user!.email!;
      usernameController.text = widget.user!.username!;
      passwordController.text = widget.user!.password!;
    }
  }

  void resetForm(){
    _form.currentState!.reset();
    emailController.text = '';
    usernameController.text = '';
    passwordController.text = '';
  }

  Future<void> addUser(AppUser user) async{
    await user.register();
    widget.onAddUser;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("User Added!"),
    ));
  }

  Future<void> updateUser(AppUser user) async{
    await user.updateUser();
    widget.onUpdateUser;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("User Updated!"),
    ));
  }

  Future<void> submitUser() async {
    final isValid = _form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();

    if(widget.mode == Mode.create){
      final user = AppUser(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          context: context
      );
      await addUser(user);
      widget.onAddUser!();
    } else {
      final user = AppUser(
          uid: widget.user!.uid!,
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          context: context
      );
      await updateUser(user);
      widget.onUpdateUser!();
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
                      controller: usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Username',
                      ),
                      validator: (value){
                        if (value!.trim().isEmpty || value == null || value!.trim().length < 4  ){
                          return 'Username must atleast have 5 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                                showPassword ? Icons.visibility : Icons.visibility_off
                            ),
                            onPressed: (){
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                      ),
                      validator: (value){
                        if (value!.trim().isEmpty || value == null || value!.trim().length < 8  ){
                          return 'Password must atleast have 8 characters';
                        }
                        return null;
                      },
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
                              onPressed: submitUser,
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
