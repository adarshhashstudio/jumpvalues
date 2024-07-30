import 'package:flutter/material.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/auth_screens/otp_screen.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  final FocusNode emailFocusNode = FocusNode();
  bool submitButtonEnabled = false;

  bool loader = false;

  Map<String, dynamic> fieldErrors = {};

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    super.dispose();
  }

  enableSubmitButton() {
    if (emailController!.text.isNotEmpty &&
        validateEmail(emailController!.text) == null) {
      setState(() {
        submitButtonEnabled = true;
      });
    } else {
      setState(() {
        submitButtonEnabled = false;
      });
    }
  }

  Future<void> forgotPass() async {
    setState(() {
      fieldErrors.clear();
      loader = true;
    });

    try {
      var request = {'email': emailController?.text ?? ''};
      var response = await forgotPassword(request);
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Successfully Sent to mail.');
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpScreen(
                  email: emailController?.text ?? '',
                  isFrom: 'forgotPassword',
                )));
      } else {
        if (response?.errors != null) {
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });

          if (fieldErrors.containsKey('email')) {
            SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
                fieldErrors['email'] ?? errorSomethingWentWrong);
            FocusScope.of(context).requestFocus(emailFocusNode);
          }
        } else {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('forgotPass Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
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
                            'Enter your email',
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
                            'Please check mail to change password',
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
                            focusNode: emailFocusNode,
                            errorText: fieldErrors['email'],
                            onChanged: (value) {
                              enableSubmitButton();
                            },
                            validator: (value) => validateEmail(value ?? ''),
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter Email',
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
                        hideAppKeyboard(context);
                        if (loader) {
                        } else {
                          await forgotPass();
                        }
                      },
                          isLoading: loader,
                          text: 'Forgot Password',
                          isEnabled: submitButtonEnabled),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
