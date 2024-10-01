import 'package:flutter/material.dart';
import 'package:jumpvalues/models/question_model.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

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

class ConsentRaiseScreen extends StatefulWidget {
  @override
  _ConsentRaiseScreenState createState() => _ConsentRaiseScreenState();
}

class _ConsentRaiseScreenState extends State<ConsentRaiseScreen> {
  // Simulate fetching JSON data
  List<Map<String, dynamic>> sampleJsonData = [
    {
      "id": "1",
      "question": "Select your favorite colors",
      "type": "multi-select",
      "options": [
        {"id": 1, "value": "Red"},
        {"id": 2, "value": "Blue"},
        {"id": 3, "value": "Green"},
      ]
    },
    {
      "id": "2",
      "question": "Describe your request",
      "type": "description",
      "options": []
    },
    {
      "id": "3",
      "question": "Select a goal",
      "type": "goals",
      "options": [
        {"id": 1, "value": "Goal 1"},
        {"id": 2, "value": "Goal 2"},
      ]
    },
    {
      "id": "4",
      "question": "Pick your preference",
      "type": "single",
      "options": [
        {"id": 1, "value": "Option 1"},
        {"id": 2, "value": "Option 2"},
      ]
    }
  ];

  late List<QuestionModel> questions;

  @override
  void initState() {
    super.initState();
    // Convert JSON data to list of QuestionModel objects
    questions = sampleJsonData.map((json) => QuestionModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consent Raise Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // Pass the questions to the DynamicForm
              child: DynamicForm(questions: questions),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle form submission or action
                _submitForm();
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Logic to collect and submit the form data
    // You can access the form data via the formData map from DynamicForm
    print("Form submitted!");
  }
}

class DynamicForm extends StatefulWidget {
  final List<QuestionModel> questions;

  DynamicForm({required this.questions});

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.questions.length,
      itemBuilder: (context, index) {
        final question = widget.questions[index];
        return buildDynamicWidget(question);
      },
    );
  }

  Widget buildDynamicWidget(QuestionModel question) {
    switch (question.type) {
      case 'multi-select':
        return buildMultiSelectDropdown(question);
      case 'description':
        return buildDescriptionField(question);
      case 'goals':
        return buildGoalsDropdown(question);
      case 'single':
        return buildSingleSelectDropdown(question);
      default:
        return SizedBox.shrink();
    }
  }

  // Multi-select dropdown for 'multi-select' type
  Widget buildMultiSelectDropdown(QuestionModel question) {
    List<String> selectedValues = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question ?? ""),
        DropdownButtonFormField<String>(
          value: null,
          hint: Text("Select values"),
          onChanged: (value) {
            if (!selectedValues.contains(value)) {
              setState(() {
                selectedValues.add(value!);
              });
            }
          },
          items: question.options?.map((option) {
                return DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.value!),
                );
              }).toList() ??
              [],
          isExpanded: true,
        ),
        Wrap(
          children: selectedValues.map((value) {
            return Chip(
              label: Text(value),
              onDeleted: () {
                setState(() {
                  selectedValues.remove(value);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Single select dropdown for 'single' type
  Widget buildSingleSelectDropdown(QuestionModel question) {
    String? selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question ?? ""),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text("Select one"),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          items: question.options?.map((option) {
                return DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.value!),
                );
              }).toList() ??
              [],
          isExpanded: true,
        ),
      ],
    );
  }

  // Text form field for 'description' type
  Widget buildDescriptionField(QuestionModel question) {
    TextEditingController controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question ?? ""),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter details"),
          maxLines: 3,
          onChanged: (value) {
            formData[question.id!] = value;
          },
        ),
      ],
    );
  }

  // Goals dropdown with text input for adding new options
  Widget buildGoalsDropdown(QuestionModel question) {
    TextEditingController newGoalController = TextEditingController();
    List<String> goals = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question ?? ""),
        DropdownButtonFormField<String>(
          value: null,
          hint: Text("Select or add a goal"),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                goals.add(value);
              });
            }
          },
          items: goals.map((goal) {
            return DropdownMenuItem<String>(
              value: goal,
              child: Text(goal),
            );
          }).toList(),
          isExpanded: true,
        ),
        TextFormField(
          controller: newGoalController,
          decoration: InputDecoration(hintText: "Add new goal"),
          onFieldSubmitted: (newGoal) {
            setState(() {
              goals.add(newGoal);
              newGoalController.clear();
            });
          },
        ),
      ],
    );
  }
}
