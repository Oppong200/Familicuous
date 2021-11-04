
import 'package:familicious/manager/auth_manager.dart';
import 'package:familicious/views/auth/create_account_view.dart';
import 'package:familicious/views/auth/forgot_password_view.dart';
import 'package:familicious/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isLoading = false;
  final AuthManager _authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const FlutterLogo(
                  size: 130,
                ),
                const SizedBox(
                  height: 35,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Email is invalid';
                    }
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    label: Text(
                      'Password',
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password should be 8 characters or more';
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ForgotPasswordView())),
                    child: const Text(
                      'Forgot password? Reset here!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //all good
                            setState(() {
                              isLoading = true;
                            });
                            bool isSuccessful = await _authManager.loginUser(email: _emailController.text, password: _passwordController.text);
                            setState(() {
                              isLoading = false;
                            });
                            if(isSuccessful){
                              //move to homepage
                              Fluttertoast.showToast(
                                  msg: "Welcome back to Familicious",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              //move to homeview
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeView()),
                                  (route) => false);
                            }else{
                              //error validation
                              Fluttertoast.showToast(
                                  msg: _authManager.message,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                          else{
                            //error on validation
                            Fluttertoast.showToast(
                                msg: 'Error on validation',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background,
                        ),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                              ),
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CreateAccountView())),
                    child: const Text(
                      'No account? Create account here!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
