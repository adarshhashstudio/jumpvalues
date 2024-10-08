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

// class ConsentRaiseScreen extends StatefulWidget {
//   const ConsentRaiseScreen({super.key});

//   @override
//   State<ConsentRaiseScreen> createState() => _ConsentRaiseScreenState();
// }

// class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   ConsentQuestionResponse? consentQuestionResponse;
//   Map<int, dynamic> answers = {};

//   bool loading = false;
//   // TextEditing Controllers
//   TextEditingController? companyNameController;
//   TextEditingController? contactNameController;
//   TextEditingController? jobTitleController;
//   TextEditingController? emailController;
//   TextEditingController? phoneNumberController;

//   // FocusNodes for each field
//   final FocusNode companyNameFocusNode = FocusNode();
//   final FocusNode contactNameFocusNode = FocusNode();
//   final FocusNode jobTitleFocusNode = FocusNode();
//   final FocusNode emailFocusNode = FocusNode();
//   final FocusNode phoneNumberFocusNode = FocusNode();

//   // Dropdown values for Company Size
//   String? selectedCompanySize;
//   List<String> companySizeList = [
//     'Under 100 Employees',
//     '101-250 Employees',
//     '251-750 Employees',
//     '751-999 Employees',
//     '1,000+ Employees'
//   ];

//   String sPhoneNumber = '';
//   String sCountryCode = '';

// //   // Map to store error messages for each field
//   Map<String, dynamic> fieldErrors = {};

//   // Store selected boolean values for each question by question ID
//   Map<int, bool?> selectedBooleanValues = {};

//   List<Category> sponsors = [];

//   @override
//   void initState() {
//     super.initState();

//     // Initialize controllers
//     companyNameController = TextEditingController();
//     contactNameController = TextEditingController();
//     jobTitleController = TextEditingController();
//     emailController = TextEditingController();
//     phoneNumberController = TextEditingController();
//     getGoalsDropdown();
//     // Fetch questions API
//     consentQuestionsApi();
//   }

//   @override
//   void dispose() {
//     companyNameController?.dispose();
//     contactNameController?.dispose();
//     jobTitleController?.dispose();
//     emailController?.dispose();
//     phoneNumberController?.dispose();

//     super.dispose();
//   }

//   Future<void> getGoalsDropdown() async {
//     setState(() {
//       loading = true;
//     });

