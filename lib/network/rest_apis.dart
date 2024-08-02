import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/models/all_comprehensive_response.dart';
import 'package:jumpvalues/models/base_response.dart';
import 'package:jumpvalues/models/category_dropdown_response.dart';
import 'package:jumpvalues/models/client_profile_response_model.dart';
import 'package:jumpvalues/models/coach_profile_response_model.dart';
import 'package:jumpvalues/models/global_user_response_model.dart';
import 'package:jumpvalues/models/login_response.dart';
import 'package:jumpvalues/models/signup_response_model.dart';
import 'package:jumpvalues/network/network_utils.dart';
import 'package:jumpvalues/utils/utils.dart';

Future<Map<String, dynamic>> handleResponse(Response response) async {
  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.data;
  } else if (response.statusCode == 403) {
    tokenExpired(NavigationService.navigatorKey.currentState!.context);
    return response.data;
  } else if (response.statusCode != 200 || response.statusCode != 201) {
    return response.data;
  } else {
    throw Exception('Error: ${response.data}');
  }
}

Future<CategoryDropdownResponse?> categoriesDropdown() async {
  CategoryDropdownResponse? response;
  try {
    response = CategoryDropdownResponse.fromJson(await handleResponse(
      await buildHttpResponse('category/dropdown',
          isAuth: false, method: HttpMethodType.get),
    ));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<CategoryDropdownResponse?> sponsorDropdown() async {
  CategoryDropdownResponse? response;
  try {
    response = CategoryDropdownResponse.fromJson(await handleResponse(
      await buildHttpResponse('sponsor/dropdown',
          isAuth: false, method: HttpMethodType.get),
    ));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<CategoryDropdownResponse?> categoryBySponsorDropdown(
    String sponsorId) async {
  CategoryDropdownResponse? response;
  try {
    response = CategoryDropdownResponse.fromJson(await handleResponse(
      await buildHttpResponse('category/get_dropdown_by_Sponsor_id/$sponsorId',
          isAuth: false, method: HttpMethodType.get),
    ));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<SignupResponseModel> signupUser(
    Map<String, dynamic> request, String endPoint) async {
  SignupResponseModel response;
  try {
    response = SignupResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(endPoint,
            request: request, method: HttpMethodType.post)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<LoginResponseModel?> loginUser(Map<String, dynamic> request) async {
  LoginResponseModel? response;
  try {
    response = LoginResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/login',
            request: request,
            isJsonEncode: false,
            method: HttpMethodType.post)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> logoutUser() async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/logout',
            isAuth: true, method: HttpMethodType.post)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> forgotPassword(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/forget_password',
            request: request, method: HttpMethodType.patch)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> resendOtpForSignup(
    Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/resend/otp',
            request: request, method: HttpMethodType.patch)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> resetPassword(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/reset_password',
            request: request, method: HttpMethodType.patch)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel> verifyOtp(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('auth/verify/otp',
            request: request, method: HttpMethodType.patch)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> updateUserProfile(
    Map<String, dynamic> request, String endPoint) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(endPoint,
            request: request, isAuth: true, method: HttpMethodType.patch)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> updateUserProfilePic(
    {Map? request, String? userId, File? image}) async {
  BaseResponseModel? response;
  try {
    // Construct the URL for the upload endpoint
    var url = buildBaseUrl('user/updateProfilePic/$userId');
    // Upload the image with the constructed URL and the request parameter
    response = BaseResponseModel.fromJson(await handleResponse(
        await uploadImage(url, image ?? File(''), isAuth: true)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<ClientProfileResponseModel?> getUserClientDetails(int userId) async {
  ClientProfileResponseModel? response;
  try {
    response = ClientProfileResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('client/profile/$userId',
            isAuth: true, method: HttpMethodType.get)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<CoachProfileResponseModel?> getUserCoachDetails(int userId) async {
  CoachProfileResponseModel? response;
  try {
    response = CoachProfileResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('coach/profile/$userId',
            isAuth: true, method: HttpMethodType.get)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<AllComprehensiveValues?> getAllComprehensiveValues(endPoint) async {
  AllComprehensiveValues? response;
  try {
    response = AllComprehensiveValues.fromJson(await handleResponse(
        await buildHttpResponse(endPoint,
            isAuth: true, method: HttpMethodType.get)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<BaseResponseModel?> addUserComprehensiveListing(
    Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('client/addOrUpdateCoreValues',
            request: request, isAuth: true, method: HttpMethodType.post)));
  } catch (e) {
    rethrow;
  }
  return response;
}

Future<GlobalUserResponseModel?> getGlobalUserDetails() async {
  GlobalUserResponseModel? response;
  try {
    response = GlobalUserResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('user/me',
            isAuth: true, method: HttpMethodType.get)));
  } catch (e) {
    rethrow;
  }
  return response;
}
