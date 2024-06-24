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

  late final _$userCompanyAtom =
      Atom(name: '_AppStore.userCompany', context: context);

  @override
  String get userCompany {
    _$userCompanyAtom.reportRead();
    return super.userCompany;
  }

  @override
  set userCompany(String value) {
    _$userCompanyAtom.reportWrite(value, super.userCompany, () {
      super.userCompany = value;
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

  late final _$setUserTypeAsyncAction =
      AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val, {bool isInitializing = false}) {
    return _$setUserTypeAsyncAction
        .run(() => super.setUserType(val, isInitializing: isInitializing));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int val, {bool isInitializing = false}) {
    return _$setUserIdAsyncAction
        .run(() => super.setUserId(val, isInitializing: isInitializing));
  }

  late final _$setFirstNameAsyncAction =
      AsyncAction('_AppStore.setFirstName', context: context);

  @override
  Future<void> setFirstName(String val, {bool isInitializing = false}) {
    return _$setFirstNameAsyncAction
        .run(() => super.setFirstName(val, isInitializing: isInitializing));
  }

  late final _$setLastNameAsyncAction =
      AsyncAction('_AppStore.setLastName', context: context);

  @override
  Future<void> setLastName(String val, {bool isInitializing = false}) {
    return _$setLastNameAsyncAction
        .run(() => super.setLastName(val, isInitializing: isInitializing));
  }

  late final _$setContactNumberAsyncAction =
      AsyncAction('_AppStore.setContactNumber', context: context);

  @override
  Future<void> setContactNumber(String val, {bool isInitializing = false}) {
    return _$setContactNumberAsyncAction
        .run(() => super.setContactNumber(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  late final _$setUserCompanyAsyncAction =
      AsyncAction('_AppStore.setUserCompany', context: context);

  @override
  Future<void> setUserCompany(String val, {bool isInitializing = false}) {
    return _$setUserCompanyAsyncAction
        .run(() => super.setUserCompany(val, isInitializing: isInitializing));
  }

  late final _$setUserPositionAsyncAction =
      AsyncAction('_AppStore.setUserPosition', context: context);

  @override
  Future<void> setUserPosition(String val, {bool isInitializing = false}) {
    return _$setUserPositionAsyncAction
        .run(() => super.setUserPosition(val, isInitializing: isInitializing));
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
  Future<void> setUserData(LoginResponseModel response) {
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
userType: ${userType},
userId: ${userId},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
userContactNumber: ${userContactNumber},
userEmail: ${userEmail},
userCompany: ${userCompany},
userPosition: ${userPosition},
userProfilePic: ${userProfilePic},
userAboutMe: ${userAboutMe},
userFullName: ${userFullName},
userTypeCoach: ${userTypeCoach}
    ''';
  }
}
