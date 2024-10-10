import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/network/rest_apis.dart';
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

  TextEditingController? firstNameControllerClient;
  TextEditingController? lastNameControllerClient;
  TextEditingController? emailControllerClient;
  TextEditingController? passwordControllerClient;
  TextEditingController? phoneNumberControllerClient;
  TextEditingController? positionControllerClient;
  TextEditingController? aboutControllerClient;

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

  final FocusNode firstNameClientFocusNode = FocusNode();
  final FocusNode lastNameClientFocusNode = FocusNode();
  final FocusNode emailClientFocusNode = FocusNode();
  final FocusNode passwordClientFocusNode = FocusNode();
  final FocusNode phoneNumberClientFocusNode = FocusNode();
  final FocusNode positionClientFocusNode = FocusNode();
  final FocusNode aboutMeClientFocusNode = FocusNode();

  // Map to store error messages for each field
  Map<String, dynamic> fieldErrors = {};
  Map<String, dynamic> fieldClientErrors = {};

  bool submitButtonEnabled = false;
  bool selectCategoriesError = false;
  bool selectCoreValuesError = false;

  String sPhoneNumber = '';
  String sCountryCode = '';

  String sPhoneNumberClient = '';
  String sCountryCodeClient = '';

  List<Category> selectedCategories = [];
  List<Category> categories = [];

  List<Category> selectedCoreValues = [];
  List<Category> coreValues = [];

  List<Category> sponsors = [];

  bool acceptTerms = false;
  bool loader = false;
  bool initialLoader = false;
  bool _obscureText = true;
  int tabIndex = 0;

  List<String> preferViaList = ['Phone', 'Email'];
  String? selectedPreferVia = 'Phone';

  Category? selectedSponsorId;
  final FocusNode selectedSponsorIdFocusNode = FocusNode();
  List<Category> categoriesBySponsorIds = [];
  List<Category> selectedCategoryBySponsorId = [];
  bool selectCategoriesBySponsorError = false;

  TextEditingController otherSponsorController = TextEditingController();
  final FocusNode otherSponsorFocusNode = FocusNode();
  bool isOtherSelected = false;
  String? otherSponsorErrorText;
  String? selectSponsorError;

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

    firstNameControllerClient = TextEditingController();
    lastNameControllerClient = TextEditingController();
    emailControllerClient = TextEditingController();
    passwordControllerClient = TextEditingController();
    phoneNumberControllerClient = TextEditingController();
    positionControllerClient = TextEditingController();
    aboutControllerClient = TextEditingController();

    super.initState();
    Future.wait([
      getSponsorDropdown(),
      getCategoriesDropdown(),
      getCoreValuesDropdown(),
    ]);
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

    firstNameControllerClient?.dispose();
    lastNameControllerClient?.dispose();
    emailControllerClient?.dispose();
    passwordControllerClient?.dispose();
    phoneNumberControllerClient?.dispose();
    positionControllerClient?.dispose();
    aboutControllerClient?.dispose();

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

    firstNameClientFocusNode.dispose();
    lastNameClientFocusNode.dispose();
    emailClientFocusNode.dispose();
    passwordClientFocusNode.dispose();
    phoneNumberClientFocusNode.dispose();
    positionClientFocusNode.dispose();
    aboutMeClientFocusNode.dispose();

    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    hideKeyboard(context);
  }

  void showCategoryDialog(BuildContext context, List<Category> categories,
      Function(List<Category>) onConfirm,
      {bool selectAllButton = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CategoryDialog(
        categories: categories,
        onConfirm: onConfirm,
        selectedCat: categories.where((cat) => cat.isSelected).toList(),
        selectAllButton: selectAllButton,
      ),
    );
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
          if (isOtherSelected) {
            categoriesBySponsorIds = response?.data ?? [];
          }
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

  Future<void> getCoreValuesDropdown() async {
    setState(() {
      initialLoader = true;
    });

    try {
      var response = await coreValuesDropdown();
      if (response?.status == true) {
        setState(() {
          coreValues.clear();
          coreValues = response?.data ?? [];
        });
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getCoreValuesDropdown Error: $e');
    } finally {
      setState(() {
        initialLoader = false;
      });
    }
  }

  Future<void> getSponsorDropdown() async {
    setState(() {
      initialLoader = true;
    });

    try {
      var response = await sponsorDropdown();
      if (response?.status == true) {
        setState(() {
          sponsors.clear();
          sponsors = response?.data ?? [];
        });
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('sponsorsDropdown Error: $e');
    } finally {
      setState(() {
        initialLoader = false;
      });
    }
  }

  Future<void> getCategoryBySponsorDropdown(String sponsorId) async {
    setState(() {
      initialLoader = true;
    });

    try {
      var response = await categoryBySponsorDropdown(sponsorId);
      if (response?.status == true) {
        setState(() {
          categoriesBySponsorIds = response?.data ?? [];
        });
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('sponsorsDropdown Error: $e');
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
      fieldClientErrors.clear();
    });

    var request = <String, dynamic>{};
    var selectedCategoriesId = <int>[];
    selectedCategoriesId
        .addAll(selectedCategories.map((element) => element.id ?? -1).toList());

    var selectedCoreValuesId = <int>[];
    selectedCoreValuesId
        .addAll(selectedCoreValues.map((element) => element.id ?? -1).toList());

    var requestSelectedCategoryBySponsorId = <int>[];
    requestSelectedCategoryBySponsorId.addAll(selectedCategoryBySponsorId
        .map((element) => element.id ?? -1)
        .toList());

    void addIfNotEmpty(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        request[key] = value;
      }
    }

    void addIfNotEmptyInt(String key, int? value) {
      if (value != null) {
        request[key] = value;
      }
    }

    void addIfNotEmptyList(String key, List<int>? value) {
      if (value != null && value.isNotEmpty) {
        request[key] = value;
      }
    }

    if (isCoach) {
      addIfNotEmpty('first_name', firstNameController?.text);
      addIfNotEmpty('last_name', lastNameController?.text);
      addIfNotEmpty('email', emailController?.text);
      addIfNotEmpty('password', passwordController?.text);
      request['role'] = 'coach';
      addIfNotEmpty('country_code', sCountryCode);
      addIfNotEmpty('phone', sPhoneNumber);
      addIfNotEmpty('education', educationController?.text);
      request['prefer_via'] = selectedPreferVia == 'Phone' ? 2 : 1;
      addIfNotEmpty('philosophy', philosophyController?.text);
      addIfNotEmpty('certifications', certificationsController?.text);
      addIfNotEmpty('industries_served', industriesServedController?.text);
      addIfNotEmpty('experiance', experianceController?.text);
      addIfNotEmpty('niche', nicheController?.text);
      addIfNotEmptyList('categoryIds', selectedCategoriesId);
      addIfNotEmptyList('coreValueIds', selectedCoreValuesId);
    } else {
      addIfNotEmpty('first_name', firstNameControllerClient?.text);
      addIfNotEmpty('last_name', lastNameControllerClient?.text);
      addIfNotEmpty('email', emailControllerClient?.text);
      addIfNotEmpty('password', passwordControllerClient?.text);
      addIfNotEmpty('country_code', sCountryCodeClient);
      addIfNotEmpty('phone', sPhoneNumberClient);
      request['role'] = 'client';
      addIfNotEmpty('position', positionControllerClient?.text);
      addIfNotEmpty('about_me', aboutControllerClient?.text);
      addIfNotEmptyInt('sponsor_id', selectedSponsorId?.id);
      addIfNotEmptyList('categoryIds', requestSelectedCategoryBySponsorId);
      // if (selectedSponsorId?.id != null && selectedSponsorId?.id == 0) {
      //   addIfNotEmpty('additional_sponsor', otherSponsorController.text);
      // }
      addIfNotEmpty(
          'additional_sponsor',
          otherSponsorController.text.isEmpty
              ? 'other'
              : otherSponsorController.text);
    }

    var endPoint = isCoach ? 'auth/coach/register' : 'auth/client/register';

    try {
      var response = await signupUser(request, endPoint);

      setState(() {
        loader = false;
      });

      if (response.status == true) {
        if (response.flag == 'SUCCESS') {
          // for first time signup
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.success,
            response.message ?? '',
          );
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                email: isCoach
                    ? emailController?.text ?? ''
                    : emailControllerClient?.text ?? '',
                isFrom: 'signup',
              ),
            ),
          );
        }
      } else {
        if (response.errors?.isNotEmpty ?? false) {
          if (isCoach) {
            // Set field errors and focus on the first error field
            response.errors?.forEach((e) {
              fieldErrors[e.field ?? '0'] = e.message ?? '0';
            });
            // Focus on the first error
            if (fieldErrors.containsKey('first_name')) {
              FocusScope.of(context).requestFocus(firstNameFocusNode);
            } else if (fieldErrors.containsKey('last_name')) {
              FocusScope.of(context).requestFocus(lastNameFocusNode);
            } else if (fieldErrors.containsKey('email')) {
              FocusScope.of(context).requestFocus(emailFocusNode);
            } else if (fieldErrors.containsKey('password')) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            } else if (fieldErrors.containsKey('phone')) {
              FocusScope.of(context).requestFocus(phoneNumberFocusNode);
            } else if (fieldErrors.containsKey('education')) {
              FocusScope.of(context).requestFocus(educationFocusNode);
            } else if (fieldErrors.containsKey('philosophy')) {
              FocusScope.of(context).requestFocus(philosophyFocusNode);
            } else if (fieldErrors.containsKey('certifications')) {
              FocusScope.of(context).requestFocus(certificationsFocusNode);
            } else if (fieldErrors.containsKey('industries_served')) {
              FocusScope.of(context).requestFocus(industriesServedFocusNode);
            } else if (fieldErrors.containsKey('experiance')) {
              FocusScope.of(context).requestFocus(experianceFocusNode);
            } else if (fieldErrors.containsKey('niche')) {
              FocusScope.of(context).requestFocus(nicheFocusNode);
            } else if (fieldErrors.containsKey('categoryIds')) {
              selectCategoriesError = true;
              SnackBarHelper.showStatusSnackBar(
                context,
                StatusIndicator.error,
                fieldErrors['categoryIds'] ?? 'Categories have some problem.',
              );
            } else if (fieldErrors.containsKey('coreValueIds')) {
              selectCoreValuesError = true;
              SnackBarHelper.showStatusSnackBar(
                context,
                StatusIndicator.error,
                fieldErrors['coreValueIds'] ?? 'Core Values have some problem.',
              );
            }
          } else {
            // Set field errors and focus on the first error field
            response.errors?.forEach((e) {
              fieldClientErrors[e.field ?? '0'] = e.message ?? '0';
            });
            // Focus on the first error
            if (fieldClientErrors.containsKey('first_name')) {
              FocusScope.of(context).requestFocus(firstNameClientFocusNode);
            } else if (fieldClientErrors.containsKey('last_name')) {
              FocusScope.of(context).requestFocus(lastNameClientFocusNode);
            } else if (fieldClientErrors.containsKey('email')) {
              FocusScope.of(context).requestFocus(emailClientFocusNode);
            } else if (fieldClientErrors.containsKey('password')) {
              FocusScope.of(context).requestFocus(passwordClientFocusNode);
            } else if (fieldClientErrors.containsKey('phone')) {
              FocusScope.of(context).requestFocus(phoneNumberClientFocusNode);
            } else if (fieldClientErrors.containsKey('position')) {
              FocusScope.of(context).requestFocus(positionClientFocusNode);
            } else if (fieldClientErrors.containsKey('about_me')) {
              FocusScope.of(context).requestFocus(aboutMeClientFocusNode);
            } else if (fieldClientErrors.containsKey('sponsor_id')) {
              FocusScope.of(context).requestFocus(selectedSponsorIdFocusNode);
            }
          }
        } else {
          // Handle other errors
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.error,
            response.message ?? 'Server Timeout, Please try after sometime.',
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
                      controller: firstNameControllerClient,
                      focusNode: firstNameClientFocusNode,
                      errorText: fieldClientErrors['first_name'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      onChanged: (value) {},
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
                      controller: lastNameControllerClient,
                      focusNode: lastNameClientFocusNode,
                      errorText: fieldClientErrors['last_name'],
                      onChanged: (value) {},
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
                      controller: emailControllerClient,
                      focusNode: emailClientFocusNode,
                      errorText: fieldClientErrors['email'],
                      onChanged: (value) {},
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter Email',
                      textInputAction: TextInputAction.next,
                      validator: (email) => validateEmail(email ?? ''),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Create Password',
                      labelTextBoxSpace: 8,
                      controller: passwordControllerClient,
                      focusNode: passwordClientFocusNode,
                      errorText: fieldClientErrors['password'],
                      onChanged: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Create Password',
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
                      label: 'Phone Number',
                      labelTextBoxSpace: 8,
                      controller: phoneNumberControllerClient,
                      focusNode: phoneNumberClientFocusNode,
                      errorText: fieldClientErrors['phone'],
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Text(
                          '+1',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      inputFormatters: [maskFormatter],
                      onChanged: (phoneNumber) {
                        setState(() {
                          sPhoneNumberClient = maskedTextToNumber(phoneNumber);
                          // sCountryCodeClient = phoneNumber.countryCode;
                          sCountryCodeClient = '+1';
                        });
                      },
                      validator: (phoneNumber) {
                        if (phoneNumber == null || phoneNumber.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Company',
                      labelTextBoxSpace: 8,
                      controller: otherSponsorController,
                      focusNode: otherSponsorFocusNode,
                      errorText: fieldClientErrors['additional_sponsor'] != null
                          ? fieldClientErrors['additional_sponsor']
                          : otherSponsorErrorText,
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Company',
                      textInputAction: TextInputAction.done,
                    ),
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          labelContainer(
                            label: 'Company Sponsor',
                            labelTextBoxSpace: 8,
                            width: MediaQuery.of(context).size.width * 1,
                            height: isOtherSelected
                                ? MediaQuery.of(context).size.height * 0.15
                                : MediaQuery.of(context).size.height * 0.06,
                            isError: selectSponsorError != null,
                            errorText: selectSponsorError,
                            child: Column(
                              children: [
                                DropdownButton<Category>(
                                  value: selectedSponsorId,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  focusNode: selectedSponsorIdFocusNode,
                                  hint: Text(
                                    'Select Sponsor',
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
                                  items: [
                                    ...sponsors.map((Category value) =>
                                        DropdownMenuItem<Category>(
                                          value: value,
                                          child: Text(value.name ?? ''),
                                        )),
                                    DropdownMenuItem<Category>(
                                      value:
                                          Category(id: 0, name: 'No Sponsor'),
                                      child: const Text('No Sponsor'),
                                    ),
                                  ],
                                  onChanged: (Category? value) async {
                                    setState(() {
                                      selectedSponsorId = value;
                                      isOtherSelected = (value?.id == 0);
                                      selectSponsorError = null;
                                    });
                                    // Backend sponsor selected
                                    categoriesBySponsorIds.clear();
                                    selectedCategoryBySponsorId.clear();
                                    if (!isOtherSelected &&
                                        selectedSponsorId != null) {
                                      try {
                                        await getCategoryBySponsorDropdown(
                                            selectedSponsorId!.id!.toString());
                                      } catch (e) {
                                        debugPrint(
                                            'Error fetching categories for sponsor: $e');
                                      }
                                    } else {
                                      await getCategoriesDropdown();
                                    }
                                  },
                                ),
                                if (isOtherSelected)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: textFormField(
                                        isLabel: false,
                                        label: '',
                                        controller: otherSponsorController,
                                        focusNode: otherSponsorFocusNode,
                                        errorText: otherSponsorErrorText,
                                        hintText: 'Enter company sponsor',
                                        onChanged: (v) {
                                          if (v.isNotEmpty) {
                                            setState(() {
                                              otherSponsorErrorText = null;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'This field is required.';
                                          }
                                          return null;
                                        },
                                        color: white),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          labelContainer(
                            label: 'Categories',
                            labelTextBoxSpace: 8,
                            isDisable: selectedSponsorId == null,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.06,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            isError: selectCategoriesBySponsorError,
                            borderRadius: selectedCategoryBySponsorId.isEmpty
                                ? BorderRadius.circular(20)
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                            onTap: () {
                              if (selectedSponsorId != null) {
                                hideKeyboard(context);
                                showCategoryDialog(
                                    context, categoriesBySponsorIds,
                                    (categoriesFromDialogue) {
                                  setState(() {
                                    selectedCategoryBySponsorId =
                                        categoriesFromDialogue;
                                    selectCategoriesBySponsorError = false;
                                    if (categoriesFromDialogue.isEmpty) {
                                      selectCategoriesBySponsorError = true;
                                    }
                                  });
                                  for (var category
                                      in selectedCategoryBySponsorId) {
                                    debugPrint(
                                        'Selected Category By Sponsor: ${category.name} (ID: ${category.id})');
                                  }
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tap to select categories',
                                  style: TextStyle(
                                      color: selectCategoriesBySponsorError
                                          ? Colors.red
                                          : Colors.black),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: selectCategoriesBySponsorError
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                          if (selectedCategoryBySponsorId.isNotEmpty)
                            selectionContainerForAll(
                              context,
                              spaceBelowTitle:
                                  MediaQuery.of(context).size.height * 0.02,
                              borderRadius:
                                  selectedCategoryBySponsorId.isNotEmpty
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        )
                                      : BorderRadius.circular(20),
                              children: [
                                for (var item in selectedCategoryBySponsorId)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF43A146),
                                        border: Border.all(width: 0.05),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      item.name ?? '',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'My Company Role',
                            labelTextBoxSpace: 8,
                            controller: positionControllerClient,
                            focusNode: positionClientFocusNode,
                            errorText: fieldClientErrors['position'],
                            onChanged: (value) {},
                            keyboardType: TextInputType.name,
                            hintText: 'Enter company role',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            label: 'About Me',
                            labelTextBoxSpace: 8,
                            controller: aboutControllerClient,
                            focusNode: aboutMeClientFocusNode,
                            errorText: fieldClientErrors['about_me'],
                            onChanged: (value) {},
                            maxLines: 3,
                            hintText: 'Enter your bio',
                          )
                        ],
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
                          if (acceptTerms) {
                            submitButtonEnabled = true;
                          } else {
                            submitButtonEnabled = false;
                          }
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
                                    if (acceptTerms) {
                                      submitButtonEnabled = true;
                                    } else {
                                      submitButtonEnabled = false;
                                    }
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
                  hideKeyboard(context);
                  // if (loader) {
                  // } else {
                  //   if (selectedSponsorId?.id == 0 &&
                  //       otherSponsorController.text.isEmpty) {
                  //     setState(() {
                  //       selectSponsorError = null;
                  //       FocusScope.of(context)
                  //           .requestFocus(otherSponsorFocusNode);
                  //       otherSponsorErrorText = 'This field is required';
                  //     });
                  //   } else {
                  //     setState(() {
                  //       otherSponsorErrorText = null;
                  //       selectSponsorError = null;
                  //     });
                  //     await signup(isCoach: false);

                  //     if (selectedSponsorId?.id == null) {
                  //       setState(() {
                  //         selectSponsorError = 'Sponsor selection is required.';
                  //       });
                  //     } else {
                  //       setState(() {
                  //         selectSponsorError = null;
                  //       });
                  //     }
                  //   }
                  // }
                  if (loader) {
                  } else {
                    // if (otherSponsorController.text.isEmpty) {
                    //   setState(() {
                    //     FocusScope.of(context)
                    //         .requestFocus(otherSponsorFocusNode);
                    //     otherSponsorErrorText = 'This field is required';
                    //   });
                    // } else {
                    setState(() {
                      otherSponsorErrorText = null;
                    });
                    await signup(isCoach: false);
                    // }
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
                      errorText: fieldErrors['first_name'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      onChanged: (value) {},
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
                      errorText: fieldErrors['last_name'],
                      onChanged: (value) {},
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
                      onChanged: (value) {},
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
                      onChanged: (value) {},
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
                    textFormField(
                      label: 'Phone Number',
                      labelTextBoxSpace: 8,
                      controller: phoneNumberController,
                      focusNode: phoneNumberFocusNode,
                      errorText: fieldErrors['phone'],
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Text(
                          '+1',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      inputFormatters: [maskFormatter],
                      onChanged: (phoneNumber) {
                        setState(() {
                          sPhoneNumber = maskedTextToNumber(phoneNumber);
                          // sCountryCode = phoneNumber.countryCode;
                          sCountryCode = '+1';
                        });
                      },
                      validator: (phoneNumber) {
                        if (phoneNumber == null || phoneNumber.isEmpty) {
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
                      onChanged: (value) {},
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
                      onChanged: (value) {},
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
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Certifications',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      label: 'Industries Served',
                      labelTextBoxSpace: 8,
                      controller: industriesServedController,
                      focusNode: industriesServedFocusNode,
                      errorText: fieldErrors['industries_served'],
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      hintText: 'Enter Industries Served',
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
                      onChanged: (value) {},
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
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
                      onChanged: (value) {},
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
                      errorText: fieldErrors['categoryIds'],
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
                            'Tap to select categories',
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
                    const SizedBox(
                      height: 20,
                    ),
                    labelContainer(
                      label: 'Core Values',
                      labelTextBoxSpace: 8,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.06,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      isError: selectCoreValuesError,
                      errorText: fieldErrors['coreValueIds'],
                      borderRadius: selectedCoreValues.isEmpty
                          ? BorderRadius.circular(20)
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                      onTap: () {
                        hideKeyboard(context);
                        showCategoryDialog(context, coreValues,
                            (categoriesFromDialogue) {
                          if (categoriesFromDialogue.length > 10) {
                            SnackBarHelper.showStatusSnackBar(
                                context,
                                StatusIndicator.error,
                                'Core Value must contain less than or equal to 10 items');
                          } else {
                            setState(() {
                              selectedCoreValues = categoriesFromDialogue;
                              selectCoreValuesError = false;
                              if (categoriesFromDialogue.isEmpty) {
                                selectCoreValuesError = true;
                              }
                            });
                            for (var category in selectedCoreValues) {
                              debugPrint(
                                  'Selected Core Values: ${category.name} (ID: ${category.id})');
                            }
                          }
                        }, selectAllButton: false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tap to select core values',
                            style: TextStyle(
                                color: selectCoreValuesError
                                    ? Colors.red
                                    : Colors.black),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: selectCoreValuesError
                                ? Colors.red
                                : Colors.black,
                          ),
                        ],
                      ),
                    ),
                    if (selectedCoreValues.isNotEmpty)
                      selectionContainerForAll(
                        context,
                        spaceBelowTitle:
                            MediaQuery.of(context).size.height * 0.02,
                        borderRadius: selectedCoreValues.isNotEmpty
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              )
                            : BorderRadius.circular(20),
                        children: [
                          for (var item in selectedCoreValues)
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
              hideKeyboard(context);
              if (loader) {
              } else {
                //       if (selectedCategories.isEmpty) {
                //         SnackBarHelper.showStatusSnackBar(
                //   context,
                //   StatusIndicator.error,
                //   'Please select categories',
                // );
                //         setState(() {
                //           selectCategoriesError = true;
                //         });
                //       } else {

                //       }
                await signup(isCoach: true);
              }
            }, isLoading: loader, text: 'Sign Up'),
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
