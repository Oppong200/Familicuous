
import 'package:familicious/manager/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool isLoading=false;

  
  final AuthManager _authManager = AuthManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          //column wraps itself around a child
          //if the form is long, and since its unscrollable
          //you get a pixel overflow
          children: [
            const FlutterLogo(size: 130,),
            const SizedBox(height: 35,),

            Text(
              'Kindly check your email for the password reset link after submitting your email address',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),

            const SizedBox(height: 20,),
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

            isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () async {
                      if(_emailController.text.isNotEmpty && emailRegExp.hasMatch(_emailController.text)){

                        setState(() {
                          isLoading =true;
                        });
                        bool isSent = await _authManager.sendResetLink(_emailController.text);

                        setState(() {
                          isLoading=false;
                        });

                      //check whether sent is true
                      if(isSent){
                        //success

                        Fluttertoast.showToast(
                              msg: "Please check your email for password reset link",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          //move to homeview
                          Navigator.pop(context);
                      }else{
                        //error
                        Fluttertoast.showToast(
                              msg: _authManager.message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                      }
                      }else{
                        Fluttertoast.showToast(
                            msg: 'Email address is required',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).buttonTheme.colorScheme!.background,
                    ),
                    child: Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary,
                          ),
                    ),
                  ),
          ],
        ),
      )),
    );
  }
}