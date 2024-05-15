import 'package:flutter/material.dart';
import 'package:jumpvalues/common.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/dashbaord.dart';
import 'package:jumpvalues/screens/forgot_password_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;
  bool submitButtonEnabled = false;
  bool showPassword = false;
  bool _obscureText = true;
  bool loader = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  enableSubmitButton() {
    if (emailController!.text.isNotEmpty &&
        passwordController!.text.isNotEmpty) {
      setState(() {
        submitButtonEnabled = true;
      });
    } else {
      setState(() {
        submitButtonEnabled = false;
      });
    }
  }

  Future<void> login() async {
    setState(() {
      loader = true;
    });

    var request = <String, dynamic>{
      'email': emailController?.text,
      'password': passwordController?.text
    };

    try {
      var response = await loginUser(request);

      setState(() {
        loader = false;
      });

      if (response != null) {
        if (response.responseCode != null && response.responseCode == 200) {
          // Save token in SharedPreferences
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.token!);

          // Save user data in SharedPreferences
          await prefs.setString('userId', '${response.data?.id}');
          await prefs.setString('firstName', response.data?.firstName ?? '');
          await prefs.setString('lastName', response.data?.lastName ?? '');
          await prefs.setString('company', response.data?.company ?? '');
          await prefs.setString('email', response.data?.email ?? '');
          await prefs.setString('position', response.data?.positions ?? '');
          await prefs.setString('aboutMe', response.data?.aboutMe ?? '');
          await prefs.setString('profilePic', response.data?.profilePic ?? '');

          // Navigate to Dashboard
          await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Dashboard()));
        } else {
          // Handle missing token
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response.message ?? 'Token not found in response');
        }
      } else {
        // Handle null response
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.error, 'Unexpected error occurred.');
      }
    } catch (e) {
      setState(() {
        loader = false;
      });

      // Handle errors
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          children: [
                            Image.asset(
                              'assets/images/blue_jump.png',
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            const Text(
                              'Enter your details',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Ready to take your VALUES journey',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF494949),
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            textFormField(
                              label: 'Email',
                              autofocus: true,
                              controller: emailController,
                              onChanged: (value) {
                                enableSubmitButton();
                              },
                              validator: (value) => validateEmail(value ?? ''),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              hintText: 'Enter Email',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
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
                                  borderSide: BorderSide(
                                      width: 0, color: secondaryColor),
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
                                  borderSide: BorderSide(
                                      width: 0, color: secondaryColor),
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
                              onFieldSubmitted: (value) async {
                                if (emailController != null &&
                                    emailController!.text.isNotEmpty) {
                                  hideKeyboard(context);
                                  await login();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        button(context, isLoading: loader, onPressed: () async {
                          hideKeyboard(context);
                          await login();
                        }, text: 'Sign In', isEnabled: submitButtonEnabled),
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
