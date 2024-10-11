import 'package:flutter/material.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/models/question_model.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:nb_utils/nb_utils.dart';

Column header(BuildContext context) => Column(
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
      ],
    );

Positioned submitConsentButton(BuildContext context,
        {required void Function()? onPressed, required bool buttonLoading}) =>
    Positioned(
      bottom: 16,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              child: button(context,
                  onPressed: onPressed,
                  isLoading: buttonLoading,
                  text: 'Submit')),
        ),
      ),
    );

/// Question Type 2 - Multiple Selection Dropdown
class DropdownWithMultipleSelection extends StatefulWidget {
  // Callback to pass selected values

  const DropdownWithMultipleSelection({
    Key? key,
    required this.label,
    required this.options,
    required this.initialSelectedValues,
    required this.onSelectionChanged,
  }) : super(key: key);
  final String label;
  final List<Category> options; // List of options (categories)
  final List<int> initialSelectedValues; // List of initially selected IDs
  final Function(List<int>) onSelectionChanged;

  @override
  _DropdownWithMultipleSelectionState createState() =>
      _DropdownWithMultipleSelectionState();
}

class _DropdownWithMultipleSelectionState
    extends State<DropdownWithMultipleSelection> {
  List<int> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialSelectedValues;
  }

  @override
  Widget build(BuildContext context) => labelContainer(
        label: widget.label,
        width: MediaQuery.of(context).size.width,
        child: MultiSelectDialogField(
          items: widget.options
              .map((category) =>
                  MultiSelectItem(category.id, category.name ?? ''))
              .toList(),
          title: const Text('Select'),
          decoration: const BoxDecoration(),
          buttonIcon: const Icon(Icons.arrow_drop_down),
          buttonText: Text(
            'Select',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          initialValue: _selectedValues, // Ensures proper type usage
          onConfirm: (values) {
            setState(() {
              _selectedValues = List<int>.from(values);
            });
            // Callback to parent with the updated selected values
            widget.onSelectionChanged(_selectedValues);
          },
          chipDisplay: MultiSelectChipDisplay(
            chipColor: Theme.of(context).cardColor,
            textStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            onTap: (value) {
              // setState(() {
              //   _selectedValues.remove(value);
              // });
              // widget.onSelectionChanged(_selectedValues);
            },
          ),
        ),
      );
}

/// Question Type 5 - Extendable Multiple Selection Dropdown
class DropdownWithMultiSelectAndAddNewItem extends StatefulWidget {
  const DropdownWithMultiSelectAndAddNewItem({
    Key? key,
    this.question,
    required this.goalslistfromapi,
    required this.onSelectedItemsChanged,
  }) : super(key: key);
  final Question? question;
  final List<Category> goalslistfromapi;
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
    if (!widget.goalslistfromapi.any((item) => item.id == 0)) {
      widget.goalslistfromapi.add(Category(id: 0, name: 'Other'));
    }
  }

  void _onConfirm(List<dynamic> values) {
    setState(() {
      selectedItems = List<Category>.from(values);
      isOtherSelected = selectedItems.any((item) => item.id == 0);
      widget.onSelectedItemsChanged(selectedItems, otherGoalController.text);
    });
  }

  // void _onChipTap(Category item) {
  //   setState(() {
  //     selectedItems.remove(item);
  //     isOtherSelected = selectedItems.any((element) => element.id == 0);
  //     widget.onSelectedItemsChanged(selectedItems, otherGoalController.text);
  //   });
  // }

  void _onOtherGoalChanged(String value) {
    if (value.isNotEmpty) {
      var customGoal = Category(id: 0, name: value);
      if (!selectedItems.contains(customGoal)) {
        setState(() {
          selectedItems.add(customGoal);
        });
      }
      widget.onSelectedItemsChanged(selectedItems, value);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelContainer(
            label: widget.question?.question ?? '',
            width: MediaQuery.of(context).size.width,
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
                  onConfirm: _onConfirm,
                  chipDisplay: MultiSelectChipDisplay(
                    items: selectedItems
                        .map((item) => MultiSelectItem(item, item.name ?? ''))
                        .toList(),
                    chipColor: Theme.of(context).cardColor,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    // onTap: _onChipTap,
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
                      onChanged: _onOtherGoalChanged,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );

  @override
  void dispose() {
    otherGoalController.dispose();
    super.dispose();
  }
}
