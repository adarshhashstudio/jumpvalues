import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/client_profile_response_model.dart';
import 'package:jumpvalues/models/coach_profile_response_model.dart';
import 'package:jumpvalues/models/corevalues_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/client_screens/select_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart'
    as phoneNumberParser;

class CommonProfile extends StatefulWidget {
  const CommonProfile({super.key});

  @override
  State<CommonProfile> createState() => _CommonProfileState();
}

class _CommonProfileState extends State<CommonProfile> {
  // Map to store error messages for each field
  Map<String, String> fieldErrors = {};

  // Personal Details
  final GlobalKey<FormState> _personalDetailsFormKey = GlobalKey<FormState>();

  // Declare controllers
  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? positionController;
  TextEditingController? aboutController;

  // Declare focus nodes
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode aboutFocusNode = FocusNode();

  // Additional Details
  final GlobalKey<FormState> _additionalDetailsFormKey = GlobalKey<FormState>();

  // Declare controllers
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController preferViaController = TextEditingController();
  TextEditingController philosophyController = TextEditingController();
  TextEditingController certificationController = TextEditingController();
  TextEditingController industriesServedController = TextEditingController();
  TextEditingController coachingYearsController = TextEditingController();
  TextEditingController nicheController = TextEditingController();

  // Declare focus nodes
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode educationFocusNode = FocusNode();
  FocusNode preferViaFocusNode = FocusNode();
  FocusNode philosophyFocusNode = FocusNode();
  FocusNode certificationFocusNode = FocusNode();
  FocusNode industriesServedFocusNode = FocusNode();
  FocusNode coachingYearsFocusNode = FocusNode();
  FocusNode nicheFocusNode = FocusNode();

  // Variables for storing phone number and country code
  String sPhoneNumber = '';
  String sCountryCode = '';
  String sCountryIsoCode = 'US';

  String? selectedPreferVia;

  bool loader = false;
  bool loadingUserData = false;
  var userName = '';
  var email = '';
  String? profilePic;
  String? sponsorName;
  ClientProfileResponseModel? clientProfileResponseModel;
  CoachProfileResponseModel? coachProfileResponseModel;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    isTokenAvailable(context);
    loadUserData();
    if (appStore.userTypeCoach) {
      getCoachUser();
    } else {
      getClientUser();
    }
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    firstNameController?.dispose();
    lastNameController?.dispose();
    positionController?.dispose();
    aboutController?.dispose();
    phoneNumberController.dispose();
    educationController.dispose();
    preferViaController.dispose();
    philosophyController.dispose();
    certificationController.dispose();
    industriesServedController.dispose();
    coachingYearsController.dispose();
    nicheController.dispose();

    // Dispose focus nodes
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    positionFocusNode.dispose();
    aboutFocusNode.dispose();
    educationFocusNode.dispose();
    preferViaFocusNode.dispose();
    philosophyFocusNode.dispose();
    certificationFocusNode.dispose();
    industriesServedFocusNode.dispose();
    coachingYearsFocusNode.dispose();
    nicheFocusNode.dispose();