//     try {
//       var response = await goalsDropdown();
//       if (response?.status == true) {
//         setState(() {
//           sponsors.clear();
//           sponsors = response?.data ?? [];
//         });
//       } else {
//         if (response?.message != null) {
//           SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
//               response?.message ?? errorSomethingWentWrong);
//         }
//       }
//     } catch (e) {
//       debugPrint('sponsorsDropdown Error: $e');
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   Future<void> consentQuestionsApi() async {
//     debugPrint('consentQuestionsApi: Fetching data...');
//     setState(() {
//       loading = true;
//     });
//     try {
//       var response = await consentQuestions();
//       debugPrint('consentQuestionsApi: Data fetched successfully');

//       if (response?.status == true) {
//         setState(() {
//           consentQuestionResponse = response;
//           debugPrint('consentQuestionsApi: Data set in state');
//         });
//       } else {
//         debugPrint('consentQuestionsApi: Error response from API');
//         SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
//             response?.message ?? 'Something went wrong');
//       }
//     } catch (e) {
//       debugPrint('consentQuestionsApi error: $e');
//     } finally {
//       setState(() {
//         loading = false;
//         debugPrint('consentQuestionsApi: Loading set to false');
//       });
//     }
//   }

//   void _submitForm() async {
//     int companysizez;
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
//       companysizez = 0;
//     }

//     final submissionData = {
//       'email': emailController?.text,
//       'country_code': sCountryCode,
//       'phone': sPhoneNumber,
//       'contact_name': contactNameController?.text,
//       'company_name': companyNameController?.text,
//       'company_size': companysizez,
//       'contact_job_title': jobTitleController?.text,
//       'questions': answers.entries
//           .map((entry) => {
//                 'question_id': entry.key,
//                 'answers': entry.value,
//                 'is_goal': entry.value
//                     is List<String>, // Check if this is a goal question
//               })
//           .toList(),
//     };

//     debugPrint(submissionData.toString());
//     // Send submissionData to API

//     setState(() {
//       loading = true;
//     });
//     try {
//       var response = await consentRaise(submissionData);
//       debugPrint('consentQuestionsApi: Data fetched successfully');

//       if (response?.status == true) {
//         SnackBarHelper.showStatusSnackBar(
//             context, StatusIndicator.success, response?.message ?? 'Success');
//       } else {
//         // debugPrint('consentQuestionsApi: Error response from API');
//         // SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
//         //     response?.message ?? 'Something went wrong');
//         if (response?.errors?.isNotEmpty ?? false) {
//           // Set field errors and focus on the first error field
//           response?.errors?.forEach((e) {
//             fieldErrors[e.field ?? '0'] = e.message ?? '0';
//           });
//           // Focus on the first error
//           if (fieldErrors.containsKey('email')) {
//             FocusScope.of(context).requestFocus(emailFocusNode);
//           } else if (fieldErrors.containsKey('country_code')) {
//             FocusScope.of(context).requestFocus(phoneNumberFocusNode);
//           } else if (fieldErrors.containsKey('phone')) {
//             FocusScope.of(context).requestFocus(phoneNumberFocusNode);
//           } else if (fieldErrors.containsKey('contact_name')) {
//             FocusScope.of(context).requestFocus(contactNameFocusNode);
//           } else if (fieldErrors.containsKey('company_name')) {
//             FocusScope.of(context).requestFocus(companyNameFocusNode);
//           } else if (fieldErrors.containsKey('company_size')) {
//             SnackBarHelper.showStatusSnackBar(
//               context,
//               StatusIndicator.error,
//               fieldErrors['company_size'] ?? 'Something went wrong',
//             );
//           } else if (fieldErrors.containsKey('contact_job_title')) {
//             FocusScope.of(context).requestFocus(jobTitleFocusNode);
//           }
//         } else {
//           // Handle other errors
//           SnackBarHelper.showStatusSnackBar(
//             context,
//             StatusIndicator.error,
//             response?.message ?? 'Something went wrong',
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('consentRaise error: $e');
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(4.0),
//             child: Container(
//               color: Colors.grey,
//               height: 0.5,
//             ),
//           ),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: const Padding(
//               padding: EdgeInsets.only(left: 14.0),
//               child: Icon(Icons.arrow_back_ios_new),
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             'Raise Consent',
//             style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black.withOpacity(0.8),
//                 fontSize: 20),
//           ),
//         ),
//         body: loading
//             ? const Center(
//                 child:
//                     CircularProgressIndicator()) // Center the loading indicator
//             : Stack(
//                 children: [
//                   SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.01,
//                           ),
//                           const Text(
//                             'Thank you for choosing Jump for your organization\'s coaching and consulting needs. Please complete this form, and we\'ll reach out to discuss your goals and how we can help.',
//                             style: TextStyle(fontSize: 12),
//                             textAlign: TextAlign.center,
//                           ).paddingSymmetric(horizontal: 16),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.01,
//                           ),
//                           divider(),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.02,
//                           ),
//                           // Company Name
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Column(
//                               children: [
//                                 textFormField(
//                                   label: 'Company Name *',
//                                   labelTextBoxSpace: 8,
//                                   autofocus: true,
//                                   controller: companyNameController,
//                                   focusNode: companyNameFocusNode,
//                                   errorText: fieldErrors['company_name'],
//                                   onChanged: (value) {},
//                                   keyboardType: TextInputType.name,
//                                   hintText: 'Enter Company Name',
//                                   textInputAction: TextInputAction.next,
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 // Contact Name
//                                 textFormField(
//                                   label: 'Contact Name *',
//                                   labelTextBoxSpace: 8,
//                                   autofocus: false,
//                                   controller: contactNameController,
//                                   focusNode: contactNameFocusNode,
//                                   errorText: fieldErrors['contact_name'],
//                                   onChanged: (value) {},
//                                   keyboardType: TextInputType.name,
//                                   hintText: 'Enter Contact Name',
//                                   textInputAction: TextInputAction.next,
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 // Primary Contact Job Title
//                                 textFormField(
//                                   label: 'Primary Contact Job Title *',
//                                   labelTextBoxSpace: 8,
//                                   autofocus: false,
//                                   controller: jobTitleController,
//                                   focusNode: jobTitleFocusNode,
//                                   errorText: fieldErrors['job_title'],
//                                   onChanged: (value) {},
//                                   keyboardType: TextInputType.text,
//                                   hintText: 'Enter Job Title',
//                                   textInputAction: TextInputAction.next,
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 // Email Address
//                                 textFormField(
//                                   label: 'Email Address *',
//                                   labelTextBoxSpace: 8,
//                                   autofocus: false,
//                                   controller: emailController,
//                                   focusNode: emailFocusNode,
//                                   errorText: fieldErrors['email'],
//                                   onChanged: (value) {},
//                                   keyboardType: TextInputType.emailAddress,
//                                   hintText: 'Enter Email Address',
//                                   textInputAction: TextInputAction.next,
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 textFormField(
//                                   label: 'Phone Number *',
//                                   labelTextBoxSpace: 8,
//                                   controller: phoneNumberController,
//                                   focusNode: phoneNumberFocusNode,
//                                   errorText: fieldErrors['phone'],
//                                   prefixIcon: IconButton(
//                                     onPressed: () {},
//                                     icon: Text(
//                                       '+1',
//                                       style: TextStyle(
//                                         color: textColor,
//                                         fontSize: 15,
//                                         fontFamily: 'Roboto',
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ),
//                                   inputFormatters: [maskFormatter],
//                                   onChanged: (phoneNumber) {
//                                     setState(() {
//                                       sPhoneNumber =
//                                           maskedTextToNumber(phoneNumber);
//                                       // sCountryCodeClient = phoneNumber.countryCode;
//                                       sCountryCode = '+1';
//                                     });
//                                   },
//                                   validator: (phoneNumber) {
//                                     if (phoneNumber == null ||
//                                         phoneNumber.isEmpty) {
//                                       return 'Phone number is required';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 // Company Size Dropdown
//                                 labelContainer(
//                                   label: 'Company Size *',
//                                   labelTextBoxSpace: 8,
//                                   width: MediaQuery.of(context).size.width * 1,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.06,
//                                   child: DropdownButton<String>(
//                                     value: selectedCompanySize,
//                                     isExpanded: true,
//                                     underline: const SizedBox(),
//                                     hint: const Text(
//                                       'Select Company Size',
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 15,
//                                         fontFamily: 'Roboto',
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontFamily: 'Roboto',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     items: companySizeList
//                                         .map((String value) =>
//                                             DropdownMenuItem<String>(
//                                               value: value,
//                                               child: Text(value),
//                                             ))
//                                         .toList(),
//                                     onChanged: (String? value) {
//                                       setState(() {
//                                         selectedCompanySize = value;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.02,
//                                 ),
//                                 ListView.builder(
//                                   itemCount:
//                                       consentQuestionResponse?.data?.length,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     final question =
//                                         consentQuestionResponse?.data?[index];
//                                     switch (question?.type) {
//                                       case 1: // Single select dropdown
//                                         return _buildSingleSelectDropdown(
//                                                 question)
//                                             .paddingBottom(20);
//                                       case 2: // Multi select dropdown
//                                         return _buildMultiSelectDropdown(
//                                                 question)
//                                             .paddingBottom(20);
//                                       case 3: // Boolean (Yes/No) radio buttons
//                                         return _buildBooleanRadio(question)
//                                             .paddingBottom(20);
//                                       case 4: // Empty Text Form Field
//                                         return _buildTextFormField(question)
//                                             .paddingBottom(20);
//                                       case 5: // Goal (Extendable dropdown)
//                                         return _buildGoalDropdown(question)
//                                             .paddingBottom(20);
//                                       default:
//                                         return const SizedBox(); // Return empty container for unsupported types
//                                     }
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.1,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 16,
//                     child: Container(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.92,
//                             child: button(context, onPressed: () async {
//                               _submitForm();
//                             }, text: 'Submit')),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       );

//   // Text Form Field for description (when type is 4)
//   Widget _buildTextFormField(Question? question) {
//     var _textEditingController = TextEditingController();

//     // If there's already an answer for this question, prefill the text field
//     if (answers[question?.id] != null) {
//       _textEditingController.text = answers[question!.id] as String;
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         textFormField(
//           label: question?.question ?? '',
//           controller: _textEditingController,
//           hintText: 'Enter Description',
//           maxLines: 3,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter a response';
//             }
//             return null;
//           },
//           onChanged: (value) {
//             // Update the global map with the text input
//             answers[question!.id!] = value;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildSingleSelectDropdown(Question? question) => labelContainer(
//         label: question?.question ?? '',
//         width: MediaQuery.of(context).size.width * 1,
//         child: DropdownButtonFormField<String>(
//           value: answers[question?.id] as String?,
//           items: question?.options
//               ?.map((option) => DropdownMenuItem<String>(
//                     value: option.value,
//                     child: Text(option.value ?? ''),
//                   ))
//               .toList(),
//           hint: Text(
//             'Select',
//             style: TextStyle(
//                 color: textColor,
//                 fontSize: 15,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400),
//           ),
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             setState(() {
//               answers[question!.id!] = value;
//             });
//           },
//         ),
//       );

// // Multi select dropdown using MultiSelectDialogField
//   Widget _buildMultiSelectDropdown(Question? question) {
//     // Create a list of selected values
//     var selectedValues = <String>[];

//     // Extract the options from the question (assuming options contain 'value' for labels)
//     var categories =
//         question?.options?.map((opt) => opt.value ?? '').toList() ?? [];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         labelContainer(
//           label: question?.question ?? '',
//           width: MediaQuery.of(context).size.width * 1,
//           child: MultiSelectDialogField(
//             items: categories
//                 .map((category) => MultiSelectItem(category, category))
//                 .toList(),
//             title: const Text('Select'),
//             buttonIcon: Icon(Icons.arrow_drop_down),
//             decoration: BoxDecoration(),
//             buttonText: Text(
//               'Select',
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 15,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             onConfirm: (values) {
//               setState(() {
//                 // Update the selected values based on user input
//                 selectedValues = List<String>.from(values);
//               });
//             },
//             chipDisplay: MultiSelectChipDisplay(
//               chipColor: Theme.of(context).cardColor,
//               textStyle: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold),
//               onTap: (value) {
//                 setState(() {
//                   // Remove tapped value from the selected values
//                   selectedValues.remove(value);
//                 });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Boolean (Yes/No) radio buttons
//   Widget _buildBooleanRadio(Question? question) {
//     final questionId = question?.id ?? 0;
//     var selectedValue = answers[questionId];

//     return labelContainer(
//       label: question?.question ?? '',
//       width: MediaQuery.of(context).size.width * 1,
//       child: Row(
//         children: question?.options
//                 ?.map((option) => Expanded(
//                       child: RadioListTile<bool>(
//                         title: Text(option.value ?? ''),
//                         value:
//                             option.value == 'Yes', // 'Yes' corresponds to true
//                         groupValue: selectedValue,
//                         onChanged: (value) {
//                           setState(() {
//                             // Store the selected value in the answers map
//                             answers[questionId] = value;
//                           });
//                         },
//                       ),
//                     ))
//                 .toList() ??
//             [],
//       ),
//     );
//   }

//   void _onGoalSelectionChanged(int questionId, List<String> selectedItems) {
//     setState(() {
//       answers[questionId] = selectedItems;
//     });
//   }

//   Category? selectedSponsorId;
//   bool isOtherSelected = false;
//   String? otherSponsorErrorText;
//   String? selectSponsorError;
//   final FocusNode selectedSponsorIdFocusNode = FocusNode();

//   TextEditingController otherSponsorController = TextEditingController();
//   final FocusNode otherSponsorFocusNode = FocusNode();

//   Widget _buildGoalDropdown(Question? question) => labelContainer(
//         label: question?.question??'',
//         labelTextBoxSpace: 8,
//         width: MediaQuery.of(context).size.width * 1,
//         height: isOtherSelected
//             ? MediaQuery.of(context).size.height * 0.15
//             : MediaQuery.of(context).size.height * 0.06,
//         isError: selectSponsorError != null,
//         errorText: selectSponsorError,
//         child: Column(
//           children: [
//             DropdownButton<Category>(
//               value: selectedSponsorId,
//               isExpanded: true,
//               underline: const SizedBox(),
//               focusNode: selectedSponsorIdFocusNode,
//               hint: Text(
//                 'Select Goal',
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: 15,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 15,
//                 fontFamily: 'Roboto',
//                 fontWeight: FontWeight.w400,
//               ),
//               items: [
//                 ...sponsors.map((Category value) => DropdownMenuItem<Category>(
//                       value: value,
//                       child: Text(value.name ?? ''),
//                     )),
//                 DropdownMenuItem<Category>(
//                   value: Category(id: 0, name: 'Other'),
//                   child: const Text('Other'),
//                 ),
//               ],
//               onChanged: (Category? value) async {
//                 setState(() {
//                   selectedSponsorId = value;
//                   isOtherSelected = (value?.id == 0);
//                   selectSponsorError = null;
//                 });
//               },
//             ),
//             if (isOtherSelected)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: textFormField(
//                     isLabel: false,
//                     label: '',
//                     controller: otherSponsorController,
//                     focusNode: otherSponsorFocusNode,
//                     errorText: otherSponsorErrorText,
//                     hintText: 'Enter company sponsor',
//                     onChanged: (v) {
//                       if (v.isNotEmpty) {
//                         setState(() {
//                           otherSponsorErrorText = null;
//                         });
//                       }
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'This field is required.';
//                       }
//                       return null;
//                     },
//                     color: white),
//               ),
//           ],
//         ),
//       );
// }

class ConsentRaiseScreen extends StatefulWidget {
  const ConsentRaiseScreen({super.key});

  @override
  State<ConsentRaiseScreen> createState() => _ConsentRaiseScreenState();
}

class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ConsentQuestionResponse? consentQuestionResponse;
  Map<int, dynamic> answers = {};

  bool loading = false;
  // TextEditing Controllers
  TextEditingController? companyNameController;
  TextEditingController? contactNameController;
  TextEditingController? jobTitleController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;

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
  Map<int, bool?> selectedBooleanValues = {};

  List<Category> sponsors = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    companyNameController = TextEditingController();
    contactNameController = TextEditingController();
    jobTitleController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
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

  void _submitForm() async {
    int companysizez;
    if (selectedCompanySize == 'Under 100 Employees') {
      companysizez = 0;
    } else if (selectedCompanySize == '101-250 Employees') {
      companysizez = 1;
    } else if (selectedCompanySize == '251-750 Employees') {
      companysizez = 2;
    } else if (selectedCompanySize == '751-999 Employees') {
      companysizez = 3;
    } else if (selectedCompanySize == '1,000+ Employees') {
      companysizez = 4;
    } else {
      companysizez = 0;
    }

    final submissionData = {
      'email': emailController?.text,
      'country_code': sCountryCode,
      'phone': sPhoneNumber,
      'contact_name': contactNameController?.text,
      'company_name': companyNameController?.text,
      'company_size': companysizez,
      'contact_job_title': jobTitleController?.text,
      'questions': answers.entries
          .map((entry) => {
                'question_id': entry.key,
                'answers': entry.value,
                'is_goal': entry.value
                    is List<String>, // Check if this is a goal question
              })
          .toList(),
    };

    debugPrint(submissionData.toString());
    // Send submissionData to API

    setState(() {
      loading = true;
    });
    try {
      var response = await consentRaise(submissionData);
      debugPrint('consentQuestionsApi: Data fetched successfully');

      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, response?.message ?? 'Success');
      } else {
        // debugPrint('consentQuestionsApi: Error response from API');
        // SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
        //     response?.message ?? 'Something went wrong');
        if (response?.errors?.isNotEmpty ?? false) {
          // Set field errors and focus on the first error field
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });
          // Focus on the first error
          if (fieldErrors.containsKey('email')) {
            FocusScope.of(context).requestFocus(emailFocusNode);
          } else if (fieldErrors.containsKey('country_code')) {
            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
          } else if (fieldErrors.containsKey('phone')) {
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
        } else {
          // Handle other errors
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
        loading = false;
      });
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
                                  autofocus: true,
                                  controller: companyNameController,
                                  focusNode: companyNameFocusNode,
                                  errorText: fieldErrors['company_name'],
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter Company Name',
                                  textInputAction: TextInputAction.next,
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
                                  label: 'Company Size *',
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
                              _submitForm();
                            }, text: 'Submit')),
                      ),
                    ),
                  ),
                ],
              ),
      );

  // Text Form Field for description (when type is 4)
  Widget _buildTextFormField(Question? question) {
    var _textEditingController = TextEditingController();

    // If there's already an answer for this question, prefill the text field
    if (answers[question?.id] != null) {
      _textEditingController.text = answers[question!.id] as String;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFormField(
          label: question?.question ?? '',
          controller: _textEditingController,
          hintText: 'Enter Description',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a response';
            }
            return null;
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

// Multi select dropdown using MultiSelectDialogField
  Widget _buildMultiSelectDropdown(Question? question) {
    // Create a list of selected values
    var selectedValues = <String>[];

    // Extract the options from the question (assuming options contain 'value' for labels)
    var categories =
        question?.options?.map((opt) => opt.value ?? '').toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelContainer(
          label: question?.question ?? '',
          width: MediaQuery.of(context).size.width * 1,
          child: MultiSelectDialogField(
            items: categories
                .map((category) => MultiSelectItem(category, category))
                .toList(),
            title: const Text('Select'),
            buttonIcon: const Icon(Icons.arrow_drop_down),
            decoration: const BoxDecoration(),
            buttonText: Text(
              'Select',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            onConfirm: (values) {
              setState(() {
                // Update the selected values based on user input
                selectedValues = List<String>.from(values);
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
                  // Remove tapped value from the selected values
                  selectedValues.remove(value);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // Boolean (Yes/No) radio buttons
  Widget _buildBooleanRadio(Question? question) {
    final questionId = question?.id ?? 0;
    var selectedValue = answers[questionId];

    return labelContainer(
      label: question?.question ?? '',
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        children: question?.options
                ?.map((option) => Expanded(
                      child: RadioListTile<bool>(
                        title: Text(option.value ?? ''),
                        value:
                            option.value == 'Yes', // 'Yes' corresponds to true
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            // Store the selected value in the answers map
                            answers[questionId] = value;
                          });
                        },
                      ),
                    ))
                .toList() ??
            [],
      ),
    );
  }

  void _onGoalSelectionChanged(int questionId, List<Category> selectedItems) {
    setState(() {
      // Convert selected items to the desired format (IDs or names)
      if (selectedItems.isNotEmpty) {
        answers[questionId] = selectedItems.map((item) => item.id).toList();
      }
    });
  }

  Category? selectedSponsorId;
  bool isOtherSelected = false;
  String? otherSponsorErrorText;
  String? selectSponsorError;
  final FocusNode selectedSponsorIdFocusNode = FocusNode();

  TextEditingController otherSponsorController = TextEditingController();
  final FocusNode otherSponsorFocusNode = FocusNode();

  Widget _buildGoalDropdown(Question? question) =>
      DropdownWithMultiSelectAndAddNewItem(
        question: question,
        goalslistfromapi: sponsors, // List fetched from API
        onSelectedItemsChanged: (selectedItems) {
          _onGoalSelectionChanged(question!.id!, selectedItems);
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
  final Function(List<Category>) onSelectedItemsChanged;

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
    widget.goalslistfromapi.add(Category(id: 0, name: 'Other'));
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
                      widget.onSelectedItemsChanged(selectedItems);
                      // Check if "Other" is selected
                      isOtherSelected =
                          selectedItems.any((element) => element.id == 0);
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    items: selectedItems
                        .map((item) => MultiSelectItem(item, item.name ?? ''))
                        .toList(),
                    onTap: (item) {
                      setState(() {
                        selectedItems.remove(item);
                        widget.onSelectedItemsChanged(selectedItems);
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
                            widget.onSelectedItemsChanged(selectedItems);
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
