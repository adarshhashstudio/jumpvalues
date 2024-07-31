import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/user_data_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/client_screens/select_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:jumpvalues/utils/images.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

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

  bool loader = false;
  var userName = '';
  var email = '';
  String? profilePic;
  UserDataResponseModel? userData;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    isTokenAvailable(context);
    loadUserData();
    getUser();
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
      fieldErrors.clear(); // Clear previous errors
    });

    try {
      var req = <String, dynamic>{
        'firstName': firstNameController?.text ?? appStore.userFirstName,
        'lastName': lastNameController?.text ?? appStore.userLastName,
        'positions': positionController?.text ?? appStore.userPosition,
        'aboutMe': aboutController?.text ?? appStore.userAboutMe
      };
      var userId = appStore.userId;
      var response = await updateUserProfile(req, userId.toString());

      if (response?.statusCode == 200) {
        await setUserData();

        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Profile Updated Successfully.');
      } else {
        if (response?.error?.length == 1) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.error?[0].message ?? 'Unexpected Error Occurred.');
        } else {
          // Set field errors and focus on the first error field
          response?.error?.forEach((e) {
            fieldErrors[e.field!] = e.message!;
          });

          // Focus on the first error field
          if (fieldErrors.containsKey('firstName')) {
            FocusScope.of(context).requestFocus(firstNameFocusNode);
          } else if (fieldErrors.containsKey('lastName')) {
            FocusScope.of(context).requestFocus(lastNameFocusNode);
          } else if (fieldErrors.containsKey('positions')) {
            FocusScope.of(context).requestFocus(positionFocusNode);
          } else if (fieldErrors.containsKey('aboutMe')) {
            FocusScope.of(context).requestFocus(aboutFocusNode);
          }

          setState(() {});
        }
      }
    } catch (e) {
      debugPrint('updateProfile Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> loadUserData() async {
    firstNameController = TextEditingController(text: appStore.userFirstName);
    lastNameController = TextEditingController(text: appStore.userLastName);
    positionController = TextEditingController(text: appStore.userPosition);
    aboutController = TextEditingController(text: appStore.userAboutMe);
    setState(() {
      userName = '${appStore.userFullName}';
      email = appStore.userEmail;
      profilePic = appStore.userProfilePic;
    });

    // ----- Additional

    phoneNumberController = TextEditingController(text: '9988776655');
    educationController =
        TextEditingController(text: 'Saint Francis University');
    preferViaController = TextEditingController(text: 'Phone');
    philosophyController =
        TextEditingController(text: 'Client has the answers');
    certificationController = TextEditingController(text: 'ICF-PCC');
    industriesServedController = TextEditingController(text: 'FMCG, Financial');
    coachingYearsController = TextEditingController(text: '8.0');
    nicheController = TextEditingController(text: 'Corporate');

    debugPrint('Profile Pic: $baseUrl$profilePic');
  }

  Future<void> setUserData() async {
    await appStore.setUserFirstName(firstNameController?.text ?? '');
    await appStore.setUserLastName(lastNameController?.text ?? '');
    await appStore.setUserPosition(positionController?.text ?? '');
    await appStore.setUserAboutMe(aboutController?.text ?? '');

    setState(() {
      userName = '${appStore.userFullName}';
    });
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

      if (response?.statusCode == 200) {
        await appStore.setUserProfilePic(response?.data ?? '');
        setState(() {
          profilePic = appStore.userProfilePic;
        });
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.success,
          response?.message ?? 'Profile Pic Uploaded Successfully.',
        );
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

  Future<void> getUser() async {
    setState(() {
      loader = true;
    });
    try {
      var response = await getUserDetails(appStore.userId ?? -1);
      if (response?.statusCode == 200) {
        setState(() {
          userData = response;
        });
        setState(() {});
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? errorSomethingWentWrong);
        }
      }
    } catch (e) {
      debugPrint('getUser Error: $e');
    } finally {
      setState(() {
        loader = false;
      });
    }
  }

  Future<void> refreshData() async {
    isTokenAvailable(context);
    await loadUserData();
    await getUser();
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfilePicWidget(context),
                            personalDetails(context)
                                .paddingSymmetric(horizontal: 20, vertical: 10),
                            if (appStore.userTypeCoach)
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
          {required String heading, required List<ComprensiveListing> list}) =>
      selectionContainerForAll(
        context,
        goToSelectValues: true,
        onTap: () async {
          var updated = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SelectScreen()));
          if (updated) {
            await refreshData();
          } else {}
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
            labelContainer(
                label: 'Sponsor',
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.05,
                labelTextBoxSpace: 8,
                text: appStore.sponsorName,
                alignment: Alignment.centerLeft),
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
                      errorText: fieldErrors['firstName'],
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
                      errorText: fieldErrors['lastName'],
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            if (!appStore.userTypeCoach)
              textFormField(
                controller: positionController,
                label: 'Position',
                focusNode: positionFocusNode,
                errorText: fieldErrors['positions'],
                labelTextBoxSpace: 8,
                keyboardType: TextInputType.name,
                hintText: 'Enter Position',
              ),
            if (!appStore.userTypeCoach)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            textFormField(
              controller: aboutController,
              label: 'About',
              focusNode: aboutFocusNode,
              errorText: fieldErrors['aboutMe'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter your bio',
              maxLines: 3,
            ),
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
                          heading: appStore.userTypeCoach
                              ? 'Core Values'
                              : 'Selected Values',
                          list: userData?.data?.comprensiveListings ?? [])
                      .paddingAll(10),
                  if (appStore.userTypeCoach)
                    selectedValuesWidget(context,
                            heading: 'Categories',
                            list: userData?.data?.comprensiveListings ?? [])
                        .paddingAll(10),
                ],
              ),
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
            Text(
              'Additional Details :',
              style: boldTextStyle(color: primaryColor),
            ).paddingOnly(bottom: 10, top: 10),
            divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            intlPhoneField(
              label: 'Phone Number',
              controller: phoneNumberController,
              onChanged: (phoneNumber) {
                setState(() {
                  sPhoneNumber = phoneNumber.number;
                  sCountryCode = phoneNumber.countryCode;
                });
              },
              validator: (phoneNumber) {
                if (phoneNumber == null || phoneNumber.number.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: educationController,
              label: 'Education',
              focusNode: educationFocusNode,
              errorText: fieldErrors['education'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter Education',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: preferViaController,
              label: 'Prefer Via',
              focusNode: preferViaFocusNode,
              errorText: fieldErrors['preferVia'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Eg. Phone, Email',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: philosophyController,
              label: 'Philosophy',
              focusNode: philosophyFocusNode,
              errorText: fieldErrors['philosophy'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter Philosophy',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: certificationController,
              label: 'Certification',
              focusNode: certificationFocusNode,
              errorText: fieldErrors['philosophy'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter Certifications',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: industriesServedController,
              label: 'Industries Served',
              focusNode: industriesServedFocusNode,
              errorText: fieldErrors['industriesServed'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter Industries Served',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: coachingYearsController,
              label: 'Coaching Experience (In Years)',
              focusNode: coachingYearsFocusNode,
              errorText: fieldErrors['coachingYears'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter experience',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            textFormField(
              controller: nicheController,
              label: 'Niche',
              focusNode: nicheFocusNode,
              errorText: fieldErrors['niche'],
              labelTextBoxSpace: 8,
              keyboardType: TextInputType.name,
              hintText: 'Enter Niche',
            ),
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
                              imageUrl: '$baseUrl$profilePic',
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
