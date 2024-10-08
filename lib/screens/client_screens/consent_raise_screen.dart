import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/models/question_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:nb_utils/nb_utils.dart';

class ConsentRaiseScreen extends StatefulWidget {
  const ConsentRaiseScreen({super.key});

  @override
  State<ConsentRaiseScreen> createState() => _ConsentRaiseScreenState();
}

class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ConsentQuestionResponse? consentQuestionResponse;
  Map<int, dynamic> answers = {};
  Map<int, dynamic> goalAnswer = {};

  bool loading = false;
  // TextEditing Controllers
  TextEditingController? companyNameController;
  TextEditingController? contactNameController;
  TextEditingController? jobTitleController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  TextEditingController? descriptionController;

  // FocusNodes for each field
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode contactNameFocusNode = FocusNode();
  final FocusNode jobTitleFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  // Dropdown values for Company Size
  String? selectedCompanySize;
  List<String> companySizeList = [
    'Under 100 Employees',
    '101-250 Employees',
    '251-750 Employees',
    '751-999 Employees',
    '1,000+ Employees'
  ];

  String sPhoneNumber = '';
  String sCountryCode = '';

//   // Map to store error messages for each field
  Map<String, dynamic> fieldErrors = {};

// Store selected boolean values for each question by question ID
  // Map<int, bool?> selectedBooleanValues = {};
  Map<int, List<int>> selectedMultiSelectValues = {};
  // For multi-select dropdowns

  List<Category> sponsors = [];

  bool buttonLoad = false;

  Category? selectedSponsorId;
  bool isOtherSelected = false;
  String? otherSponsorErrorText;
  String? selectSponsorError;
  String? otherGoalString;
  final FocusNode selectedSponsorIdFocusNode = FocusNode();

  TextEditingController otherSponsorController = TextEditingController();
  final FocusNode otherSponsorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    companyNameController = TextEditingController();
    contactNameController = TextEditingController();
    jobTitleController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    descriptionController = TextEditingController();
    getGoalsDropdown();
    // Fetch questions API
    consentQuestionsApi();
  }

  @override
  void dispose() {
    companyNameController?.dispose();
    contactNameController?.dispose();
    jobTitleController?.dispose();
    emailController?.dispose();
    phoneNumberController?.dispose();
    descriptionController?.dispose();

    super.dispose();
  }

  Future<void> getGoalsDropdown() async {
    setState(() {
      loading = true;
    });

    try {
      var response = await goalsDropdown();
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
        loading = false;
      });
    }
  }

  Future<void> consentQuestionsApi() async {
    debugPrint('consentQuestionsApi: Fetching data...');
    setState(() {
      loading = true;
    });
    try {
      var response = await consentQuestions();
      debugPrint('consentQuestionsApi: Data fetched successfully');

      if (response?.status == true) {
        setState(() {
          consentQuestionResponse = response;
          debugPrint('consentQuestionsApi: Data set in state');
        });
      } else {
        debugPrint('consentQuestionsApi: Error response from API');
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('consentQuestionsApi error: $e');
    } finally {
      setState(() {
        loading = false;
        debugPrint('consentQuestionsApi: Loading set to false');
      });
    }
  }

// String generateJson() {
//         int companysizez;
//     if (selectedCompanySize == 'Under 100 Employees') {
//       companysizez = 0;
//     } else if (selectedCompanySize == '101-250 Employees') {
//       companysizez = 1;
//     } else if (selectedCompanySize == '251-750 Employees') {
//       companysizez = 2;
//     } else if (selectedCompanySize == '751-999 Employees') {
//       companysizez = 3;
//     } else if (selectedCompanySize == '1,000+ Employees') {
//       companysizez = 4;
//     } else {
//       companysizez = 0; // Default case
//     }

//   List<Map<String, dynamic>> questions = [];
//   answers.forEach((questionId, answer) {
//     bool isGoal = (answer is List && answer.contains(0)); // Check for "other" goal

//     Map<String, dynamic> questionData = {
//       "question_id": questionId.toString(),
//       "answers": answer is List ? answer.map((e) => e is bool ? (e ? 1 : 0) : e).toList() : [answer],
//       "is_goal": isGoal,
//     };

//     if (isGoal) {
//       questionData["other_goals"] = goalAnswer[questionId] ?? "";
//     }

//     questions.add(questionData);
//   });

//   Map<String, dynamic> jsonData = {
//     "email": emailController?.text ?? "",
//     "country_code": sCountryCode,
//     "phone": sPhoneNumber ?? "",
//     "contact_name": contactNameController?.text ?? "",
//     "company_name": companyNameController?.text ?? "",
//     "company_size": companysizez,
//     "contact_job_title": jobTitleController?.text ?? "",
//     "questions": questions,
//   };

//   return jsonEncode(jsonData);
// }
// String generateJson() {
//   int companySize;

//   // Determine company size based on selected value
//   if (selectedCompanySize == 'Under 100 Employees') {
//     companySize = 0;
//   } else if (selectedCompanySize == '101-250 Employees') {
//     companySize = 1;
//   } else if (selectedCompanySize == '251-750 Employees') {
//     companySize = 2;
//   } else if (selectedCompanySize == '751-999 Employees') {
//     companySize = 3;
//   } else if (selectedCompanySize == '1,000+ Employees') {
//     companySize = 4;
//   } else {
//     companySize = 0; // Default case
//   }

//   // Create a list to hold question data
//   List<Map<String, dynamic>> questions = [];

//   // Iterate over answers
//   answers.forEach((questionId, answer) {
//     bool isGoal = (answer is List && answer.contains(0)); // Check if it's a goal with "Other"

//     Map<String, dynamic> questionData = {
//       "question_id": questionId.toString(),
//       "is_goal": isGoal,
//     };

//     // Handle different answer cases
//     if (answer is List) {
//       if (answer.length == 1) {
//         var singleAnswer = answer[0];

//         // Handle Boolean type
//         if (singleAnswer is bool) {
//           questionData["answers"] = singleAnswer ? '0' : '1'; // Convert to 1/0 for true/false
//         }
//         // Handle String type
//         else if (singleAnswer is String) {
//           questionData["answers"] = singleAnswer; // Single text answer
//         }
//         // Handle other types (e.g., int)
//         else {
//           questionData["answers"] = singleAnswer; // Single number answer
//         }
//       } else {
//         // More than one answer, keep it as a list
//         questionData["answers"] = answer.map((e) => e is bool ? (e ? 1 : 0) : e).toList();
//       }
//     } else {
//       // If the answer is a single boolean, number, or string, handle it accordingly
//       if (answer is bool) {
//         questionData["answers"] = answer ? '0' : '1'; // Convert to 1/0 for true/false
//       } else {
//         questionData["answers"] = answer; // For text or number, assign directly
//       }
//     }

//     // Add "other_goals" if it's a goal with "Other" selected
//     if (isGoal) {
//       questionData["other_goals"] = goalAnswer[questionId] ?? "";
//     }

//     // Add this question data to the questions list
//     questions.add(questionData);
//   });
  String generateJson() {
    int companySize;

    // Determine company size based on selected value
    if (selectedCompanySize == 'Under 100 Employees') {
      companySize = 0;
    } else if (selectedCompanySize == '101-250 Employees') {
      companySize = 1;
    } else if (selectedCompanySize == '251-750 Employees') {
      companySize = 2;
    } else if (selectedCompanySize == '751-999 Employees') {
      companySize = 3;
    } else if (selectedCompanySize == '1,000+ Employees') {
      companySize = 4;
    } else {
      companySize = 0; // Default case
    }

    // Create a list to hold question data
    List<Map<String, dynamic>> questions = [];

    // Iterate over answers
    answers.forEach((questionId, answer) {
      bool isGoal = (answer is List &&
          answer.contains(0)); // Check if it's a goal with "Other"

      Map<String, dynamic> questionData = {
        "question_id": questionId.toString(),
        "is_goal": isGoal,
      };

      // Handle different answer cases
      if (answer is List) {
        if (answer.length == 1) {
          var singleAnswer = answer[0];

          // Handle Boolean type
          if (singleAnswer is bool) {
            questionData["answers"] =
                singleAnswer ? '0' : '1'; // Convert to 1/0 for true/false
          }
          // Handle String type
          else if (singleAnswer is String) {
            questionData["answers"] = singleAnswer; // Single text answer
          }
          // Handle other types (e.g., int)
          else {
            questionData["answers"] = singleAnswer; // Single number answer
          }
        } else {
          // More than one answer, process the list
          List answersList =
              answer.map((e) => e is bool ? (e ? 1 : 0) : e).toList();

          // If it's a goal and contains 0, remove 0 from the list
          if (isGoal && answersList.contains(0)) {
            answersList.removeWhere((element) => element == 0);
          }

          questionData["answers"] = answersList;
        }
      } else {
        // If the answer is a single boolean, number, or string, handle it accordingly
        if (answer is bool) {
          questionData["answers"] =
              answer ? '0' : '1'; // Convert to 1/0 for true/false
        } else {
          questionData["answers"] =
              answer; // For text or number, assign directly
        }
      }

      // Add "other_goals" if it's a goal with "Other" selected
      if (isGoal) {
        questionData["other_goals"] = goalAnswer[questionId] ?? "";
      }

      // Add this question data to the questions list
      questions.add(questionData);
    });

    // Create the final JSON data
    Map<String, dynamic> jsonData = {
      "email": emailController?.text ?? "",
      "country_code": sCountryCode,
      "phone": sPhoneNumber ?? "",
      "contact_name": contactNameController?.text ?? "",
      "company_name": companyNameController?.text ?? "",
      "company_size": companySize,
      "contact_job_title": jobTitleController?.text ?? "",
      "questions": questions,
    };

    return jsonEncode(jsonData); // Return the encoded JSON string
  }

  void _submitForm() async {
    // final submissionData = {
    //   'email': emailController?.text,
    //   'country_code': sCountryCode,
    //   'phone': sPhoneNumber,
    //   'contact_name': contactNameController?.text ?? '',
    //   'company_name': companyNameController?.text ?? '',
    //   'company_size': companysizez,
    //   'contact_job_title': jobTitleController?.text ?? '',
    //   'questions': answers.entries.map((entry) {
    //     bool isGoal = false;
    //     String otherGoals = '';

    //     // Check if the entry is a goal question
    //     if (entry.value is List<String> && entry.value.isNotEmpty) {
    //       isGoal = true;
    //       otherGoals = otherGoalString ?? ''; // Capture the other goal text
    //     }

    //     // Create a JSON object for each question
    //     return {
    //       'question_id': entry.key,
    //       'answers': isGoal
    //           ? entry.value // Keep it as is if it's a list
    //           : (entry.value is List<int>
    //               ? entry.value
    //               : entry.value
    //                   .toString()), // Handle different types of answers
    //       if (isGoal && otherGoals.isNotEmpty)
    //         'other_goals':
    //             otherGoals, // Include only if it's a goal and otherGoalString is not empty
    //       'is_goal': isGoal, // Boolean indicating if it’s a goal question
    //     };
    //   }).toList(),
    // };

    debugPrint(generateJson().toString());

    // Send submissionData to API
    setState(() {
      buttonLoad = true;
    });
    try {
      var response = await consentRaise(jsonDecode(generateJson()));
      debugPrint('consentQuestionsApi: Data fetched successfully');

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, response?.message ?? 'Success');
        Navigator.of(context).pop();
      } else {
        // Handle errors from the API response
        if (response?.errors?.isNotEmpty ?? false) {
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });

          // Focus on the first error field
          _focusOnFirstError();
        } else {
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.error,
            response?.message ?? 'Something went wrong',
          );
        }
      }
    } catch (e) {
      debugPrint('consentRaise error: $e');
    } finally {
      setState(() {
        buttonLoad = false;
      });
    }
  }

  void _focusOnFirstError() {
    if (fieldErrors.containsKey('email')) {
      FocusScope.of(context).requestFocus(emailFocusNode);
    } else if (fieldErrors.containsKey('country_code') ||
        fieldErrors.containsKey('phone')) {
      FocusScope.of(context).requestFocus(phoneNumberFocusNode);
    } else if (fieldErrors.containsKey('contact_name')) {
      FocusScope.of(context).requestFocus(contactNameFocusNode);
    } else if (fieldErrors.containsKey('company_name')) {
      FocusScope.of(context).requestFocus(companyNameFocusNode);
    } else if (fieldErrors.containsKey('company_size')) {
      SnackBarHelper.showStatusSnackBar(
        context,
        StatusIndicator.error,
        fieldErrors['company_size'] ?? 'Something went wrong',
      );
    } else if (fieldErrors.containsKey('contact_job_title')) {
      FocusScope.of(context).requestFocus(jobTitleFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Raise Consent',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
                fontSize: 20),
          ),
        ),
        body: loading
            ? const Center(
                child:
                    CircularProgressIndicator()) // Center the loading indicator
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          const Text(
                            'Thank you for choosing Jump for your organization\'s coaching and consulting needs. Please complete this form, and we\'ll reach out to discuss your goals and how we can help.',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ).paddingSymmetric(horizontal: 16),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          // Company Name
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                textFormField(
                                  label: 'Company Name *',
                                  labelTextBoxSpace: 8,
                                  controller: companyNameController,
                                  focusNode: companyNameFocusNode,
                                  errorText: fieldErrors['company_name'],
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter Company Name',
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Company name should not be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                // Contact Name
                                textFormField(
                                  label: 'Contact Name *',
                                  labelTextBoxSpace: 8,
                                  autofocus: false,
                                  controller: contactNameController,
                                  focusNode: contactNameFocusNode,
                                  errorText: fieldErrors['contact_name'],
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter Contact Name',
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Contact name should not be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                // Primary Contact Job Title
                                textFormField(
                                  label: 'Primary Contact Job Title *',
                                  labelTextBoxSpace: 8,
                                  autofocus: false,
                                  controller: jobTitleController,
                                  focusNode: jobTitleFocusNode,
                                  errorText: fieldErrors['job_title'],
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.text,
                                  hintText: 'Enter Job Title',
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Job title should not be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                // Email Address
                                textFormField(
                                  label: 'Email Address *',
                                  labelTextBoxSpace: 8,
                                  autofocus: false,
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  errorText: fieldErrors['email'],
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: 'Enter Email Address',
                                  textInputAction: TextInputAction.next,
                                  validator: (email) =>
                                      validateEmail(email ?? ''),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                textFormField(
                                  label: 'Phone Number *',
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
                                      sPhoneNumber =
                                          maskedTextToNumber(phoneNumber);
                                      // sCountryCodeClient = phoneNumber.countryCode;
                                      sCountryCode = '+1';
                                    });
                                  },
                                  validator: (phoneNumber) {
                                    if (phoneNumber == null ||
                                        phoneNumber.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                // Company Size Dropdown
                                labelContainer(
                                  label: 'Company Size',
                                  labelTextBoxSpace: 8,
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: DropdownButton<String>(
                                    value: selectedCompanySize,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    hint: const Text(
                                      'Select Company Size',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    items: companySizeList
                                        .map((String value) =>
                                            DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedCompanySize = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                // In your ListView.builder:
                                ListView.builder(
                                  itemCount:
                                      consentQuestionResponse?.data?.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final question =
                                        consentQuestionResponse?.data?[index];
                                    switch (question?.type) {
                                      case 1: // Single select dropdown
                                        return _buildSingleSelectDropdown(
                                                question)
                                            .paddingBottom(20);
                                      case 2: // Multi select dropdown
                                        return _buildMultiSelectDropdown(
                                                question)
                                            .paddingBottom(20);
                                      case 3: // Boolean (Yes/No) radio buttons
                                        return _buildBooleanRadio(question)
                                            .paddingBottom(20);
                                      case 4: // Empty Text Form Field
                                        return _buildTextFormField(question)
                                            .paddingBottom(20);
                                      case 5: // Goal (Extendable dropdown)
                                        return _buildGoalDropdown(question)
                                            .paddingBottom(20);
                                      default:
                                        return const SizedBox(); // Return empty container for unsupported types
                                    }
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.92,
                            child: button(context, onPressed: () async {
                              hideKeyboard(context);
                              if (_formKey.currentState!.validate()) {
                                _submitForm();
                              } else {
                                return;
                              }
                            }, isLoading: buttonLoad, text: 'Submit')),
                      ),
                    ),
                  ),
                ],
              ),
      );

  // Text Form Field for description (when type is 4)
  Widget _buildTextFormField(Question? question) {
    // If there's already an answer for this question, prefill the text field
    if (answers[question?.id] != null) {
      descriptionController?.text = answers[question!.id] as String;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFormField(
          label: question?.question ?? '',
          controller: descriptionController,
          hintText: 'Enter Description',
          maxLines: 3,
          validator: (value) {
            // Add validation if necessary
          },
          onChanged: (value) {
            // Update the global map with the text input
            answers[question!.id!] = value;
          },
        ),
      ],
    );
  }

  Widget _buildSingleSelectDropdown(Question? question) => labelContainer(
        label: question?.question ?? '',
        width: MediaQuery.of(context).size.width * 1,
        child: DropdownButtonFormField<String>(
          value: answers[question?.id] as String?,
          items: question?.options
              ?.map((option) => DropdownMenuItem<String>(
                    value: option.value,
                    child: Text(option.value ?? ''),
                  ))
              .toList(),
          hint: Text(
            'Select',
            style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              answers[question!.id!] = value;
            });
          },
        ),
      );

  Widget _buildMultiSelectDropdown(Question? question) {
    // Map options to categories, assuming category.id is an int
    var categories = question?.options?.map((opt) => opt).toList() ?? [];
    var selectedValues = selectedMultiSelectValues[question!.id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelContainer(
          label: question.question ?? '',
          width: MediaQuery.of(context).size.width * 1,
          child: MultiSelectDialogField(
            items: categories.map((category) {
              return MultiSelectItem(category.id, category.value ?? '');
            }).toList(),
            title: const Text('Select'),
            buttonIcon: const Icon(Icons.arrow_drop_down),
            buttonText: Text(
              'Select',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            initialValue: selectedValues, // Ensure this is List<int>
            onConfirm: (values) {
              setState(() {
                // Use List<int> instead of List<String> to handle IDs correctly
                selectedMultiSelectValues[question.id!] =
                    List<int>.from(values);
                answers[question.id!] = selectedMultiSelectValues[
                    question.id!]; // Store IDs in the answers map
              });
            },
            chipDisplay: MultiSelectChipDisplay(
              chipColor: Theme.of(context).cardColor,
              textStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
              onTap: (value) {
                setState(() {
                  selectedMultiSelectValues[question.id!]!.remove(value);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

// Change selectedBooleanValues to store int
  Map<int, int?> selectedBooleanValues = {};

  Widget _buildBooleanRadio(Question? question) {
    final questionId = question?.id ?? 0;
    var selectedValue = selectedBooleanValues[questionId];

    return labelContainer(
      label: question?.question ?? '',
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        children: question?.options?.map((option) {
              bool isYes = option.value == 'Yes';
              return Expanded(
                child: RadioListTile<int>(
                  title: Text(option.value ?? ''),
                  value: isYes ? 1 : 0, // Use 1 for Yes and 0 for No
                  groupValue: selectedValue, // Ensure this is int?
                  onChanged: (value) {
                    setState(() {
                      selectedBooleanValues[questionId] = value; // Store as int
                      answers[questionId] =
                          value == 1; // Convert to bool for answers
                    });
                  },
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }

  void _onGoalSelectionChanged(
      int questionId, List<Category> selectedItems, String other) {
    setState(() {
      if (selectedItems.isNotEmpty) {
        answers[questionId] = selectedItems.map((item) => item.id).toList();
      } else {
        answers[questionId] = []; // Handle empty selection case
      }
      goalAnswer[questionId] = other; // Handle "other" goal text
    });
  }

  Widget _buildGoalDropdown(Question? question) =>
      DropdownWithMultiSelectAndAddNewItem(
        question: question,
        goalslistfromapi: sponsors, // List fetched from API
        onSelectedItemsChanged: (selectedItems, otherSponsorText) {
          _onGoalSelectionChanged(
              question!.id!, selectedItems, otherSponsorText);
        },
      );
}

class DropdownWithMultiSelectAndAddNewItem extends StatefulWidget {
  // Callback for selected items

  DropdownWithMultiSelectAndAddNewItem({
    this.question,
    required this.onSelectedItemsChanged,
    required this.goalslistfromapi,
  });
  final Question? question;
  final List<Category> goalslistfromapi; // Goals fetched from API
  final Function(List<Category>, String) onSelectedItemsChanged;

  @override
  _DropdownWithMultiSelectAndAddNewItemState createState() =>
      _DropdownWithMultiSelectAndAddNewItemState();
}

class _DropdownWithMultiSelectAndAddNewItemState
    extends State<DropdownWithMultiSelectAndAddNewItem> {
  List<Category> selectedItems = [];
  bool isOtherSelected = false;
  TextEditingController otherGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure "Other" is always part of the dropdown options
    if (!widget.goalslistfromapi.contains(Category(id: 0, name: 'Other'))) {
      widget.goalslistfromapi.add(Category(id: 0, name: 'Other'));
    }
    selectedItems = [];
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelContainer(
            label: widget.question?.question ?? '',
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              children: [
                MultiSelectDialogField(
                  items: widget.goalslistfromapi
                      .map((item) => MultiSelectItem(item, item.name ?? ''))
                      .toList(),
                  title: const Text(
                    'Select Goal(s)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  decoration: const BoxDecoration(),
                  buttonText: const Text(
                    'Select Goal(s)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onConfirm: (values) {
                    setState(() {
                      selectedItems = List<Category>.from(values);
                      widget.onSelectedItemsChanged(
                          selectedItems, otherGoalController.text);
                      // Check if "Other" is selected
                      isOtherSelected =
                          selectedItems.any((element) => element.id == 0);
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    items: selectedItems
                        .map((item) => MultiSelectItem(item, item.name ?? ''))
                        .toList(),
                    chipColor: Theme.of(context).cardColor,
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    onTap: (item) {
                      setState(() {
                        selectedItems.remove(item);
                        widget.onSelectedItemsChanged(
                            selectedItems, otherGoalController.text);
                        // Update "Other" selection state
                        isOtherSelected =
                            selectedItems.any((element) => element.id == 0);
                      });
                    },
                  ),
                ),
                if (isOtherSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: textFormField(
                      label: '',
                      isLabel: false,
                      controller: otherGoalController,
                      hintText: 'Enter custom goal',
                      errorText: otherGoalController.text.isEmpty
                          ? 'This field is required.'
                          : null,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          // Add custom goal dynamically
                          setState(() {
                            // Update the selected items with the custom goal
                            var customGoal = Category(id: 0, name: value);
                            if (!selectedItems.contains(customGoal)) {
                              selectedItems.add(customGoal);
                            }
                            widget.onSelectedItemsChanged(
                                selectedItems, otherGoalController.text);
                          });
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
}
