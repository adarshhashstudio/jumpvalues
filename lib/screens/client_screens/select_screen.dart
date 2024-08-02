import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/corevalues_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen(
      {super.key,
      required this.isFromProfile,
      this.isCategories = false,
      required this.initialSelectedValues});
  final bool isFromProfile;
  final bool isCategories;
  final List<CoreValue> initialSelectedValues;

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  List<CoreValue> toneList = [];
  List<CoreValue> filteredToneList = [];
  Set<CoreValue> selectedTones = {}; // Changed to Set<String>
  bool selectedToneError = false;
  bool loader = false;

  @override
  void initState() {
    selectedTones = widget.initialSelectedValues.toSet(); // Initialize selectedTones with initial selected values
    getAllComprehensive();
    super.initState();
  }

  Future<void> getAllComprehensive() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getAllComprehensiveValues(
          widget.isCategories ? 'category/dropdown' : 'core_value/dropdown');
      if (response?.status == true) {
        setState(() {
          // Clear existing data in toneList before adding new data
          toneList.clear();

          // Add fetched data from API into toneList
          if (response?.data != null) {
            toneList.addAll(response?.data ?? []);
          }
        });
        filteredToneList = List.from(
            toneList); // Initialize filteredToneList with the same contents as toneList initially
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getAllComprehensive Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> saveSelectedComprehensive() async {
    setState(() {
      loader = true;
    });
    try {
      var request = <String, dynamic>{
        'client_id': appStore.userId.toString(),
      };

      var comprensiveListingIds = <String>[];

      for (var element in selectedTones) {
        comprensiveListingIds.add('${element.id}');
      }

      request['coreValueIds'] = comprensiveListingIds;

      debugPrint('Request Map: $request');
      var response = await addUserComprehensiveListing(request);
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Saved Successfully.');
        if (widget.isFromProfile) Navigator.of(context).pop(true);
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('saveSelectedComprehensive Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var selectedTonesList = <CoreValue>[];
    var unselectedTonesList = <CoreValue>[];

    // Split toneList into selected and unselected tones
    for (var tone in toneList) {
      if (selectedTones.any((selectedTone) => selectedTone.id == tone.id)) {
        selectedTonesList.add(tone);
      } else {
        unselectedTonesList.add(tone);
      }
    }
    return Scaffold(
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
            if (loader) {
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 14.0),
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.isCategories ? 'Select (Categories)' : 'Select (Core Values)',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
              fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display selected tones at the top
            if (selectedTonesList.isNotEmpty)
              selectionContainerForAll(
                context,
                spaceBelowTitle: MediaQuery.of(context).size.height * 0.02,
                heading: 'Selected Values',
                children: [
                  for (var tone in selectedTonesList)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFF43A146),
                          border: Border.all(width: 0.05),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        tone.name ?? '',
                        style: const TextStyle(color: white),
                      ),
                    ),
                ],
              ),
            // Display unselected tones below selected tones
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormField(
                          label: '',
                          isLabel: false,
                          hintText: 'Search Value',
                          onChanged: (value) {
                            setState(() {
                              filteredToneList = toneList
                                  .where((tone) => tone.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        selectionContainerForAll(
                          context,
                          heading: 'Select up to 10 Values',
                          isError: selectedToneError,
                          isLoading: loader,
                          children: [
                            for (var tone in filteredToneList)
                              customCheck(
                                context,
                                text: tone.name,
                                onTap: () {
                                  hideAppKeyboard(context);
                                  setState(() {
                                    if (selectedTones.any((selectedTone) =>
                                        selectedTone.id == tone.id)) {
                                      // If the tone is already selected, remove it
                                      selectedTones.removeWhere(
                                          (selectedTone) =>
                                              selectedTone.id == tone.id);
                                    } else if (selectedTones.length < 10) {
                                      // If the tone is not selected and selection count is less than 10, add it
                                      selectedTones.add(tone);
                                    }
                                    // Update error state
                                    selectedToneError = false;
                                  });
                                },
                                isSelected: selectedTones.any((selectedTone) =>
                                    selectedTone.id == tone.id),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: button(
                context,
                onPressed: () async {
                  // Handle Done button press
                  if (selectedTones.isEmpty || selectedTones.length > 10) {
                    setState(() {
                      selectedToneError = true;
                    });
                  } else {
                    await saveSelectedComprehensive();
                  }
                },
                text:
                    'Update ${widget.isCategories ? 'Categories' : 'Core Values'}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customCheck(BuildContext context,
          {String? text, bool isSelected = false, Function()? onTap}) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : Theme.of(context).cardColor,
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            text ?? '',
            style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      );
}
