import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/auth_screens/login_screen.dart';
import 'package:jumpvalues/screens/auth_screens/update_password_screen.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email, required this.isFrom});
  final String email;
  final String isFrom;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController? otp;
  bool otpEnabled = false;
  bool loader = false;
  int count = 30;
  bool counting = false;
  late Timer _timer;

  @override
  void initState() {
    otp = TextEditingController();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    otp?.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      counting = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (count == 0) {
          timer.cancel();
          setState(() {
            counting = false;
          });
        } else {
          setState(() {
            count--;
          });
        }
      },
    );
  }

  Future<void> forgotPass() async {
    setState(() {
      loader = true;
    });

    try {
      var request = {'email': widget.email};
      var response = await forgotPassword(request);
      setState(() {
        loader = false;
      });
      if (response?.statusCode == 200) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Successfully Sent to mail.');
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      SnackBarHelper.showStatusSnackBar(
          context, StatusIndicator.error, e.toString());
      rethrow;
    }
  }

  Future<void> sendOtp() async {
    setState(() {
      loader = true;
    });

    try {
      var request = {'email': widget.email};
      var response = await resendOtpForSignup(request);
      setState(() {
        loader = false;
      });
      if (response?.statusCode == 200) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Successfully Sent to mail.');
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      SnackBarHelper.showStatusSnackBar(
          context, StatusIndicator.error, e.toString());
      rethrow;
    }
  }

  Future<void> verify() async {
    setState(() {
      loader = true;
    });

    try {
      var request = {'email': widget.email, 'OTP': otp?.text};
      var response = await verifyOtp(request);
      setState(() {
        loader = false;
      });
      if (response.statusCode == 200) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response.message ?? 'Verified Success');
        if (widget.isFrom == 'forgotPassword') {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UpdatePasswordScreen(email: widget.email)));
        } else if (widget.isFrom == 'signup') {
          await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response.message ?? 'Something went wrong');
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      SnackBarHelper.showStatusSnackBar(
          context, StatusIndicator.error, e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Image.asset(
                                'assets/images/blue_jump.png',
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              const Text(
                                'OTP Verification',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text:
                                          'Please enter the 4 digit OTP sent to \n',
                                      style: TextStyle(
                                        color: Color(0xFF494949),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.email,
                                      style: const TextStyle(
                                        color: Color(0xFF494949),
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' Edit',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).pop();
                                            },
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              textFormField(
                                label: 'OTP',
                                controller: otp,
                                maxLength: 4,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isNotEmpty && value.length == 4) {
                                      otpEnabled = true;
                                    } else {
                                      otpEnabled = false;
                                    }
                                  });
                                },
                                keyboardType: TextInputType.number,
                                hintText: 'Enter 4-Digit Code',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Did\'t received OTP ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: counting ? '$count' : 'Resend OTP',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (!counting) {
                                            if (widget.isFrom ==
                                                'forgotPassword') {
                                              await forgotPass();
                                            } else {
                                              await sendOtp();
                                            }
                                            setState(() {
                                              count = 30;
                                            });
                                            startTimer();
                                          }
                                        },
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        button(context, onPressed: () async {
                          hideKeyboard(context);
                          if (loader) {
                          } else {
                            await verify();
                          }
                        }, text: 'Verify OTP', isEnabled: otpEnabled),
                      ],
                    ),
                  ),
                ],
              ),
              if (loader)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
}
