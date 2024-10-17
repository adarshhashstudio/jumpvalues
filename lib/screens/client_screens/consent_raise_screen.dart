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
  // Map to store TextEditingControllers for each question of type 4
  Map<int, TextEditingController> descriptionControllers = {};
  TextEditingController otherSponsorController = TextEditingController();
  final FocusNode otherSponsorFocusNode = FocusNode();
  TextEditingController? phoneNumberController;
  FocusNode phoneNumberFocusNode = FocusNode();
  String sPhoneNumber = '';
  String sCountryCode = '';
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
    await _getGoalsDropdown();
  }

  Future<void> _getGoalsDropdown() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await goalsDropdown();
      if (response?.status == true) {
        sponsors = response?.data ?? [];
      } else {
        _showError(response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('Error fetching goals: $e');
    } finally {
      await _consentQuestionsApi();
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
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String _generateJson() {
    final companySize = _getCompanySizeIndex(selectedCompanySize);

    // Construct the questions list by iterating over all answer entries
    final questions = answers.entries.map((entry) {
      final questionId = entry.key.toString(); // Question ID as a string
      final answerValue = entry.value; // Current answer value
      final isGoal =
          _isGoalQuestion(answerValue); // Check if it's a goal-type question
      final otherGoals =
          goalAnswer[entry.key]; // Get other goals for this question
      final formattedAnswer =
          _formatAnswer(answerValue, isGoal, otherGoals); // Format the answer

      // Build the question object
      return {
        'question_id': questionId,
        'is_goal': isGoal,
        'answers': formattedAnswer,
        if (isGoal) 'other_goals': otherGoals ?? ''
      };
    }).toList();

    // Construct the final JSON object for API submission
    return jsonEncode({
      'email': _controllers['email']?.text ?? '',
      'contact_name': _controllers['contactName']?.text ?? '',
      'company_name': _controllers['companyName']?.text ?? '',
      'company_size': companySize,
      'contact_job_title': _controllers['jobTitle']?.text ?? '',
      'country_code': sCountryCode,
      'phone': sPhoneNumber,
      'questions': questions
    });
  }

  /// Check if the answer is a goal-type question
  bool _isGoalQuestion(dynamic answer) => answer is List && answer.contains(0);

  int _getCompanySizeIndex(String? companySize) {
    // Mapping for company size options
    const companySizes = {
      'Under 100 Employees': 0,
      '101-250 Employees': 1,
      '251-750 Employees': 2,
      '751-999 Employees': 3,
      '1,000+ Employees': 4
    };
    return companySizes[companySize] ?? 0; // Default to 0 if not found
  }

  dynamic _formatAnswer(dynamic answer, bool isGoal, String? otherGoals) {
    // Handle formatting of answers based on type
    if (answer is List) {
      // Convert boolean to 1/0 for lists
      var formattedList =
          answer.map((e) => e is bool ? (e ? 1 : 0) : e).toList();

      // If it's a goal and other_goals is not empty, remove 0 from the list
      if (isGoal && otherGoals != null && otherGoals.isNotEmpty) {
        formattedList.remove(0);
      }

      return formattedList; // Return the formatted list
    } else if (answer is bool) {
      return answer ? '1' : '0'; // Convert boolean to string for single answers
    } else if (answer is int) {
      return answer.toString(); // Convert integers to string
    }
    return answer; // Return as is for strings or other types
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
                                  keyboardType: TextInputType.number,
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
                                ListView.separated(
                                  itemCount:
                                      consentQuestionResponse!.data!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  itemBuilder: (context, index) {
                                    final question =
                                        consentQuestionResponse?.data?[index];
                                    switch (question?.type) {
                                      case 1: // Question Type 1 - Single Selection Dropdown
                                        return _buildSingleSelectDropdownTypeOne(
                                            question);
                                      case 2: // Question Type 2 - Multiple Selection Dropdown
                                        return _buildMultiSelectDropdownTypeTwo(
                                            question);
                                      case 3: // Question Type 3 - Followed Up (Yes/No) radio buttons
                                        return _buildFollowedUpQuestionTypeThree(
                                            question);
                                      case 4: // Question Type 4 - Make Number of textFormFields
                                        return _buildNumberOfTextFormFieldTypeFour(
                                            question);
                                      case 5: // Question Type 5 - Extendable Multiple Selection Dropdown
                                        return _buildMultipleSelectionDropdownTypeFive(
                                            question);
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
  /// If the question is followed up then based on question values Yes/No
  /// In this method more UI will be made
  Widget _buildFollowedUpQuestionTypeThree(Question? mainQuestion) {
    final questionId = mainQuestion?.id ?? 0;
    var selectedValue = selectedBooleanValues[
        questionId]; // Get the selected value for this question

    return Column(
      children: [
        labelContainer(
          label: mainQuestion?.question ?? '',
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: mainQuestion?.options
                    ?.map((option) => Expanded(
                          child: RadioListTile<int>(
                            title: Text(option.value ??
                                ''), // Display the option label (Yes/No)
                            value: option.id ??
                                0, // Use the option's id as the value
                            groupValue:
                                selectedValue, // Ensure this holds the selected option's id
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  selectedBooleanValues[questionId] = value;

                                  // Store true for 'Yes' and false for 'No' in answers
                                  answers[questionId] = value ==
                                      0; // Assuming 0 is Yes, and 1 is No
                                } else {
                                  // Handle the null case
                                  selectedBooleanValues[questionId] =
                                      0; // Default or fallback value
                                  answers[questionId] =
                                      false; // Default to false when no value is selected
                                }

                                // Check for follow-up question visibility
                                _updateFollowUpVisibility(mainQuestion);
                              });
                            },
                          ),
                        ))
                    .toList() ??
                [],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // Only show follow-up questions if they exist and are visible
        if (mainQuestion?.followUpQuestions != null &&
            mainQuestion!.followUpQuestions!.isNotEmpty)
          ListView.separated(
            itemCount: mainQuestion.followUpQuestions!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            itemBuilder: (context, index) {
              final innQuestion = mainQuestion.followUpQuestions![index];
              // Determine if this follow-up question should be shown
              final shouldShowFollowUp = _shouldShowFollowUp(
                innQuestion,
                selectedValue,
                innQuestion.dependentQId!,
              );

              return shouldShowFollowUp
                  ? _buildFollowUpQuestion(innQuestion)
                  : const SizedBox(); // Return an empty container if the question shouldn't be shown
            },
          ),
      ],
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

    return Column(
      children: [
        DropdownWithMultipleSelection(
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
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // Only show follow-up questions if they exist and are visible
        if (question.followUpQuestions != null &&
            question.followUpQuestions!.isNotEmpty)
          ListView.separated(
            itemCount: question.followUpQuestions!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            itemBuilder: (context, index) {
              final innQuestion = question.followUpQuestions![index];
              // Determine if this follow-up question should be shown
              final shouldShowFollowUp =
                  _shouldShowFollowUpForMultipleSelection(
                innQuestion,
                selectedValues,
                innQuestion.dependentQId!,
              );

              return shouldShowFollowUp
                  ? _buildFollowUpQuestion(innQuestion)
                  : const SizedBox(); // Return an empty container if the question shouldn't be shown
            },
          ),
      ],
    );
  }

  /// Question Type 1 - Single Selection Dropdown
  Widget _buildSingleSelectDropdownTypeOne(Question? question) => Column(
        children: [
          labelContainer(
            label: question?.question ?? '',
            width: MediaQuery.of(context).size.width * 1,
            child: DropdownButtonFormField<int>(
              value: answers[question?.id] as int?,
              items: question?.options
                  ?.map((option) => DropdownMenuItem<int>(
                        value: option.id,
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
                  debugPrint(
                      'Question Type 1 - Single Selection Dropdown: answers[question.id] : ${answers[question.id!]}');
                });
              },
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          // Only show follow-up questions if they exist and are visible
          if (question?.followUpQuestions != null &&
              question!.followUpQuestions!.isNotEmpty)
            ListView.separated(
              itemCount: question.followUpQuestions!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              itemBuilder: (context, index) {
                final innQuestion = question.followUpQuestions![index];
                // Determine if this follow-up question should be shown
                final shouldShowFollowUp = _shouldShowFollowUp(
                  innQuestion,
                  answers[question.id!],
                  innQuestion.dependentQId!,
                );

                return shouldShowFollowUp
                    ? _buildFollowUpQuestion(innQuestion)
                    : const SizedBox(); // Return an empty container if the question shouldn't be shown
              },
            ),
        ],
      );

  /// Check if the follow-up question should be shown based on selected values
  bool _shouldShowFollowUpForMultipleSelection(
      Question followUpQuestion, List<int> selectedValueList, int questionId) {
    if (followUpQuestion.dependentQId == questionId &&
        followUpQuestion.dependencyValue != null) {
      // Assuming dependency_value is a String representation of the selected value
      // Convert dependencyValue to an int for comparison
      var dependencyValueInt =
          int.tryParse(followUpQuestion.dependencyValue!) ?? -1;

      // Check if the selectedValueList contains the dependencyValue
      return selectedValueList.contains(dependencyValueInt);
    }
    return false; // Default to not showing if conditions are not met
  }

  /// Check if the follow-up question should be shown based on selected values
  bool _shouldShowFollowUp(
      Question followUpQuestion, int? selectedValue, int questionId) {
    if (followUpQuestion.dependentQId == questionId &&
        followUpQuestion.dependencyValue != null) {
      // Assuming dependency_value is a String representation of the selected value
      return selectedValue.toString() == followUpQuestion.dependencyValue;
    }
    return false; // Default to not showing if conditions are not met
  }

  /// Method to update any visibility conditions for follow-up questions
  void _updateFollowUpVisibility(Question? mainQuestion) {
    // This can be used for additional logic in the future if needed
    // For now, it can remain empty or contain any necessary updates you want
    setState(() {
      // This forces a rebuild; currently, the logic for showing follow-ups is handled directly in the builder
    });
  }

  /// Method to build follow-up questions based on their type
  Widget _buildFollowUpQuestion(Question followUpQuestion) {
    switch (followUpQuestion.type) {
      case 1: // Question Type 1 - Single Selection Dropdown
        return _buildSingleSelectDropdownTypeOne(followUpQuestion);
      case 2: // Question Type 2 - Multiple Selection Dropdown
        return _buildMultiSelectDropdownTypeTwo(followUpQuestion);
      case 3: // Question Type 3 - Followed Up (Yes/No) radio buttons
        return _buildFollowedUpQuestionTypeThree(followUpQuestion);
      case 4: // Question Type 4 - Make Number of textFormFields
        return _buildNumberOfTextFormFieldTypeFour(followUpQuestion);
      case 5: // Question Type 5 - Extendable Multiple Selection Dropdown
        return _buildMultipleSelectionDropdownTypeFive(followUpQuestion);
      default:
        return const SizedBox(); // Return empty container for unsupported types
    }
  }

  @override
  void dispose() {
    phoneNumberController?.dispose();
    phoneNumberFocusNode.dispose();
    otherSponsorController.dispose();
    otherSponsorFocusNode.dispose();
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    _focusNodes.forEach((key, focusNode) {
      focusNode.dispose();
    });
    descriptionControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
