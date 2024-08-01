// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$userFullNameComputed;

  @override
  String get userFullName =>
      (_$userFullNameComputed ??= Computed<String>(() => super.userFullName,
              name: '_AppStore.userFullName'))
          .value;
  Computed<bool>? _$userTypeCoachComputed;

  @override
  bool get userTypeCoach =>
      (_$userTypeCoachComputed ??= Computed<bool>(() => super.userTypeCoach,
              name: '_AppStore.userTypeCoach'))
          .value;

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$idAtom = Atom(name: '_AppStore.id', context: context);

  @override
  int get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$userIdAtom = Atom(name: '_AppStore.userId', context: context);

  @override
  int? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$sponsorIdAtom =
      Atom(name: '_AppStore.sponsorId', context: context);

  @override
  int? get sponsorId {
    _$sponsorIdAtom.reportRead();
    return super.sponsorId;
  }

  @override
  set sponsorId(int? value) {
    _$sponsorIdAtom.reportWrite(value, super.sponsorId, () {
      super.sponsorId = value;
    });
  }

  late final _$sponsorNameAtom =
      Atom(name: '_AppStore.sponsorName', context: context);

  @override
  String get sponsorName {
    _$sponsorNameAtom.reportRead();
    return super.sponsorName;
  }

  @override
  set sponsorName(String value) {
    _$sponsorNameAtom.reportWrite(value, super.sponsorName, () {
      super.sponsorName = value;
    });
  }

  late final _$userTypeAtom =
      Atom(name: '_AppStore.userType', context: context);

  @override
  String get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$userFirstNameAtom =
      Atom(name: '_AppStore.userFirstName', context: context);

  @override
  String get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  late final _$userLastNameAtom =
      Atom(name: '_AppStore.userLastName', context: context);

  @override
  String get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  late final _$userContactNumberAtom =
      Atom(name: '_AppStore.userContactNumber', context: context);

  @override
  String get userContactNumber {
    _$userContactNumberAtom.reportRead();
    return super.userContactNumber;
  }

  @override
  set userContactNumber(String value) {
    _$userContactNumberAtom.reportWrite(value, super.userContactNumber, () {
      super.userContactNumber = value;
    });
  }

  late final _$userContactCountryCodeAtom =
      Atom(name: '_AppStore.userContactCountryCode', context: context);

  @override
  String get userContactCountryCode {
    _$userContactCountryCodeAtom.reportRead();
    return super.userContactCountryCode;
  }

  @override
  set userContactCountryCode(String value) {
    _$userContactCountryCodeAtom
        .reportWrite(value, super.userContactCountryCode, () {
      super.userContactCountryCode = value;
    });
  }

  late final _$userContactCountryIsoCodeAtom =
      Atom(name: '_AppStore.userContactCountryIsoCode', context: context);

  @override
  String get userContactCountryIsoCode {
    _$userContactCountryIsoCodeAtom.reportRead();
    return super.userContactCountryIsoCode;
  }

  @override
  set userContactCountryIsoCode(String value) {
    _$userContactCountryIsoCodeAtom
        .reportWrite(value, super.userContactCountryIsoCode, () {
      super.userContactCountryIsoCode = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$userPositionAtom =
      Atom(name: '_AppStore.userPosition', context: context);

  @override
  String get userPosition {
    _$userPositionAtom.reportRead();
    return super.userPosition;
  }

  @override
  set userPosition(String value) {
    _$userPositionAtom.reportWrite(value, super.userPosition, () {
      super.userPosition = value;
    });
  }

  late final _$userEducationAtom =
      Atom(name: '_AppStore.userEducation', context: context);

  @override
  String get userEducation {
    _$userEducationAtom.reportRead();
    return super.userEducation;
  }

  @override
  set userEducation(String value) {
    _$userEducationAtom.reportWrite(value, super.userEducation, () {
      super.userEducation = value;
    });
  }

  late final _$userPreferViaAtom =
      Atom(name: '_AppStore.userPreferVia', context: context);

  @override
  String get userPreferVia {
    _$userPreferViaAtom.reportRead();
    return super.userPreferVia;
  }

  @override
  set userPreferVia(String value) {
    _$userPreferViaAtom.reportWrite(value, super.userPreferVia, () {
      super.userPreferVia = value;
    });
  }

  late final _$userPhilosophyAtom =
      Atom(name: '_AppStore.userPhilosophy', context: context);

  @override
  String get userPhilosophy {
    _$userPhilosophyAtom.reportRead();
    return super.userPhilosophy;
  }

  @override
  set userPhilosophy(String value) {
    _$userPhilosophyAtom.reportWrite(value, super.userPhilosophy, () {
      super.userPhilosophy = value;
    });
  }

  late final _$userCertificationsAtom =
      Atom(name: '_AppStore.userCertifications', context: context);

  @override
  String get userCertifications {
    _$userCertificationsAtom.reportRead();
    return super.userCertifications;
  }

  @override
  set userCertifications(String value) {
    _$userCertificationsAtom.reportWrite(value, super.userCertifications, () {
      super.userCertifications = value;
    });
  }

  late final _$userIndustriesServedAtom =
      Atom(name: '_AppStore.userIndustriesServed', context: context);

  @override
  String get userIndustriesServed {
    _$userIndustriesServedAtom.reportRead();
    return super.userIndustriesServed;
  }

  @override
  set userIndustriesServed(String value) {
    _$userIndustriesServedAtom.reportWrite(value, super.userIndustriesServed,
        () {
      super.userIndustriesServed = value;
    });
  }

  late final _$userExperianceAtom =
      Atom(name: '_AppStore.userExperiance', context: context);

  @override
  int get userExperiance {
    _$userExperianceAtom.reportRead();
    return super.userExperiance;
  }

  @override
  set userExperiance(int value) {
    _$userExperianceAtom.reportWrite(value, super.userExperiance, () {
      super.userExperiance = value;
    });
  }

  late final _$userNicheAtom =
      Atom(name: '_AppStore.userNiche', context: context);

  @override
  String get userNiche {
    _$userNicheAtom.reportRead();
    return super.userNiche;
  }

  @override
  set userNiche(String value) {
    _$userNicheAtom.reportWrite(value, super.userNiche, () {
      super.userNiche = value;
    });
  }

  late final _$userProfilePicAtom =
      Atom(name: '_AppStore.userProfilePic', context: context);

  @override
  String get userProfilePic {
    _$userProfilePicAtom.reportRead();
    return super.userProfilePic;
  }

  @override
  set userProfilePic(String value) {
    _$userProfilePicAtom.reportWrite(value, super.userProfilePic, () {
      super.userProfilePic = value;
    });
  }

  late final _$userAboutMeAtom =
      Atom(name: '_AppStore.userAboutMe', context: context);

  @override
  String get userAboutMe {
    _$userAboutMeAtom.reportRead();
    return super.userAboutMe;
  }

  @override
  set userAboutMe(String value) {
    _$userAboutMeAtom.reportWrite(value, super.userAboutMe, () {
      super.userAboutMe = value;
    });
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction
        .run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitializing: isInitializing));
  }

  late final _$setIdAsyncAction =
      AsyncAction('_AppStore.setId', context: context);

  @override
  Future<void> setId(int val, {bool isInitializing = false}) {
    return _$setIdAsyncAction
        .run(() => super.setId(val, isInitializing: isInitializing));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int? val, {bool isInitializing = false}) {
    return _$setUserIdAsyncAction
        .run(() => super.setUserId(val, isInitializing: isInitializing));
  }

  late final _$setSponsorIdAsyncAction =
      AsyncAction('_AppStore.setSponsorId', context: context);

  @override
  Future<void> setSponsorId(int? val, {bool isInitializing = false}) {
    return _$setSponsorIdAsyncAction
        .run(() => super.setSponsorId(val, isInitializing: isInitializing));
  }

  late final _$setSponsorNameAsyncAction =
      AsyncAction('_AppStore.setSponsorName', context: context);

  @override
  Future<void> setSponsorName(String val, {bool isInitializing = false}) {
    return _$setSponsorNameAsyncAction
        .run(() => super.setSponsorName(val, isInitializing: isInitializing));
  }

  late final _$setUserTypeAsyncAction =
      AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val, {bool isInitializing = false}) {
    return _$setUserTypeAsyncAction
        .run(() => super.setUserType(val, isInitializing: isInitializing));
  }

  late final _$setUserFirstNameAsyncAction =
      AsyncAction('_AppStore.setUserFirstName', context: context);

  @override
  Future<void> setUserFirstName(String val, {bool isInitializing = false}) {
    return _$setUserFirstNameAsyncAction
        .run(() => super.setUserFirstName(val, isInitializing: isInitializing));
  }

  late final _$setUserLastNameAsyncAction =
      AsyncAction('_AppStore.setUserLastName', context: context);

  @override
  Future<void> setUserLastName(String val, {bool isInitializing = false}) {
    return _$setUserLastNameAsyncAction
        .run(() => super.setUserLastName(val, isInitializing: isInitializing));
  }

  late final _$setUserContactNumberAsyncAction =
      AsyncAction('_AppStore.setUserContactNumber', context: context);

  @override
  Future<void> setUserContactNumber(String val, {bool isInitializing = false}) {
    return _$setUserContactNumberAsyncAction.run(
        () => super.setUserContactNumber(val, isInitializing: isInitializing));
  }

  late final _$setUserContactCountryCodeAsyncAction =
      AsyncAction('_AppStore.setUserContactCountryCode', context: context);

  @override
  Future<void> setUserContactCountryCode(String val,
      {bool isInitializing = false}) {
    return _$setUserContactCountryCodeAsyncAction.run(() =>
        super.setUserContactCountryCode(val, isInitializing: isInitializing));
  }

  late final _$setUserContactCountryIsoCodeAsyncAction =
      AsyncAction('_AppStore.setUserContactCountryIsoCode', context: context);

  @override
  Future<void> setUserContactCountryIsoCode(String val,
      {bool isInitializing = false}) {
    return _$setUserContactCountryIsoCodeAsyncAction.run(() => super
        .setUserContactCountryIsoCode(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  late final _$setUserPositionAsyncAction =
      AsyncAction('_AppStore.setUserPosition', context: context);

  @override
  Future<void> setUserPosition(String val, {bool isInitializing = false}) {
    return _$setUserPositionAsyncAction
        .run(() => super.setUserPosition(val, isInitializing: isInitializing));
  }

  late final _$setUserEducationAsyncAction =
      AsyncAction('_AppStore.setUserEducation', context: context);

  @override
  Future<void> setUserEducation(String val, {bool isInitializing = false}) {
    return _$setUserEducationAsyncAction
        .run(() => super.setUserEducation(val, isInitializing: isInitializing));
  }

  late final _$setUserPreferViaAsyncAction =
      AsyncAction('_AppStore.setUserPreferVia', context: context);

  @override
  Future<void> setUserPreferVia(String val, {bool isInitializing = false}) {
    return _$setUserPreferViaAsyncAction
        .run(() => super.setUserPreferVia(val, isInitializing: isInitializing));
  }

  late final _$setUserPhilosophyAsyncAction =
      AsyncAction('_AppStore.setUserPhilosophy', context: context);

  @override
  Future<void> setUserPhilosophy(String val, {bool isInitializing = false}) {
    return _$setUserPhilosophyAsyncAction.run(
        () => super.setUserPhilosophy(val, isInitializing: isInitializing));
  }

  late final _$setUserCertificationsAsyncAction =
      AsyncAction('_AppStore.setUserCertifications', context: context);

  @override
  Future<void> setUserCertifications(String val,
      {bool isInitializing = false}) {
    return _$setUserCertificationsAsyncAction.run(
        () => super.setUserCertifications(val, isInitializing: isInitializing));
  }

  late final _$setUserIndustriesServedAsyncAction =
      AsyncAction('_AppStore.setUserIndustriesServed', context: context);

  @override
  Future<void> setUserIndustriesServed(String val,
      {bool isInitializing = false}) {
    return _$setUserIndustriesServedAsyncAction.run(() =>
        super.setUserIndustriesServed(val, isInitializing: isInitializing));
  }

  late final _$setUserExperianceAsyncAction =
      AsyncAction('_AppStore.setUserExperiance', context: context);

  @override
  Future<void> setUserExperiance(int val, {bool isInitializing = false}) {
    return _$setUserExperianceAsyncAction.run(
        () => super.setUserExperiance(val, isInitializing: isInitializing));
  }

  late final _$setUserNicheAsyncAction =
      AsyncAction('_AppStore.setUserNiche', context: context);

  @override
  Future<void> setUserNiche(String val, {bool isInitializing = false}) {
    return _$setUserNicheAsyncAction
        .run(() => super.setUserNiche(val, isInitializing: isInitializing));
  }

  late final _$setUserProfilePicAsyncAction =
      AsyncAction('_AppStore.setUserProfilePic', context: context);

  @override
  Future<void> setUserProfilePic(String val, {bool isInitializing = false}) {
    return _$setUserProfilePicAsyncAction.run(
        () => super.setUserProfilePic(val, isInitializing: isInitializing));
  }

  late final _$setUserAboutMeAsyncAction =
      AsyncAction('_AppStore.setUserAboutMe', context: context);

  @override
  Future<void> setUserAboutMe(String val, {bool isInitializing = false}) {
    return _$setUserAboutMeAsyncAction
        .run(() => super.setUserAboutMe(val, isInitializing: isInitializing));
  }

  late final _$setUserDataAsyncAction =
      AsyncAction('_AppStore.setUserData', context: context);

  @override
  Future<void> setUserData(GlobalUserResponseModel? response) {
    return _$setUserDataAsyncAction.run(() => super.setUserData(response));
  }

  late final _$clearDataAsyncAction =
      AsyncAction('_AppStore.clearData', context: context);

  @override
  Future<void> clearData() {
    return _$clearDataAsyncAction.run(() => super.clearData());
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
token: ${token},
id: ${id},
userId: ${userId},
sponsorId: ${sponsorId},
sponsorName: ${sponsorName},
userType: ${userType},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
userContactNumber: ${userContactNumber},
userContactCountryCode: ${userContactCountryCode},
userContactCountryIsoCode: ${userContactCountryIsoCode},
userEmail: ${userEmail},
userPosition: ${userPosition},
userEducation: ${userEducation},
userPreferVia: ${userPreferVia},
userPhilosophy: ${userPhilosophy},
userCertifications: ${userCertifications},
userIndustriesServed: ${userIndustriesServed},
userExperiance: ${userExperiance},
userNiche: ${userNiche},
userProfilePic: ${userProfilePic},
userAboutMe: ${userAboutMe},
userFullName: ${userFullName},
userTypeCoach: ${userTypeCoach}
    ''';
  }
}
