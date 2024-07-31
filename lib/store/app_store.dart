import 'package:jumpvalues/models/global_user_response_model.dart';
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
  int id = -1;

  @observable
  int? userId = -1;

  @observable
  int? sponsorId = -1;

  @observable
  String sponsorName = '';

  @observable
  String userType = '';

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  @observable
  String userContactNumber = '';

  @observable
  String userContactCountryCode = '';

  @observable
  String userEmail = '';

  @observable
  String userPosition = '';

  @observable
  String userEducation = '';

  @observable
  String userPreferVia = '';

  @observable
  String userPhilosophy = '';

  @observable
  String userCertifications = '';

  @observable
  String userIndustriesServed = '';

  @observable
  int userExperiance = 0;

  @observable
  String userNiche = '';

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
  Future<void> setId(int val, {bool isInitializing = false}) async {
    id = val;
    if (!isInitializing) await setValue(ID, val);
  }

  @action
  Future<void> setUserId(int? val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setSponsorId(int? val, {bool isInitializing = false}) async {
    sponsorId = val;
    if (!isInitializing) await setValue(SPONSOR_ID, val);
  }

  @action
  Future<void> setSponsorName(String val, {bool isInitializing = false}) async {
    sponsorName = val;
    if (!isInitializing) await setValue(SPONSOR_NAME, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setUserFirstName(String val,
      {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(USER_FIRST_NAME, val);
  }

  @action
  Future<void> setUserLastName(String val,
      {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(USER_LAST_NAME, val);
  }

  @action
  Future<void> setUserContactNumber(String val,
      {bool isInitializing = false}) async {
    userContactNumber = val;
    if (!isInitializing) await setValue(USER_CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserContactCountryCode(String val,
      {bool isInitializing = false}) async {
    userContactCountryCode = val;
    if (!isInitializing) await setValue(USER_CONTACT_COUNTRY_CODE, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setUserPosition(String val,
      {bool isInitializing = false}) async {
    userPosition = val;
    if (!isInitializing) await setValue(USER_POSITION, val);
  }

  @action
  Future<void> setUserEducation(String val,
      {bool isInitializing = false}) async {
    userEducation = val;
    if (!isInitializing) await setValue(USER_EDUCATION, val);
  }

  @action
  Future<void> setUserPreferVia(String val,
      {bool isInitializing = false}) async {
    userPreferVia = val;
    if (!isInitializing) await setValue(USER_PREFER_VIA, val);
  }

  @action
  Future<void> setUserPhilosophy(String val,
      {bool isInitializing = false}) async {
    userPhilosophy = val;
    if (!isInitializing) await setValue(USER_PHILOSOPHY, val);
  }

  @action
  Future<void> setUserCertifications(String val,
      {bool isInitializing = false}) async {
    userCertifications = val;
    if (!isInitializing) await setValue(USER_CERTIFICATIONS, val);
  }

  @action
  Future<void> setUserIndustriesServed(String val,
      {bool isInitializing = false}) async {
    userIndustriesServed = val;
    if (!isInitializing) await setValue(USER_INDUSTRIES_SERVED, val);
  }

  @action
  Future<void> setUserExperiance(int val, {bool isInitializing = false}) async {
    userExperiance = val;
    if (!isInitializing) await setValue(USER_EXPERIANCE, val);
  }

  @action
  Future<void> setUserNiche(String val, {bool isInitializing = false}) async {
    userNiche = val;
    if (!isInitializing) await setValue(USER_NICHE, val);
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
  Future<void> setUserData(GlobalUserResponseModel? response) async {
    if (response?.data != null) {
      await setUserId(response?.data?.id ?? -1);
      await setUserFirstName(response?.data?.firstName ?? '');
      await setUserLastName(response?.data?.lastName ?? '');
      await setUserContactNumber(response?.data?.phone ?? '');
      await setUserContactCountryCode(response?.data?.countryCode ?? '');
      await setUserEmail(response?.data?.email ?? '');
      await setUserPosition(response?.data?.clientProfile?.position ?? '');
      await setUserAboutMe(response?.data?.clientProfile?.aboutMe ?? '');
      await setUserProfilePic(response?.data?.dp ?? '');
      await setUserEducation(response?.data?.coachProfile?.education ?? '');
      await setUserPreferVia(
          response?.data?.coachProfile?.preferVia?.toString() ?? '');
      await setUserPhilosophy(response?.data?.coachProfile?.philosophy ?? '');
      await setUserCertifications(
          response?.data?.coachProfile?.certifications ?? '');
      await setUserIndustriesServed(
          response?.data?.coachProfile?.industriesServed ?? '');
      await setUserExperiance(response?.data?.coachProfile?.experience ?? 0);
      await setUserNiche(response?.data?.coachProfile?.niche ?? '');
      await setSponsorId(response?.data?.clientProfile?.sponsorId ?? -1);
      await setSponsorName(response?.data?.clientProfile?.sponsor?.name ?? '');
    }
  }

  @action
  Future<void> clearData() async {
    isLoggedIn = false;
    token = '';
    id = -1;
    userId = -1;
    sponsorId = -1;
    sponsorName = '';
    userType = '';
    userFirstName = '';
    userLastName = '';
    userContactNumber = '';
    userContactCountryCode = '';
    userEmail = '';
    userPosition = '';
    userEducation = '';
    userPreferVia = '';
    userPhilosophy = '';
    userCertifications = '';
    userIndustriesServed = '';
    userExperiance = 0;
    userNiche = '';
    userProfilePic = '';
    userAboutMe = '';

    await sharedPreferences.clear();
  }
}
