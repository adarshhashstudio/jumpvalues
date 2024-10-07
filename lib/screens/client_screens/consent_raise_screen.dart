import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    companyNameController = TextEditingController();
    contactNameController = TextEditingController();
    jobTitleController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

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
            buttonIcon: Icon(Icons.arrow_drop_down),
            decoration: BoxDecoration(),
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

  void _onGoalSelectionChanged(int questionId, List<String> selectedItems) {
    setState(() {
      answers[questionId] = selectedItems;
    });
  }

  Widget _buildGoalDropdown(Question? question) =>
      DropdownWithMultiSelectAndAddNewItem(
        question: question,
        onSelectedItemsChanged: (selectedItems) {
          _onGoalSelectionChanged(
              question!.id!, selectedItems); // Pass selected values to parent
        },
      );
}

class DropdownWithMultiSelectAndAddNewItem extends StatefulWidget {
  final Question? question;
  final Function(List<String>)
      onSelectedItemsChanged; // Add callback for selected items

  DropdownWithMultiSelectAndAddNewItem(
      {this.question, required this.onSelectedItemsChanged});

  @override
  _DropdownWithMultiSelectAndAddNewItemState createState() =>
      _DropdownWithMultiSelectAndAddNewItemState();
}

class _DropdownWithMultiSelectAndAddNewItemState
    extends State<DropdownWithMultiSelectAndAddNewItem> {
  late List<String> items;
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    items =
        widget.question?.options?.map((opt) => opt.value ?? '').toList() ?? [];
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
                  items:
                      items.map((item) => MultiSelectItem(item, item)).toList(),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  title: Text(
                    'Select',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
                      selectedItems = List<String>.from(values);
                      widget.onSelectedItemsChanged(
                          selectedItems); // Notify parent about selected items
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    items: selectedItems
                        .map((item) => MultiSelectItem(item, item))
                        .toList(),
                    chipColor: Theme.of(context).cardColor,
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    onTap: (value) {
                      setState(() {
                        selectedItems.remove(value);
                        widget.onSelectedItemsChanged(
                            selectedItems); // Notify parent about updated selected items
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddNewItemDialog(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Your',
                        style: TextStyle(
                          color: grey,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      );

  void _showAddNewItemDialog(BuildContext context) {
    var _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add New Goal'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Enter new goal'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              setState(() {
                if (_textController.text.isNotEmpty &&
                    !items.contains(_textController.text)) {
                  items.add(_textController.text);
                  selectedItems
                      .add(_textController.text); // Auto-select new item
                  widget.onSelectedItemsChanged(
                      selectedItems); // Notify parent about new selected items
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}


// class ConsentRaiseScreen extends StatefulWidget {
//   const ConsentRaiseScreen({super.key});

//   @override
//   State<ConsentRaiseScreen> createState() => _ConsentRaiseScreenState();
// }

// class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // TextEditing Controllers
//   TextEditingController? companyNameController;
//   TextEditingController? contactNameController;
//   TextEditingController? jobTitleController;
//   TextEditingController? emailController;
//   TextEditingController? additionalInfoController;

//   // FocusNodes for each field
//   final FocusNode companyNameFocusNode = FocusNode();
//   final FocusNode contactNameFocusNode = FocusNode();
//   final FocusNode jobTitleFocusNode = FocusNode();
//   final FocusNode emailFocusNode = FocusNode();
//   final FocusNode additionalInfoFocusNode = FocusNode();

//   // Dropdown values for Company Size
//   String? selectedCompanySize;
//   List<String> companySizeList = [
//     'Under 100 Employees',
//     '101-250 Employees',
//     '251-750 Employees',
//     '751-999 Employees',
//     '1,000+ Employees'
//   ];

//   // Dropdown values for Coaching Budget
//   String? selectedCoachingBudget;
//   List<String> coachingBudgetOptions = ['YES', 'NO'];

//   // Dropdown values for leadership development or training program?
//   String? selectedLeadershipAndTrainingProgram;
//   List<String> leadershipAndTrainingProgramOptions = ['YES', 'NO'];

//   // Multiple choice values for "How did you hear about us?"
//   Map<String, bool> hearAboutUsOptions = {
//     'Referral': false,
//     'Internet Search': false,
//     'Social Media': false,
//     'Advertisement': false,
//     'Other': false,
//   };

//   // Map to store error messages for each field
//   Map<String, dynamic> fieldErrors = {};

//   @override
//   void initState() {
//     companyNameController = TextEditingController();
//     contactNameController = TextEditingController();
//     jobTitleController = TextEditingController();
//     emailController = TextEditingController();
//     additionalInfoController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // Dispose text editing controllers
//     companyNameController?.dispose();
//     contactNameController?.dispose();
//     jobTitleController?.dispose();
//     emailController?.dispose();
//     additionalInfoController?.dispose();

//     // Dispose focus nodes
//     companyNameFocusNode.dispose();
//     contactNameFocusNode.dispose();
//     jobTitleFocusNode.dispose();
//     emailFocusNode.dispose();
//     additionalInfoFocusNode.dispose();
//     super.dispose();
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
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: SafeArea(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.01,
//                             ),
//                             const Text(
//                               'Thank you for choosing Jump for your organization\'s coaching and consulting needs. Please complete this form, and we\'ll reach out to discuss your goals and how we can help.',
//                               style: TextStyle(fontSize: 12),
//                               textAlign: TextAlign.center,
//                             ).paddingSymmetric(horizontal: 16),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.01,
//                             ),
//                             divider(),
//                             additionalDetails(context)
//                                 .paddingSymmetric(horizontal: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     child:
//                         button(context, onPressed: () async {}, text: 'Raise'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );

//   Widget additionalDetails(BuildContext context) => Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Company Name
//             textFormField(
//               label: 'Company Name *',
//               labelTextBoxSpace: 8,
//               autofocus: true,
//               controller: companyNameController,
//               focusNode: companyNameFocusNode,
//               errorText: fieldErrors['company_name'],
//               onChanged: (value) {},
//               keyboardType: TextInputType.name,
//               hintText: 'Enter Company Name',
//               textInputAction: TextInputAction.next,
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Contact Name
//             textFormField(
//               label: 'Contact Name *',
//               labelTextBoxSpace: 8,
//               autofocus: false,
//               controller: contactNameController,
//               focusNode: contactNameFocusNode,
//               errorText: fieldErrors['contact_name'],
//               onChanged: (value) {},
//               keyboardType: TextInputType.name,
//               hintText: 'Enter Contact Name',
//               textInputAction: TextInputAction.next,
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Primary Contact Job Title
//             textFormField(
//               label: 'Primary Contact Job Title *',
//               labelTextBoxSpace: 8,
//               autofocus: false,
//               controller: jobTitleController,
//               focusNode: jobTitleFocusNode,
//               errorText: fieldErrors['job_title'],
//               onChanged: (value) {},
//               keyboardType: TextInputType.text,
//               hintText: 'Enter Job Title',
//               textInputAction: TextInputAction.next,
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Email Address
//             textFormField(
//               label: 'Email Address *',
//               labelTextBoxSpace: 8,
//               autofocus: false,
//               controller: emailController,
//               focusNode: emailFocusNode,
//               errorText: fieldErrors['email'],
//               onChanged: (value) {},
//               keyboardType: TextInputType.emailAddress,
//               hintText: 'Enter Email Address',
//               textInputAction: TextInputAction.next,
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Company Size Dropdown
//             labelContainer(
//               label: 'Company Size *',
//               labelTextBoxSpace: 8,
//               width: MediaQuery.of(context).size.width * 1,
//               height: MediaQuery.of(context).size.height * 0.06,
//               child: DropdownButton<String>(
//                 value: selectedCompanySize,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 hint: const Text(
//                   'Select Company Size',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w400,
//                 ),
//                 items: companySizeList
//                     .map((String value) => DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         ))
//                     .toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedCompanySize = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.03,
//             ),
//             divider(),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             Text(
//               'Specific Challenges or Pain Points Your Organization is Facing',
//               style: boldTextStyle(color: grey),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             divider(),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // leadership development or training program Dropdown
//             labelContainer(
//               label:
//                   'Does your company currently have a business/executive coaching, leadership development or training program? *',
//               labelTextBoxSpace: 8,
//               width: MediaQuery.of(context).size.width * 1,
//               height: MediaQuery.of(context).size.height * 0.06,
//               child: DropdownButton<String>(
//                 value: selectedLeadershipAndTrainingProgram,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 hint: const Text(
//                   'Select an option',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w400,
//                 ),
//                 items: leadershipAndTrainingProgramOptions
//                     .map((String value) => DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         ))
//                     .toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedLeadershipAndTrainingProgram = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.03,
//             ),
//             // Coaching Budget Dropdown
//             labelContainer(
//               label:
//                   'Do you have a coaching/consulting budget for this program? *',
//               labelTextBoxSpace: 8,
//               width: MediaQuery.of(context).size.width * 1,
//               height: MediaQuery.of(context).size.height * 0.06,
//               child: DropdownButton<String>(
//                 value: selectedCoachingBudget,
//                 isExpanded: true,
//                 underline: const SizedBox(),
//                 hint: const Text(
//                   'Select an option',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w400,
//                 ),
//                 items: coachingBudgetOptions
//                     .map((String value) => DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         ))
//                     .toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedCoachingBudget = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.03,
//             ),

//             divider(),
//              SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             Text(
//               'What specific outcomes does your organization want to achieve from this engagement?',
//               style: boldTextStyle(color: grey),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.01,
//             ),
//             divider(),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // Additional Info Text Field
//             textFormField(
//               label:
//                   'Is there anything else we should know about your company or the specific needs of your employees?',
//               labelTextBoxSpace: 8,
//               autofocus: false,
//               controller: additionalInfoController,
//               focusNode: additionalInfoFocusNode,
//               errorText: fieldErrors['additional_info'],
//               onChanged: (value) {},
//               keyboardType: TextInputType.multiline,
//               hintText: 'Provide Additional Information',
//               textInputAction: TextInputAction.next,
//               maxLines: 4,
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//             // How did you hear about us? Checkbox List
//             labelContainer(
//               label: 'How did you hear about us?',
//               width: MediaQuery.of(context).size.width * 1,
//               height: null,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: hearAboutUsOptions.keys
//                     .map((String key) => CheckboxListTile(
//                           contentPadding: const EdgeInsets.all(0),
//                           dense: true,
//                           title: Text(
//                             key,
//                             style: const TextStyle(fontSize: 15),
//                           ),
//                           value: hearAboutUsOptions[key],
//                           onChanged: (bool? value) {
//                             setState(() {
//                               hearAboutUsOptions[key] = value!;
//                             });
//                           },
//                         ))
//                     .toList(),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.02,
//             ),
//           ],
//         ),
//       );
// }
