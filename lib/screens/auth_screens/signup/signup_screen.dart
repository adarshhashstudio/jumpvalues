import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/screens/utils/common.dart';
import 'package:jumpvalues/models/signup_categories.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/auth_screens/generate_otp_screen.dart';
import 'package:jumpvalues/screens/auth_screens/otp_screen.dart';
import 'package:jumpvalues/screens/auth_screens/signup/signup_widgets.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/screens/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? companyController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? positionController;
  TextEditingController? aboutController;
  TextEditingController? phoneNumberController;

  // FocusNodes for each field
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode aboutFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  // Map to store error messages for each field
  Map<String, String> fieldErrors = {};

  bool submitButtonEnabled = false;
  bool coachSubmitButtonEnabled = false;
  bool selectCategoriesError = false;
  String sPhoneNumber = '';
  String sCountryCode = '';

  List<SignupCategory> selectedCategories = [];

  bool acceptTerms = false;
  bool loader = false;
  bool _obscureText = true;
  int tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    companyController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    positionController = TextEditingController();
    aboutController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    phoneNumberController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    hideAppKeyboard(context);
    setState(() {
      submitButtonEnabled = false;
      coachSubmitButtonEnabled = false;
    });
    enableSubmitButton();
    enableCoachSubmitButton();
  }

  void showCategoryDialog(BuildContext context, List<SignupCategory> categories,
      Function(List<SignupCategory>) onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CategoryDialog(
          categories: categories,
          onConfirm: onConfirm,
          selectedCat: selectedCategories),
    );
  }

  enableSubmitButton() {
    // Client
    // if (firstNameController!.text.isNotEmpty &&
    //     lastNameController!.text.isNotEmpty &&
    //     emailController!.text.isNotEmpty &&
    //     companyController!.text.isNotEmpty &&
    //     passwordController!.text.isNotEmpty &&
    //     positionController!.text.isNotEmpty &&
    //     aboutController!.text.isNotEmpty &&
    //     acceptTerms) {
    //   setState(() {
    submitButtonEnabled = true;
    //   });
    // } else {
    //   setState(() {
    //     submitButtonEnabled = false;
    //   });
    // }
  }

  enableCoachSubmitButton() {
    // Coach
    if (firstNameController!.text.isNotEmpty &&
        lastNameController!.text.isNotEmpty &&
        emailController!.text.isNotEmpty &&
        passwordController!.text.isNotEmpty &&
        phoneNumberController!.text.isNotEmpty) {
      setState(() {
        coachSubmitButtonEnabled = true;
      });
    } else {
      setState(() {
        coachSubmitButtonEnabled = false;
      });
    }
  }

  Future<void> signup({required bool isCoach}) async {
    setState(() {
      loader = true;
      fieldErrors.clear(); // Clear previous errors
    });

    var request = <String, dynamic>{};

    if (isCoach) {
      request = {
        'firstName': firstNameController?.text,
        'lastName': lastNameController?.text,
        'email': emailController?.text,
        'password': passwordController?.text,
        // 'phonenumber': sPhoneNumber,
        // 'countryCode': sCountryCode,
        // 'categories': selectedCategories,
      };
    } else {
      request = {
        'firstName': firstNameController?.text,
        'lastName': lastNameController?.text,
        'email': emailController?.text,
        'password': passwordController?.text,
        'company': companyController?.text,
        'positions': positionController?.text,
        'aboutMe': aboutController?.text,
        'termsAndConditions': acceptTerms ? 'true' : 'false'
      };
    }

    try {
      var response = await signupUser(request);

      setState(() {
        loader = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null) {
          // for first time signup
          SnackBarHelper.showStatusSnackBar(
              context, StatusIndicator.success, response.message ?? '');
          await Navigator.of(context).push(
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
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  GenerateOtpScreen(email: emailController?.text ?? ''),
            ),
          );
        }
      } else {
        if (response.error?.length == 1) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response.error?[0].message ?? 'Unexpected Error Occurred.');
        } else {
          // Set field errors and focus on the first error field
          response.error?.forEach((e) {
            fieldErrors[e.field!] = e.message!;
          });

          // Focus on the first error field
          if (fieldErrors.containsKey('firstName')) {
            FocusScope.of(context).requestFocus(firstNameFocusNode);
          } else if (fieldErrors.containsKey('lastName')) {
            FocusScope.of(context).requestFocus(lastNameFocusNode);
          } else if (fieldErrors.containsKey('email')) {
            FocusScope.of(context).requestFocus(emailFocusNode);
          } else if (fieldErrors.containsKey('company')) {
            FocusScope.of(context).requestFocus(companyFocusNode);
          } else if (fieldErrors.containsKey('password')) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          } else if (fieldErrors.containsKey('positions')) {
            FocusScope.of(context).requestFocus(positionFocusNode);
          } else if (fieldErrors.containsKey('aboutMe')) {
            FocusScope.of(context).requestFocus(aboutFocusNode);
          }

          setState(() {});
        }
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      // Handle other errors
      SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, '$e');
    }
  }

  Widget buildClientForm(BuildContext context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    textFormField(
                      label: 'First Name',
                      autofocus: true,
                      controller: firstNameController,
                      focusNode: firstNameFocusNode,
                      errorText: fieldErrors['firstName'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      onChanged: (value) {
                        enableSubmitButton();
                      },
                      keyboardType: TextInputType.name,
                      hintText: 'Enter First Name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Last Name',
                      controller: lastNameController,
                      focusNode: lastNameFocusNode,
                      errorText: fieldErrors['lastName'],
                      onChanged: (value) {
                        enableSubmitButton();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      hintText: 'Enter Last Name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Email',
                      controller: emailController,
                      focusNode: emailFocusNode,
                      errorText: fieldErrors['email'],
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
                      focusNode: companyFocusNode,
                      errorText: fieldErrors['company'],
                      onChanged: (value) {
                        enableSubmitButton();
                      },
                      keyboardType: TextInputType.name,
                      hintText: 'Enter Company Name',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Password',
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      errorText: fieldErrors['password'],
                      onChanged: (value) {
                        enableSubmitButton();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Enter Password',
                      validator: (value) => passwordValidate(value ?? ''),
                      obscureText: _obscureText,
                      unHidePassword: (value) {
                        setState(() {
                          _obscureText = !value;
                        });
                      },
                      isPassword: true, // Set this to true for password fields
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Position',
                      controller: positionController,
                      focusNode: positionFocusNode,
                      errorText: fieldErrors['positions'],
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
                      focusNode: aboutFocusNode,
                      errorText: fieldErrors['aboutMe'],
                      onChanged: (value) {
                        enableSubmitButton();
                      },
                      maxLines: 3,
                      hintText: 'Enter your bio',
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
                const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 14),
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
                          enableSubmitButton();
                        }),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'By proceeding I agree to the ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      acceptTerms = !acceptTerms;
                                    });
                                    enableSubmitButton();
                                  }),
                            TextSpan(
                              text: 'Terms & Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WebViewScreen(
                                        url: termsAndPrivacyUrl,
                                      ),
                                    ),
                                  );
                                },
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 13,
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
                button(context, onPressed: () async {
                  hideAppKeyboard(context);
                  if (loader) {
                  } else {
                    await signup(isCoach: false);
                  }
                },
                    isLoading: loader,
                    text: 'Sign Up',
                    isEnabled: submitButtonEnabled),
              ],
            ),
          ),
        ],
      );

  Widget buildCoachForm(BuildContext context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    textFormField(
                      label: 'First Name',
                      autofocus: true,
                      controller: firstNameController,
                      focusNode: firstNameFocusNode,
                      errorText: fieldErrors['firstName'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.name,
                      hintText: 'Enter First Name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Last Name',
                      controller: lastNameController,
                      focusNode: lastNameFocusNode,
                      errorText: fieldErrors['lastName'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      hintText: 'Enter Last Name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Email',
                      controller: emailController,
                      focusNode: emailFocusNode,
                      errorText: fieldErrors['email'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
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
                      label: 'Password',
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      errorText: fieldErrors['password'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Enter Password',
                      validator: (value) => passwordValidate(value ?? ''),
                      obscureText: _obscureText,
                      unHidePassword: (value) {
                        setState(() {
                          _obscureText = !value;
                        });
                      },
                      isPassword: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    intlPhoneField(
                      label: 'Phone Number',
                      controller: phoneNumberController,
                      onChanged: (phoneNumber) {
                        setState(() {
                          sPhoneNumber = phoneNumber.number;
                          sCountryCode = phoneNumber.countryCode;
                        });
                        enableCoachSubmitButton();
                      },
                      validator: (phoneNumber) {
                        if (phoneNumber == null || phoneNumber.number.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    labelContainer(
                      label: 'Categories',
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 0.13,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      isError: selectCategoriesError,
                      borderRadius: selectedCategories.isEmpty
                          ? BorderRadius.circular(20)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                      onTap: () {
                        // Sample categories
                        var categories = <SignupCategory>[
                          SignupCategory(id: 1, name: 'Sports'),
                          SignupCategory(id: 2, name: 'Music'),
                          SignupCategory(id: 3, name: 'Movies'),
                          SignupCategory(id: 4, name: 'Books'),
                        ];
                        showCategoryDialog(context, categories,
                            (categoriesFromDialogue) {
                          setState(() {
                            selectedCategories = categoriesFromDialogue;
                            selectCategoriesError = false;
                            if (categoriesFromDialogue.isEmpty) {
                              selectCategoriesError = true;
                            }
                          });
                          for (var category in selectedCategories) {
                            debugPrint(
                                'Selected Category: ${category.name} (ID: ${category.id})');
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tap to select categories  ${selectedCategories.isEmpty ? '*' : ''}',
                            style: TextStyle(
                                color: selectCategoriesError
                                    ? Colors.red
                                    : textColor),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: selectCategoriesError ? Colors.red : black,
                          ),
                        ],
                      ),
                    ),
                    if (selectedCategories.isNotEmpty)
                      selectionContainerForAll(
                        context,
                        spaceBelowTitle:
                            MediaQuery.of(context).size.height * 0.02,
                        borderRadius: selectedCategories.isNotEmpty
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              )
                            : BorderRadius.circular(20),
                        children: [
                          for (var tone in selectedCategories)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF43A146),
                                  border: Border.all(width: 0.05),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                tone.name,
                                style: const TextStyle(color: white),
                              ),
                            ),
                        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: button(context, onPressed: () async {
              hideAppKeyboard(context);
              if (loader) {
              } else {
                if (selectedCategories.isEmpty) {
                  setState(() {
                    selectCategoriesError = true;
                  });
                } else {
                  await signup(isCoach: true);
                }
              }
            },
                isLoading: loader,
                text: 'Sign Up',
                isEnabled: coachSubmitButtonEnabled),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
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
            title: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                setState(() {
                  tabIndex = value;
                });
                _handleTabChange();
              },
              tabs: const [
                Tab(text: 'Client'),
                Tab(text: 'Coach'),
              ],
            ),
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
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildClientForm(context),
                    buildCoachForm(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
