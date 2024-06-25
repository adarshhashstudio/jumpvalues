import 'package:jumpvalues/models/login_response.dart';
import 'package:jumpvalues/utils/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String token = '';

  @observable
  String userType = '';

  @observable
  int? userId = -1;

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  @observable
  String userContactNumber = '';

  @observable
  String userEmail = '';

  @observable
  String userCompany = '';

  @observable
  String userPosition = '';

  @observable
  String userProfilePic = '';

  @observable
  String userAboutMe = '';

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @computed
  bool get userTypeCoach => userType == USERTYPE_COACH;

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setContactNumber(String val,
      {bool isInitializing = false}) async {
    userContactNumber = val;
    if (!isInitializing) await setValue(CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setUserCompany(String val, {bool isInitializing = false}) async {
    userCompany = val;
    if (!isInitializing) await setValue(USER_COMPANY, val);
  }

  @action
  Future<void> setUserPosition(String val,
      {bool isInitializing = false}) async {
    userPosition = val;
    if (!isInitializing) await setValue(USER_POSITION, val);
  }

  @action
  Future<void> setUserProfilePic(String val,
      {bool isInitializing = false}) async {
    userProfilePic = val;
    if (!isInitializing) await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> setUserAboutMe(String val, {bool isInitializing = false}) async {
    userAboutMe = val;
    if (!isInitializing) await setValue(USER_ABOUT_ME, val);
  }

  @action
  Future<void> setUserData(LoginResponseModel response) async {
    if (response.data != null) {
      await setUserId(response.data?.id ?? -1);
      await setFirstName(response.data?.firstName ?? '');
      await setLastName(response.data?.lastName ?? '');
      await setUserEmail(response.data?.email ?? '');
      await setUserCompany(response.data?.company ?? '');
      await setUserPosition(response.data?.positions ?? '');
      await setUserAboutMe(response.data?.aboutMe ?? '');
      await setUserProfilePic(response.data?.profilePic ?? '');
      await setLoggedIn(true);
      await setToken(response.token ?? '');
      await setUserType(USERTYPE_CLIENT);
    }
  }

  @action
  Future<void> clearData() async {
    isLoggedIn = false;
    token = '';
    userType = '';
    userId = -1;
    userFirstName = '';
    userLastName = '';
    userContactNumber = '';
    userEmail = '';
    userCompany = '';
    userPosition = '';
    userProfilePic = '';
    userAboutMe = '';

    await sharedPreferences.clear();
  }
}
