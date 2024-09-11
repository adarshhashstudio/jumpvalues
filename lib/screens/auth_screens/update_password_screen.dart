import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<UpdatePasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? newPassword;
  TextEditingController? confirmPassword;
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  bool _obscureText = true;
  bool submitButtonEnabled = false;
  String? confirmPasswordError;

  bool loader = false;
  Map<String, dynamic> fieldErrors = {};

  @override
  void initState() {
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPassword?.dispose();
    confirmPassword?.dispose();
    super.dispose();
  }

  Future<void> reset() async {
    setState(() {
      fieldErrors.clear();
      loader = true;
    });

    try {
      var request = {
        'email': widget.email,
        'new_password': newPassword?.text ?? '',
        'confirm_password': confirmPassword?.text ?? ''
      };
      var response = await resetPassword(request);
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Password Reset Successfully.');
        // Navigate to WelcomeScreen
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        if (response?.errors != null) {
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });

          if (fieldErrors.containsKey('new_password')) {
            FocusScope.of(context).requestFocus(newPasswordFocusNode);
          } else if (fieldErrors.containsKey('confirm_password')) {
            FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
          }
        } else {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('reset Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  void validatePassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        submitButtonEnabled = true;
      });
    } else {
      setState(() {
        submitButtonEnabled = false;
      });
    }
  }

  void validateConfirmPassword(String value) {
    if (value != newPassword?.text) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
        submitButtonEnabled = false;
      });
    } else {
      setState(() {
        confirmPasswordError = null;
        submitButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            CommonWidgets.appBar(context: context, backWidget: true, title: ''),
        body: Form(
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
                          'Update Password',
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
                          'Your new password must be different from previous password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF494949),
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'New Password',
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
                          controller: newPassword,
                          onChanged: (value) {
                            validateConfirmPassword(confirmPassword!.text);
                            validatePassword();
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
                          focusNode: newPasswordFocusNode,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Enter New Password',
                            hintStyle: TextStyle(
                              color: hintColor,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                            errorText: fieldErrors['new_password'],
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm Password',
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
                          controller: confirmPassword,
                          onChanged: validateConfirmPassword,
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
                          focusNode: confirmPasswordFocusNode,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Enter Confirm Password',
                            hintStyle: TextStyle(
                              color: hintColor,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                            errorText: fieldErrors['confirm_password'],
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
                          validator: (value) {
                            if (confirmPasswordError != null) {
                              return confirmPasswordError;
                            }
                            return null;
                          },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    button(context, onPressed: () async {
                      hideKeyboard(context);
                      if (loader) {
                      } else {
                        await reset();
                      }
                    },
                        isLoading: loader,
                        text: 'Reset Password',
                        isEnabled: submitButtonEnabled),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
