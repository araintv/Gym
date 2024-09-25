import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym/Components/Colors.dart';
import 'package:gym/Components/snackBar.dart';
import 'package:gym/Services/FirebaseServices.dart';
import 'package:gym/Ui/Main_Screen.dart';
import 'package:gym/Widgets/Button.dart';
import 'package:gym/Widgets/TextfieldInput.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController emailBTN = TextEditingController();
  TextEditingController passBTN = TextEditingController();
  bool haveAccount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/gymLogo.png'),
              Text(
                'Welcome Back!',
                style: TextStyle(color: AppColors().primaryColor, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputField_Widget(
                  context, 'Email', TextInputType.emailAddress, emailBTN),
              const SizedBox(
                height: 10,
              ),
              TextInputField_Widget(
                  context, 'Password', TextInputType.text, passBTN),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Button_Widget(context, haveAccount ? 'Log In' : 'Signup',
                    () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => MainScreen()));
                  if (emailBTN.text.isNotEmpty && passBTN.text.isNotEmpty) {
                    if (haveAccount) {
                      AuthService().signInWithEmailAndPassword(
                          context, emailBTN.text, passBTN.text);
                    } else {
                      AuthService().signUpWithEmailAndPassword(
                          context, emailBTN.text, passBTN.text);
                    }
                  } else {
                    CustomSnackBar(
                        context, Text('Please fill your credientials first.'));
                  }
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    haveAccount
                        ? 'Doe\'s not have account ?'
                        : 'Do you have an account ?',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (haveAccount == false) {
                        setState(() {
                          haveAccount = true;
                        });
                      } else {
                        setState(() {
                          haveAccount = false;
                        });
                      }
                    },
                    child: Text(
                      haveAccount ? 'Signup' : 'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: AppColors().primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
