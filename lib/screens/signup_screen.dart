import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/common.dart';
import 'package:jumpvalues/models/signup_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/generate_otp_screen.dart';
import 'package:jumpvalues/screens/otp_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? companyController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? positionController;
  TextEditingController? aboutController;
  bool submitButtonEnabled = false;

  bool acceptTerms = false;
  bool loader = false;
  bool _obscureText = true;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    positionController = TextEditingController();
    aboutController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  enableSubmitButton() {
    if (firstNameController!.text.isNotEmpty &&
        lastNameController!.text.isNotEmpty &&
        emailController!.text.isNotEmpty &&
        companyController!.text.isNotEmpty &&
        passwordController!.text.isNotEmpty &&
        positionController!.text.isNotEmpty &&
        aboutController!.text.isNotEmpty) {
      setState(() {
        submitButtonEnabled = true;
      });
    } else {
      setState(() {
        submitButtonEnabled = false;
      });
    }
  }

  Future<void> signup() async {
    setState(() {
      loader = true;
    });

    Map<String, dynamic> request = {
      'firstName': firstNameController?.text,
      'lastName': lastNameController?.text,
      'email': emailController?.text,
      'password': passwordController?.text,
      'company': companyController?.text,
      'positions': positionController?.text,
      'aboutMe': aboutController?.text,
      'termsAndConditions': acceptTerms ? 'true' : 'false'
    };

    try {
      SignupResponseModel response = await signupUser(request);

      setState(() {
        loader = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          // for first time signup
          SnackBarHelper.showStatusSnackBar(
              context, StatusIndicator.success, response.message ?? '');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                email: emailController?.text ?? '',
                isFrom: 'signup',
              ),
            ),
          );
        } else {
          // if user already registered but not verified yet
          SnackBarHelper.showStatusSnackBar(
              context, StatusIndicator.success, response.message ?? '');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  GenerateOtpScreen(email: emailController?.text ?? ''),
            ),
          );
        }
      } else {
        // Handle null response
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response.message ?? 'Unexpected Error Occurred.');
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      // Handle other errors
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            if (loader) {
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
              );
            }
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: null,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          textFormField(
                              label: 'First Name',
                              autofocus: true,
                              controller: firstNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'))
                              ],
                              onChanged: (value) {
                                enableSubmitButton();
                              },
                              keyboardType: TextInputType.name,
                              hintText: 'Enter First Name',
                              textInputAction: TextInputAction.next),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                              label: 'Last Name',
                              controller: lastNameController,
                              onChanged: (value) {
                                enableSubmitButton();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]'))
                              ],
                              hintText: 'Enter Last Name',
                              textInputAction: TextInputAction.next),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'Email',
                            controller: emailController,
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter Email',
                            textInputAction: TextInputAction.next,
                            validator: (email) => validateEmail(email ?? ''),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'Company',
                            controller: companyController,
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            keyboardType: TextInputType.name,
                            hintText: 'Enter Company Name',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: passwordController,
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s'))
                            ],
                            cursorColor: Colors.grey,
                            obscureText:
                                _obscureText, // Use the _obscureText variable here
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(
                                color: hintColor,
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                              ),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 0, color: secondaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              errorStyle:
                                  const TextStyle(color: Color(0xffff3333)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xffff3333)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xffff3333)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 0, color: secondaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: secondaryColor,
                              focusColor: secondaryColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  // Toggle the obscureText state when the icon button is pressed
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) => passwordValidate(value ?? ''),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'Position',
                            controller: positionController,
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            keyboardType: TextInputType.name,
                            hintText: 'Enter Position',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'About Me',
                            controller: aboutController,
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            maxLines: 3,
                            hintText: 'Enter your bio',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: acceptTerms,
                              onChanged: (v) {
                                setState(() {
                                  acceptTerms = v ?? false;
                                });
                              }),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'By proceeding I agree to the ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms & Privacy Policy',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      button(context, onPressed: () async {
                        hideAppKeyboard(context);
                        if (loader) {
                        } else {
                          await signup();
                        }
                      },
                          isLoading: loader,
                          text: 'Sign Up',
                          isEnabled: submitButtonEnabled),
                    ],
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
