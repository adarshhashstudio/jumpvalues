import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jumpvalues/models/all_comprehensive_response.dart';
import 'package:jumpvalues/models/base_response.dart';
import 'package:jumpvalues/models/login_response.dart';
import 'package:jumpvalues/models/profile_pic_response.dart';
import 'package:jumpvalues/models/signup_response_model.dart';
import 'package:jumpvalues/models/user_data_response_model.dart';
import 'package:jumpvalues/network/network_utils.dart';

Future<SignupResponseModel> signupUser(Map<String, dynamic> request) async {
  SignupResponseModel response;
  try {
    response = SignupResponseModel.fromJson(await (handleResponse(
        endPoint: 'auth/signup',
        await buildHttpResponse('auth/signup',
            request: request, method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Signup Response: $e');
    throw '$e';
  }

  return response;
}

Future<LoginResponseModel?> loginUser(Map<String, dynamic> request) async {
  LoginResponseModel? response;
  try {
    response = LoginResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/login',
            request: request,
            isJsonEncode: false,
            method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Login Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> logoutUser() async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/logout',
            isAuth: true, method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Logout Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> forgotPassword(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/forget_password',
            request: request, method: HttpMethodType.PATCH))));
  } catch (e) {
    debugPrint('Forgot Password Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> resendOtpForSignup(
    Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/send_otp',
            request: request, method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Resend Otp Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> resetPassword(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/reset_password',
            request: request, method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Reset Password Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel> verifyOtp(Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('auth/verify_OTP',
            request: request, method: HttpMethodType.POST))));
  } catch (e) {
    debugPrint('Verfication OTP Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> updateUserProfile(
    Map<String, dynamic> request, String userId) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('users/update_user/$userId',
            request: request, isAuth: true, method: HttpMethodType.PATCH))));
  } catch (e) {
    debugPrint('User Update Data Response: $e');
    throw '$e';
  }
  return response;
}

Future<ProfilePictureResponse?> updateUserProfilePic(
    {Map? request, String? userId, File? image}) async {
  ProfilePictureResponse? response;
  try {
    // Construct the URL for the upload endpoint
    var url = buildBaseUrl('users/update_profile_pic/$userId');
    // Upload the image with the constructed URL and the request parameter
    response = ProfilePictureResponse.fromJson(
        await (handleResponse(await uploadImage(url, image!, isAuth: true))));
  } catch (e) {
    debugPrint('Profile Update Response: $e');
    throw '$e';
  }
  return response;
}

Future<UserDataResponseModel?> getUserDetails(String userId) async {
  UserDataResponseModel? response;
  try {
    response = UserDataResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse('users/$userId',
            isAuth: true, method: HttpMethodType.GET))));
  } catch (e) {
    debugPrint('User Data Response: $e');
    throw '$e';
  }
  return response;
}

Future<AllComprehensiveValues?> getAllComprehensiveValues() async {
  AllComprehensiveValues? response;
  try {
    response = AllComprehensiveValues.fromJson(await (handleResponse(
        await buildHttpResponse('comprensive/get_all_comprensive',
            isAuth: true, method: HttpMethodType.GET))));
  } catch (e) {
    debugPrint('All Comprehensive Response: $e');
    throw '$e';
  }
  return response;
}

Future<BaseResponseModel?> addUserComprehensiveListing(
    Map<String, dynamic> request) async {
  BaseResponseModel? response;
  try {
    response = BaseResponseModel.fromJson(await (handleResponse(
        await buildHttpResponse(
            'comprensive/update_user_has_comprensiveListing',
            request: request,
            isAuth: true,
            method: HttpMethodType.PATCH))));
  } catch (e) {
    debugPrint('Added Comprehensive Response: $e');
    throw '$e';
  }
  return response;
}
