import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/auth_screens/generate_otp_screen.dart';
import 'package:jumpvalues/screens/auth_screens/otp_screen.dart';
import 'package:jumpvalues/screens/auth_screens/signup/signup_widgets.dart';
import 'package:jumpvalues/screens/web_view_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
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
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? phoneNumberController;
  TextEditingController? educationController;
  TextEditingController? philosophyController;
  TextEditingController? certificationsController;
  TextEditingController? industriesServedController;
  TextEditingController? experianceController;
  TextEditingController? nicheController;

  TextEditingController? companyController;
  TextEditingController? positionController;
  TextEditingController? aboutController;

  // FocusNodes for each field
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode educationFocusNode = FocusNode();
  final FocusNode philosophyFocusNode = FocusNode();
  final FocusNode certificationsFocusNode = FocusNode();
  final FocusNode industriesServedFocusNode = FocusNode();
  final FocusNode experianceFocusNode = FocusNode();
  final FocusNode nicheFocusNode = FocusNode();

  final FocusNode companyFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode aboutFocusNode = FocusNode();

  // Map to store error messages for each field
  Map<String, String> fieldErrors = {};

  bool submitButtonEnabled = false;
  bool coachSubmitButtonEnabled = false;
  bool selectCategoriesError = false;
  String sPhoneNumber = '';
  String sCountryCode = '';

  List<Category> selectedCategories = [];
  List<Category> categories = [];

  bool acceptTerms = false;
  bool loader = false;
  bool initialLoader = false;
  bool _obscureText = true;
  int tabIndex = 0;

  List<String> preferViaList = ['Phone', 'Email'];
  String? selectedPreferVia;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    educationController = TextEditingController();
    philosophyController = TextEditingController();
    certificationsController = TextEditingController();
    industriesServedController = TextEditingController();
    experianceController = TextEditingController();
    nicheController = TextEditingController();

    companyController = TextEditingController();
    positionController = TextEditingController();
    aboutController = TextEditingController();

    super.initState();
    getCategoriesDropdown();
  }

  @override
  void dispose() {
    firstNameController?.dispose();
    lastNameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    phoneNumberController?.dispose();
    educationController?.dispose();
    philosophyController?.dispose();
    certificationsController?.dispose();
    industriesServedController?.dispose();
    experianceController?.dispose();
    nicheController?.dispose();

    companyController?.dispose();
    positionController?.dispose();
    aboutController?.dispose();

    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    educationFocusNode.dispose();
    philosophyFocusNode.dispose();
    certificationsFocusNode.dispose();
    industriesServedFocusNode.dispose();
    experianceFocusNode.dispose();
    nicheFocusNode.dispose();

    companyFocusNode.dispose();
    positionFocusNode.dispose();
    aboutFocusNode.dispose();

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

  void showCategoryDialog(BuildContext context, List<Category> categories,
      Function(List<Category>) onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CategoryDialog(
        categories: categories,
        onConfirm: onConfirm,
        selectedCat: categories.where((cat) => cat.isSelected).toList(),
      ),
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

  void enableCoachSubmitButton() {
    // Coach
    if (firstNameController!.text.isNotEmpty &&
        lastNameController!.text.isNotEmpty &&
        emailController!.text.isNotEmpty &&
        passwordController!.text.isNotEmpty &&
        phoneNumberController!.text.isNotEmpty &&
        educationController!.text.isNotEmpty &&
        philosophyController!.text.isNotEmpty &&
        certificationsController!.text.isNotEmpty &&
        industriesServedController!.text.isNotEmpty &&
        experianceController!.text.isNotEmpty &&
        nicheController!.text.isNotEmpty &&
        selectedPreferVia != null &&
        selectedCategories.isNotEmpty) {
      setState(() {
        coachSubmitButtonEnabled = true;
      });
    } else {
      setState(() {
        coachSubmitButtonEnabled = false;
      });
    }
  }

  Future<void> getCategoriesDropdown() async {
    setState(() {
      initialLoader = true;
    });

    try {
      var response = await categoriesDropdown();
      if (response?.status == true) {
        setState(() {
          categories.clear();
          categories = response?.data ?? [];
        });
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('categoriesDropdown Error: $e');
    } finally {
      setState(() {
        initialLoader = false;
      });
    }
  }

  Future<void> signup({required bool isCoach}) async {
    setState(() {
      loader = true;
      fieldErrors.clear(); // Clear previous errors
    });

    var request = <String, dynamic>{};
    List<int> selectedCategoriesId = [];
    selectedCategoriesId.addAll(
        selectedCategories.map((elemente) => elemente.id ?? -1).toList());

    if (isCoach) {
      request = {
        'firstName': firstNameController?.text,
        'lastName': lastNameController?.text,
        'email': emailController?.text,
        'password': passwordController?.text,
        'role': 'coach',
        'prefer_via': selectedPreferVia == 'Phone' ? 1 : 2,
        'philosophy': philosophyController?.text,
        'certifications': certificationsController?.text,
        'industries_served': industriesServedController?.text,
        'experiance': experianceController?.text,
        'niche': nicheController?.text,
        'categoryIds': selectedCategoriesId
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
            context,
            StatusIndicator.success,
            response.message ?? '',
          );
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
            context,
            StatusIndicator.success,
            response.message ?? '',
          );
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  GenerateOtpScreen(email: emailController?.text ?? ''),
            ),
          );
        }
      } else {
        if (response.error?.isNotEmpty ?? false) {
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
        } else {
          // Handle other errors
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.error,
            response.message ?? 'Unexpected Error Occurred.',
          );
        }
      }
    } catch (e) {
      debugPrint('signup Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                      labelTextBoxSpace: 8,
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
                    textFormField(
                      label: 'Education',
                      labelTextBoxSpace: 8,
                      controller: educationController,
                      focusNode: educationFocusNode,
                      errorText: fieldErrors['education'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Education',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    labelContainer(
                      label: 'Prefer Via',
                      labelTextBoxSpace: 8,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: DropdownButton<String>(
                        value: selectedPreferVia,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: Text(
                          'Select Preference',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                        items: preferViaList
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedPreferVia = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Philosophy',
                      labelTextBoxSpace: 8,
                      controller: philosophyController,
                      focusNode: philosophyFocusNode,
                      errorText: fieldErrors['philosophy'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Philosophy',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Certifications',
                      labelTextBoxSpace: 8,
                      controller: certificationsController,
                      focusNode: certificationsFocusNode,
                      errorText: fieldErrors['certifications'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Certifications',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Experiance',
                      labelTextBoxSpace: 8,
                      controller: experianceController,
                      focusNode: experianceFocusNode,
                      errorText: fieldErrors['experiance'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Experiance',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Niche',
                      labelTextBoxSpace: 8,
                      controller: nicheController,
                      focusNode: nicheFocusNode,
                      errorText: fieldErrors['niche'],
                      onChanged: (value) {
                        enableCoachSubmitButton();
                      },
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Niche',
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    labelContainer(
                      label: 'Categories',
                      labelTextBoxSpace: 8,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.06,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      isError: selectCategoriesError,
                      borderRadius: selectedCategories.isEmpty
                          ? BorderRadius.circular(20)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                      onTap: () {
                        hideKeyboard(context);
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
                                    : Colors.black),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: selectCategoriesError
                                ? Colors.red
                                : Colors.black,
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
                          for (var item in selectedCategories)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF43A146),
                                  border: Border.all(width: 0.05),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                item.name ?? '',
                                style: const TextStyle(color: Colors.white),
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
            child: Stack(
              children: [
                SafeArea(
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
                if (initialLoader)
                  const Positioned.fill(
                      child: Center(
                    child: CircularProgressIndicator(),
                  )),
              ],
            ),
          ),
        ),
      );
}
