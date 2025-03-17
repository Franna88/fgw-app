import 'package:farming_gods_way/CommonUi/Buttons/commonButton.dart';
import 'package:farming_gods_way/CommonUi/Input_Fields/labeledTextField.dart';
import 'package:farming_gods_way/CommonUi/Buttons/myTextButton.dart';
import 'package:farming_gods_way/Constants/myutility.dart';
import 'package:farming_gods_way/LandingPage/fgwLandingPage.dart';
import 'package:farming_gods_way/Sign_Ups/Farmer_Sign_Up/ui/signUpStructure.dart';
import 'package:flutter/material.dart';

class LoginDetails extends StatefulWidget {
  const LoginDetails({super.key});

  @override
  State<LoginDetails> createState() => _LoginDetailsState();
}

class _LoginDetailsState extends State<LoginDetails> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      // If validation passes, proceed with login logic
      print("Login Successful with Email: ${email.text}");
      // TODO: Implement actual login logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignUpStructure(
      isScrollable: false,
      header: 'Login',
      children: [
        SizedBox(height: MyUtility(context).height * 0.06),
        Form(
          key: _formKey,
          child: Column(
            children: [
              LabeledTextField(
                label: 'Email',
                hintText: '@',
                controller: email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              LabeledTextField(
                label: 'Password',
                hintText: '',
                controller: password,
                lines: 1,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Align(
            alignment: Alignment.centerRight,
            child: MyTextButton(
              text: 'Forgot Password?',
              onTap: () {},
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: CommonButton(
            customWidth: 120,
            buttonText: 'Login',
            onTap: () {
              _validateAndLogin;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FgwLandingPage()),
              );
            }, // Call validation method
          ),
        ),
        SizedBox(height: MyUtility(context).height * 0.06),
      ],
    );
  }
}
