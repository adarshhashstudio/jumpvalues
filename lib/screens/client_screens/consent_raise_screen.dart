import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/models/question_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/client_screens/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ConsentRaiseScreen extends StatefulWidget {
  const ConsentRaiseScreen({super.key});

  @override
  State<ConsentRaiseScreen> createState() => _ConsentRaiseScreenState();
}

class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ConsentQuestionResponse? consentQuestionResponse;
  bool loading = false;
  bool buttonLoad = false;

  Map<int, dynamic> answers = {};
  Map<int, dynamic> goalAnswer = {};

  // Controllers and focus nodes
  final _controllers = <String, TextEditingController>{};
  final _focusNodes = <String, FocusNode>{};
  TextEditingController? phoneNumberController;
  String sPhoneNumber = '';
  String sCountryCode = '';
  FocusNode phoneNumberFocusNode = FocusNode();
  // Map to store TextEditingControllers for each question of type 4
  Map<int, TextEditingController> descriptionControllers = {};
  // Dropdown values for Company Size
  String? selectedCompanySize;
  List<String> companySizeList = [
    'Under 100 Employees',
    '101-250 Employees',
    '251-750 Employees',
    '751-999 Employees',
    '1,000+ Employees'
  ];
  // Map to store error messages for each field
  Map<String, dynamic> fieldErrors = {};
  // Store selected boolean values for each question by question ID
  Map<int, List<int>> selectedMultiSelectValues = {};
  List<Category> sponsors = [];

  Category? selectedSponsorId;
  bool isOtherSelected = false;
  String? otherSponsorErrorText;
  String? selectSponsorError;
  String? otherGoalString;
  final FocusNode selectedSponsorIdFocusNode = FocusNode();

  TextEditingController otherSponsorController = TextEditingController();
  final FocusNode otherSponsorFocusNode = FocusNode();

  // Change selectedBooleanValues to store int
  Map<int, int?> selectedBooleanValues = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchConsentData();
    consentQuestionResponse?.data?.forEach((question) {
      if (question.type == 4) {
        descriptionControllers[question.id!] = TextEditingController();
      }
    });
  }

  void _initializeControllers() {
    const fields = [
      'companyName',
      'contactName',
      'jobTitle',
      'email',
    ];
    for (var field in fields) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }
  }

  Future<void> _fetchConsentData() async {
    setState(() => loading = true);
    await _getGoalsDropdown();
    await _consentQuestionsApi();
    setState(() => loading = false);
  }

  Future<void> _getGoalsDropdown() async {
    try {
      var response = await goalsDropdown();
      if (response?.status == true) {
        sponsors = response?.data ?? [];
      } else {
        _showError(response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
    }
  }

  Future<void> _consentQuestionsApi() async {
    try {
      var response = await consentQuestions();
      if (response?.status == true) {
        setState(() => consentQuestionResponse = response);
      } else {
        _showError(response?.message ?? 'Failed to fetch data');
      }
    } catch (e) {
      debugPrint('Error fetching consent questions: $e');
    }
  }

  String _generateJson() {
    final companySize = _getCompanySizeIndex(selectedCompanySize);
    final questions = answers.entries.map((entry) {
      final isGoal = entry.value is List && entry.value.contains(0);
      final answerData = _formatAnswer(entry.value, isGoal);
      return {
        "question_id": entry.key.toString(),
        "is_goal": isGoal,
        "answers": answerData,
        if (isGoal) "other_goals": goalAnswer[entry.key] ?? ""
      };
    }).toList();

    return jsonEncode({
      "email": _controllers['email']?.text ?? "",
      "contact_name": _controllers['contactName']?.text ?? "",
      "company_name": _controllers['companyName']?.text ?? "",
      "company_size": companySize,
      "contact_job_title": _controllers['jobTitle']?.text ?? "",
      "questions": questions
    });
  }

  int _getCompanySizeIndex(String? companySize) {
    const companySizes = {
      'Under 100 Employees': 0,
      '101-250 Employees': 1,
      '251-750 Employees': 2,
      '751-999 Employees': 3,
      '1,000+ Employees': 4
    };
    return companySizes[companySize] ?? 0;
  }

  dynamic _formatAnswer(dynamic answer, bool isGoal) {
    if (answer is List) {
      return answer.map((e) => e is bool ? (e ? 1 : 0) : e).toList();
    } else if (answer is bool) {
      return answer ? '1' : '0';
    }
    return answer;
  }

  void _showError(String message) {
    SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error, message);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => buttonLoad = true);
    try {
      var response = await consentRaise(jsonDecode(_generateJson()));
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, response?.message ?? 'Success');
        Navigator.of(context).pop();
      } else {
        _showError(response?.message ?? 'Failed to submit');
      }
    } catch (e) {
      debugPrint('Error submitting consent: $e');
    } finally {
      setState(() => buttonLoad = false);
    }
  }

  Widget _buildTextFormField(String label, String field, String hint) =>
      textFormField(
        label: label,
        hintText: hint,
        controller: _controllers[field],
        focusNode: _focusNodes[field],
        validator: (value) =>
            value == null || value.isEmpty ? '$label cannot be empty' : null,
      ).paddingBottom(16);

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
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          header(context),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _buildTextFormField('Company Name*',
                                    'companyName', 'Enter Company Name'),
                                _buildTextFormField('Contact Name*',
                                    'contactName', 'Enter Contact Name'),
                                _buildTextFormField('Job Title*', 'jobTitle',
                                    'Enter Job Title'),
                                _buildTextFormField(
                                    'Email Address*', 'email', 'Enter Email'),
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
                                ListView.builder(
                                  itemCount:
                                      consentQuestionResponse?.data?.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final question =
                                        consentQuestionResponse?.data?[index];
                                    switch (question?.type) {
                                      case 1: // Question Type 1 - Single Selection Dropdown
                                        return _buildSingleSelectDropdownTypeOne(
                                                question)
                                            .paddingBottom(20);
                                      case 2: // Question Type 2 - Multiple Selection Dropdown
                                        return _buildMultiSelectDropdownTypeTwo(
                                                question)
                                            .paddingBottom(20);
                                      case 3: // Question Type 3 - Followed Up (Yes/No) radio buttons
                                        return _buildFollowedUpQuestionTypeThree(
                                                question)
                                            .paddingBottom(20);
                                      case 4: // Question Type 4 - Make Number of textFormFields
                                        return _buildNumberOfTextFormFieldTypeFour(
                                                question)
                                            .paddingBottom(20);
                                      case 5: // Question Type 5 - Extendable Multiple Selection Dropdown
                                        return _buildMultipleSelectionDropdownTypeFive(
                                                question)
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
                  submitConsentButton(context, buttonLoading: buttonLoad,
                      onPressed: () async {
                    hideKeyboard(context);
                    if (_formKey.currentState!.validate()) {
                      await _submitForm();
                    } else {
                      return;
                    }
                  }),
                ],
              ),
      );

  /// Question Type 5 - Extendable Multiple Selection Dropdown
  Widget _buildMultipleSelectionDropdownTypeFive(Question? question) =>
      DropdownWithMultiSelectAndAddNewItem(
        question: question,
        goalslistfromapi: sponsors, // List fetched from API
        onSelectedItemsChanged: (selectedItems, otherSponsorText) {
          setState(() {
            if (selectedItems.isNotEmpty) {
              answers[question!.id!] =
                  selectedItems.map((item) => item.id).toList();
            } else {
              answers[question!.id!] = []; // Handle empty selection case
            }
            goalAnswer[question.id!] =
                otherSponsorText; // Handle "other" goal text
          });
        },
      );

  /// Question Type 4 - Make Number of textFormFields
  Widget _buildNumberOfTextFormFieldTypeFour(Question? question) {
    final controller = descriptionControllers[question!.id!];
    return textFormField(
      label: question.question ?? '',
      controller: controller,
      hintText: 'Enter Description',
      maxLines: 3,
      onChanged: (value) {
        // Update the global answers map with the text input
        answers[question.id!] = value;
      },
    );
  }

  /// Question Type 3 - Followed Up Question
  /// If the question is followed up then on the bases of question values Yes/No
  /// In this method more UI will made
  Widget _buildFollowedUpQuestionTypeThree(Question? question) {
    final questionId = question?.id ?? 0;
    var selectedValue = selectedBooleanValues[questionId];

    return labelContainer(
      label: question?.question ?? '',
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        children: question?.options?.map((option) {
              var isYes = option.value == 'Yes';
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

  /// Question Type 2 - Multiple Selection Dropdown
  Widget _buildMultiSelectDropdownTypeTwo(Question? question) {
    // Convert List<Option> to List<Category>
    var categories = question?.options
            ?.map((option) => Category(id: option.id, name: option.value))
            .toList() ??
        [];
    var selectedValues = selectedMultiSelectValues[question!.id] ?? [];

    return DropdownWithMultipleSelection(
      label: question.question ?? 'Select options',
      options: categories, // Pass the converted categories
      initialSelectedValues: selectedValues,
      onSelectionChanged: (selectedValues) {
        setState(() {
          // Save the selected values in the answers and selectedMultiSelectValues maps
          selectedMultiSelectValues[question.id!] = selectedValues;
          answers[question.id!] = selectedValues;
        });
      },
    );
  }

  /// Question Type 1 - Single Selection Dropdown
  Widget _buildSingleSelectDropdownTypeOne(Question? question) =>
      labelContainer(
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

  @override
  void dispose() {
    descriptionControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