    super.dispose();
  }

  Future<void> updateProfile() async {
    setState(() {
      loader = true;
      fieldErrors.clear();
    });

    var request = <String, dynamic>{};

    void addIfNotEmpty(String key, String? value) {
      // if (value != null && value.isNotEmpty) {
      request[key] = value;
      // }
    }

    addIfNotEmpty('first_name', firstNameController?.text);
    addIfNotEmpty('last_name', lastNameController?.text);
    addIfNotEmpty('country_code', sCountryCode);
    addIfNotEmpty('phone', sPhoneNumber);
    addIfNotEmpty('education', educationController.text);
    addIfNotEmpty('philosophy', philosophyController.text);
    addIfNotEmpty('certifications', certificationController.text);
    addIfNotEmpty('industries_served', industriesServedController.text);
    addIfNotEmpty('experiance', coachingYearsController.text);
    addIfNotEmpty('niche', nicheController.text);

    if (appStore.userTypeCoach) {
      request['prefer_via'] = selectedPreferVia == 'Phone' ? 2 : 1;
    } else {
      addIfNotEmpty('position', positionController?.text);
      addIfNotEmpty('about_me', aboutController?.text);
    }

    var endPoint = appStore.userTypeCoach
        ? 'coach/update/${appStore.userId}'
        : 'client/update/${appStore.userId}';

    try {
      var response = await updateUserProfile(request, endPoint);

      setState(() {
        loader = false;
      });

      if (response?.status == true) {
        await refreshData().then((v) {
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.success,
            response?.message ?? '',
          );
        });
      } else {
        if (response?.errors?.isNotEmpty ?? false) {
          // Set field errors and focus on the first error field
          response?.errors?.forEach((e) {
            fieldErrors[e.field ?? '0'] = e.message ?? '0';
          });
          // Focus on the first error
          if (fieldErrors.containsKey('first_name')) {
            FocusScope.of(context).requestFocus(firstNameFocusNode);
          } else if (fieldErrors.containsKey('last_name')) {
            FocusScope.of(context).requestFocus(lastNameFocusNode);
          } else if (fieldErrors.containsKey('phone')) {
            FocusScope.of(context).requestFocus(phoneNumberFocusNode);
          } else if (fieldErrors.containsKey('education')) {
            FocusScope.of(context).requestFocus(educationFocusNode);
          } else if (fieldErrors.containsKey('philosophy')) {
            FocusScope.of(context).requestFocus(philosophyFocusNode);
          } else if (fieldErrors.containsKey('certifications')) {
            FocusScope.of(context).requestFocus(certificationFocusNode);
          } else if (fieldErrors.containsKey('industries_served')) {
            FocusScope.of(context).requestFocus(industriesServedFocusNode);
          } else if (fieldErrors.containsKey('experiance')) {
            FocusScope.of(context).requestFocus(coachingYearsFocusNode);
          } else if (fieldErrors.containsKey('niche')) {
            FocusScope.of(context).requestFocus(nicheFocusNode);
          } else if (fieldErrors.containsKey('position')) {
            FocusScope.of(context).requestFocus(positionFocusNode);
          } else if (fieldErrors.containsKey('about_me')) {
            FocusScope.of(context).requestFocus(aboutFocusNode);
          }
        } else {
          // Handle other errors
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.error,
            response?.message ?? 'Something went wrong, Try after sometime.',
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

  Future<void> loadUserData({bool loading = false}) async {
    if (loading) {
      setState(() {
        loadingUserData = true;
      });
    }
    if (appStore.userTypeCoach) {
      // ----- Coach Data
      educationController = TextEditingController(text: appStore.userEducation);
      preferViaController = TextEditingController(text: appStore.userPreferVia);
      philosophyController =
          TextEditingController(text: appStore.userPhilosophy);
      certificationController =
          TextEditingController(text: appStore.userCertifications);
      industriesServedController =
          TextEditingController(text: appStore.userIndustriesServed);
      coachingYearsController =
          TextEditingController(text: appStore.userExperiance.toString());
      nicheController = TextEditingController(text: appStore.userNiche);
      // selectedPreferVia = appStore.userPreferVia;
      selectedPreferVia = ['Phone', 'Email'].contains(appStore.userPreferVia)
          ? appStore.userPreferVia
          : 'Phone'; // Default to 'Phone' if the value is not valid
    } else {
      // ----- Client Data
      sponsorName = appStore.sponsorName;
      positionController = TextEditingController(text: appStore.userPosition);
      aboutController = TextEditingController(text: appStore.userAboutMe);
    }

    // ----- Common Data - Client/Coach
    firstNameController = TextEditingController(text: appStore.userFirstName);
    lastNameController = TextEditingController(text: appStore.userLastName);
    phoneNumberController = TextEditingController(
        text: numberToMaskedText('${appStore.userContactNumber}'));
    sCountryCode = appStore.userContactCountryCode;
    sCountryIsoCode = appStore.userContactCountryIsoCode;

    setState(() {
      userName = '${appStore.userFullName}';
      email = appStore.userEmail;
      profilePic = appStore.userProfilePic;
    });

    setState(() {
      loadingUserData = false;
    });

    debugPrint('Profile Pic: $domainUrl/$profilePic');
  }

  Future<void> setUserData() async {
    if (appStore.userTypeCoach) {
      if (coachProfileResponseModel != null) {
        await appStore.setUserId(coachProfileResponseModel?.data?.id);
        await appStore
            .setUserFirstName(coachProfileResponseModel?.data?.firstName ?? '');
        await appStore
            .setUserLastName(coachProfileResponseModel?.data?.lastName ?? '');
        await appStore
            .setUserEmail(coachProfileResponseModel?.data?.email ?? '');
        await appStore.setUserContactCountryCode(
            coachProfileResponseModel?.data?.countryCode ?? '+1');
        await appStore
            .setUserContactNumber(coachProfileResponseModel?.data?.phone ?? '');
        await appStore
            .setUserProfilePic(coachProfileResponseModel?.data?.dp ?? '');
        await appStore.setUserEducation(
            coachProfileResponseModel?.data?.coachProfile?.education ?? '');
        await appStore.setUserPreferVia(
            coachProfileResponseModel?.data?.coachProfile?.preferVia == 2
                ? 'Phone'
                : 'Email');
        await appStore.setUserPhilosophy(
            coachProfileResponseModel?.data?.coachProfile?.philosophy ?? '');
        await appStore.setUserCertifications(
            coachProfileResponseModel?.data?.coachProfile?.certifications ??
                '');
        await appStore.setUserIndustriesServed(
            coachProfileResponseModel?.data?.coachProfile?.industriesServed ??
                '');
        await appStore.setUserExperiance(
            coachProfileResponseModel?.data?.coachProfile?.experience ?? 0);
        await appStore.setUserNiche(
            coachProfileResponseModel?.data?.coachProfile?.niche ?? '');
        try {
          final phoneNumberType = phoneNumberParser.PhoneNumber.parse(
              '${appStore.userContactCountryCode}${appStore.userContactNumber}');
          await appStore
              .setUserContactCountryIsoCode('${phoneNumberType.isoCode.name}');
        } catch (e) {
          rethrow;
        }
      }
    } else {
      if (clientProfileResponseModel != null) {
        await appStore.setSponsorId(
            clientProfileResponseModel?.data?.clientProfile?.sponsorId);
        await appStore.setSponsorName(
            clientProfileResponseModel?.data?.clientProfile?.sponsor?.name ??
                '');
        await appStore.setUserId(clientProfileResponseModel?.data?.id);
        await appStore.setUserFirstName(
            clientProfileResponseModel?.data?.firstName ?? '');
        await appStore
            .setUserLastName(clientProfileResponseModel?.data?.lastName ?? '');
        await appStore
            .setUserEmail(clientProfileResponseModel?.data?.email ?? '');
        await appStore.setUserContactCountryCode(
            clientProfileResponseModel?.data?.countryCode ?? '+1');
        await appStore.setUserContactNumber(
            clientProfileResponseModel?.data?.phone ?? '');
        await appStore
            .setUserProfilePic(clientProfileResponseModel?.data?.dp ?? '');
        try {
          final phoneNumberType = phoneNumberParser.PhoneNumber.parse(
              '${appStore.userContactCountryCode}${appStore.userContactNumber}');
          await appStore
              .setUserContactCountryIsoCode('${phoneNumberType.isoCode.name}');
        } catch (e) {
          rethrow;
        }
      }
    }
    setState(() {});
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                // close the dialog
                Navigator.of(context).pop();
                // get image from gallery
                await getImageFromGallery().then((value) async {
                  if (_image != null) {
                    await uploadProfilePic();
                  } else {}
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Photo Gallery'),
              ),
            ),
            InkWell(
              onTap: () async {
                // close the dialog
                Navigator.of(context).pop();
                // get image from camera
                await getImageFromCamera().then((value) async {
                  if (_image != null) {
                    await uploadProfilePic();
                  } else {}
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Camera'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadProfilePic() async {
    setState(() {
      loader = true;
    });
    try {
      var userId = appStore.userId;
      if (userId == null) {
        throw Exception('User ID not found.');
      }

      var response =
          await updateUserProfilePic(userId: userId.toString(), image: _image);

      if (response?.status == true) {
        await refreshData().then((v) {
          SnackBarHelper.showStatusSnackBar(
            context,
            StatusIndicator.success,
            response?.message ?? 'Profile Pic Uploaded Successfully.',
          );
        });
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('uploadProfilePic Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> getClientUser() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getUserClientDetails(appStore.userId ?? -1);
      if (response?.status == true) {
        setState(() {
          clientProfileResponseModel = response;
        });
        await setUserData();
        await loadUserData();
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getClientUser Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> getCoachUser() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getUserCoachDetails(appStore.userId ?? -1);
      if (response?.status == true) {
        setState(() {
          coachProfileResponseModel = response;
        });
        await setUserData();
        await loadUserData();
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getCoachUser Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> refreshData() async {
    hideKeyboard(context);
    fieldErrors.clear();
    isTokenAvailable(context);
    await loadUserData();
    if (appStore.userTypeCoach) {
      await getCoachUser();
    } else {
      await getClientUser();
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: refreshData,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: loadingUserData
                            ? const CircularProgressIndicator()
                                .center()
                                .paddingTop(100)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildProfilePicWidget(context),
                                  personalDetails(context).paddingSymmetric(
                                      horizontal: 20, vertical: 10),
                                  additionalDetails(context)
                                      .paddingSymmetric(horizontal: 20),
                                ],
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: button(context, onPressed: () async {
                      if (loader) {
                      } else {
                        hideKeyboard(context);
                        await updateProfile();
                      }
                    }, text: 'Update Profile'),
                  ),
                ],
              ),
            ),
            if (loader)
              Container(
                  color: Colors.transparent,
                  child: const Center(child: CircularProgressIndicator()))
          ],
        ),
      );

  Widget selectedValuesWidget(BuildContext context,
          {required String heading, required List<CoreValue> list}) =>
      selectionContainerForAll(
        context,
        goToSelectValues: true,
        onTap: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => SelectScreen(
                      isFromProfile: true,
                      initialSelectedValues: list,
                      isCategories: (heading == 'Categories') ? true : false)))
              .then((updated) async {
            if (updated) {
              await refreshData();
            }
          });
        },
        spaceBelowTitle: MediaQuery.of(context).size.height * 0.02,
        heading: heading,
        children: [
          for (var tone in list)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
      );

  Widget personalDetails(BuildContext context) => Form(
        key: _personalDetailsFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appStore.userTypeCoach)
              Text(
                'Personal Details :',
                style: boldTextStyle(color: primaryColor),
              ).paddingOnly(bottom: 10, top: 10),
            if (appStore.userTypeCoach) divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (!appStore.userTypeCoach)
              labelContainer(
                  label: 'Sponsor',
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.05,
                  isDisable: true,
                  labelTextBoxSpace: 8,
                  text: sponsorName,
                  alignment: Alignment.centerLeft),
            if (!appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: textFormField(
                      controller: firstNameController,
                      label: 'First Name',
                      labelTextBoxSpace: 8,
                      focusNode: firstNameFocusNode,
                      errorText: fieldErrors['first_name'],
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      keyboardType: TextInputType.name,
                      hintText: 'Enter First Name',
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: textFormField(
                      controller: lastNameController,
                      label: 'Last Name',
                      focusNode: lastNameFocusNode,
                      errorText: fieldErrors['last_name'],
                      labelTextBoxSpace: 8,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      hintText: 'Enter Last Name',
                      textInputAction: TextInputAction.next),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (!appStore.userTypeCoach)
              textFormField(
                controller: positionController,
                label: 'Position',
                focusNode: positionFocusNode,
                errorText: fieldErrors['position'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Position',
              ),
            if (!appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (!appStore.userTypeCoach)
              textFormField(
                controller: aboutController,
                label: 'About',
                focusNode: aboutFocusNode,
                errorText: fieldErrors['about_me'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter your bio',
                maxLines: 3,
              ),
            if (!appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: const Text('My Values'),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  selectedValuesWidget(context,
                          heading: 'Core Values',
                          list: appStore.userTypeCoach
                              ? coachProfileResponseModel?.data?.coreValues ??
                                  []
                              : clientProfileResponseModel?.data?.coreValues ??
                                  [])
                      .paddingAll(10),
                  selectedValuesWidget(context,
                          heading: 'Categories',
                          list: appStore.userTypeCoach
                              ? coachProfileResponseModel?.data?.categories ??
                                  []
                              : clientProfileResponseModel?.data?.categories ??
                                  [])
                      .paddingAll(10),
                ],
              ),
            ),
            if (!appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
          ],
        ),
      );

  Widget additionalDetails(BuildContext context) => Form(
        key: _additionalDetailsFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appStore.userTypeCoach)
              Text(
                'Additional Details :',
                style: boldTextStyle(color: primaryColor),
              ).paddingOnly(bottom: 10, top: 10),
            if (appStore.userTypeCoach) divider(),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: educationController,
                label: 'Education',
                focusNode: educationFocusNode,
                errorText: fieldErrors['education'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Education',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
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
                  items: ['Phone', 'Email']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPreferVia = value;
                    });
                  },
                ),
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: philosophyController,
                label: 'Philosophy',
                focusNode: philosophyFocusNode,
                errorText: fieldErrors['philosophy'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Philosophy',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: certificationController,
                label: 'Certification',
                focusNode: certificationFocusNode,
                errorText: fieldErrors['certifications'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Certifications',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: industriesServedController,
                label: 'Industries Served',
                focusNode: industriesServedFocusNode,
                errorText: fieldErrors['industries_served'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Industries Served',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: coachingYearsController,
                label: 'Coaching Experience (In Years)',
                focusNode: coachingYearsFocusNode,
                errorText: fieldErrors['experiance'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter experience',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (appStore.userTypeCoach)
              textFormField(
                controller: nicheController,
                label: 'Niche',
                focusNode: nicheFocusNode,
                errorText: fieldErrors['niche'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Niche',
              ),
            if (appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
          ],
        ),
      );

  Container buildProfilePicWidget(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: Row(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: showOptions,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: profilePic != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(360),
                            child: CachedNetworkImage(
                              imageUrl: '$domainUrl/$profilePic',
                              fit: BoxFit.cover,
                              placeholder: (context, _) => Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          )
                        : _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Image.file(
                                  _image ?? File(''),
                                  fit: BoxFit.cover,
                                ))
                            : Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: GestureDetector(
                    onTap: showOptions,
                    child: Image.asset(
                      editImage,
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      );
}
