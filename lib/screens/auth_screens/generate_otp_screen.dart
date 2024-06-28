import 'package:flutter/material.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/auth_screens/otp_screen.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class GenerateOtpScreen extends StatefulWidget {
  const GenerateOtpScreen({super.key, required this.email});
  final String email;

  @override
  State<GenerateOtpScreen> createState() => _GenerateOtpScreenState();
}

class _GenerateOtpScreenState extends State<GenerateOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  bool submitButtonEnabled = false;

  bool loader = false;

  @override
  void initState() {
    emailController = TextEditingController(text: widget.email);
    enableSubmitButton();
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

  Future<void> sendOtp() async {
    setState(() {
      loader = true;
    });
    try {
      var request = {'email': emailController?.text};
      var response = await resendOtpForSignup(request);
      if (response?.statusCode == 200) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Successfully Sent to mail.');
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              email: emailController?.text ?? '',
              isFrom: 'signup',
            ),
          ),
        );
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('sendOtp Error: $e');
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
          title: null,
        ),
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
                          'Generate OTP',
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
                          'Please check mail to send OTP',
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
                        await sendOtp();
                      }
                    },
                        isLoading: loader,
                        text: 'Send OTP',
                        isEnabled: submitButtonEnabled),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
