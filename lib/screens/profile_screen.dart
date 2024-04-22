import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jumpvalues/common.dart';
import 'package:jumpvalues/models/user_data_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/screens/select_screen.dart';
import 'package:jumpvalues/screens/welcome_screen.dart';
import 'package:jumpvalues/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? companyController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? positionController;
  TextEditingController? aboutController;

  bool loader = false;
  var userName = '';
  var email = '';
  String? profilePic;
  bool _isMounted = false;
  UserDataResponseModel? userData;

  @override
  void initState() {
    _isMounted = true;
    isTokenAvailable(context);
    loadUserData();
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> updateProfile() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> req = {
        'firstName': firstNameController?.text ?? prefs.getString('firstName'),
        'lastName': lastNameController?.text ?? prefs.getString('lastName'),
        'company': companyController?.text ?? prefs.getString('company'),
        'positions': positionController?.text ?? prefs.getString('position'),
        'aboutMe': aboutController?.text ?? prefs.getString('aboutMe')
      };
      var userId = prefs.getString('userId');
      var response = await updateUserProfile(req, userId ?? 'id');

      if (response?.statusCode == 200) {
        setUserData();

        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Profile Updated Successfully.');
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong.');
      }

      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
      SnackBarHelper.showStatusSnackBar(
          context, StatusIndicator.error, e.toString());
    }
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("You want to logout now?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Call the code to clear the token and navigate to WelcomeScreen
                logoutAndNavigateToWelcomeScreen(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void logoutAndNavigateToWelcomeScreen(BuildContext context) async {
    setState(() {
      loader = true;
    });
    // Clear token and other data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await logoutUser();
      if (response?.statusCode == 200) {
        setState(() {
          loader = false;
        });

        await prefs.remove('token'); // Remove token
        await prefs.clear();

        // Navigate to WelcomeScreen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (Route<dynamic> route) => false);
      } else if (response?.statusCode == 403) {
        setState(() {
          loader = false;
        });

        await prefs.remove('token'); // Remove token
        await prefs.clear();
        if (_isMounted) {
          isTokenAvailable(context);
        }
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      throw '$e';
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstNameController =
        TextEditingController(text: prefs.getString('firstName') ?? '');
    lastNameController =
        TextEditingController(text: prefs.getString('lastName') ?? '');
    companyController =
        TextEditingController(text: prefs.getString('company') ?? '');
    emailController =
        TextEditingController(text: prefs.getString('email') ?? '');
    positionController =
        TextEditingController(text: prefs.getString('position') ?? '');
    aboutController =
        TextEditingController(text: prefs.getString('aboutMe') ?? '');
    setState(() {
      userName =
          '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}';
      email = prefs.getString('email') ?? '';
      profilePic = prefs.getString('profilePic');
    });

    debugPrint('Profile Pic: http://192.168.1.166:8080/$profilePic');
  }

  Future<void> setUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstNameController?.text ?? '');
    await prefs.setString('lastName', lastNameController?.text ?? '');
    await prefs.setString('company', companyController?.text ?? '');
    await prefs.setString('position', positionController?.text ?? '');
    await prefs.setString('aboutMe', aboutController?.text ?? '');

    setState(() {
      userName =
          '${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}';
    });
  }

  File? _image;
  final picker = ImagePicker();

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
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
                child: Padding(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Camera'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> uploadProfilePic() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception("User ID not found.");
      }

      var response = await updateUserProfilePic(
          userId: userId,
          image: _image); // assuming _image is your File variable

      if (response?.statusCode == 200) {
        await prefs.setString('profilePic', response?.data ?? '');
        setState(() {
          profilePic = prefs.getString('profilePic');
        });
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.success,
          response?.message ?? 'Profile Pic Uploaded Successfully.',
        );
      } else {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.error,
          response?.message ?? 'Something went wrong.',
        );
      }
    } catch (e) {
      debugPrint('Error uploading profile pic: $e');
      setState(() {
        loader = false;
      });
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await getUserDetails(prefs.getString('userId') ?? '0');
      if (response?.statusCode == 200) {
        setState(() {
          userData = response;
        });
        setState(() {});
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong.');
      }
      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          'My Profile',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
              fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                if (loader) {
                } else {
                  showLogoutConfirmationDialog(context);
                }
              },
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showOptions();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(360),
                                        ),
                                        child: profilePic != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'http://192.168.1.166:8080/$profilePic',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, _) =>
                                                      Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : _image != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            360),
                                                    child: Image.file(
                                                      _image ?? File(''),
                                                      fit: BoxFit.cover,
                                                    ))
                                                : Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 40,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          showOptions();
                                        },
                                        child: Image.asset(
                                          'assets/images/edit.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      email,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.42,
                                        child: textFormField(
                                            controller: firstNameController,
                                            label: 'First Name',
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[a-zA-Z]'))
                                            ],
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'Required';
                                              }
                                            },
                                            keyboardType: TextInputType.name,
                                            hintText: 'Enter First Name',
                                            textInputAction:
                                                TextInputAction.next),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.42,
                                        child: textFormField(
                                            controller: lastNameController,
                                            label: 'Last Name',
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'Required';
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[a-zA-Z]'))
                                            ],
                                            hintText: 'Enter Last Name',
                                            textInputAction:
                                                TextInputAction.next),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  textFormField(
                                    controller: companyController,
                                    label: 'Company',
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Required';
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter Company Name',
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  textFormField(
                                    controller: positionController,
                                    label: 'Position',
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Required';
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter Position',
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  textFormField(
                                    controller: aboutController,
                                    label: 'About',
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Required';
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter your bio',
                                    maxLines: 3,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ExpansionTile(
                                      title: const Text('My Values'),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 0.5,
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      children: [
                                        (userData?.data?.comprensiveListings !=
                                                null)
                                            ? ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: userData
                                                    ?.data
                                                    ?.comprensiveListings
                                                    ?.length,
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                  title: Text(
                                                      '${index + 1}. ${userData?.data?.comprensiveListings?[index].name}'),
                                                ),
                                              )
                                            : Text('No Values Selected'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: button(context, onPressed: () async {
                          if (loader) {
                          } else {
                            await updateProfile();
                          }
                        }, text: 'Update Profile'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SelectScreen()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Values',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (loader)
              Container(
                  color: Colors.transparent,
                  child: const Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }
}
