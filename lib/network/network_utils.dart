import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/utils.dart';
import 'package:nb_utils/nb_utils.dart'; // Add a prefix for dio

enum HttpMethodType { get, post, put, patch, delete }

extension HttpMethodTypeExtension on HttpMethodType {
  String get name {
    switch (this) {
      case HttpMethodType.get:
        return 'GET';
      case HttpMethodType.post:
        return 'POST';
      case HttpMethodType.put:
        return 'PUT';
      case HttpMethodType.patch:
        return 'PATCH';
      case HttpMethodType.delete:
        return 'DELETE';
      default:
        return '';
    }
  }
}

Uri buildBaseUrl(String endPoint) {
  var url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$baseUrl$endPoint');

  debugPrint('URL: ${url.toString()}');

  return url;
}

Future<dio.Response<dynamic>> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.get,
  Map<String, dynamic>? request,
  Map<String, dynamic>? extraKeys,
  bool isAuth = false,
  bool isJsonEncode = false,
}) async {
  if (await isNetworkAvailable()) {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map<String, dynamic>? headerReq;
    if (token != null) {
      headerReq = {'Authorization': 'Bearer $token'};
    } else {
      headerReq = null;
    }
    var headers = buildHeaderTokens(extraKeys: isAuth ? headerReq : {});
    var url = buildBaseUrl(endPoint);

    late Response response;

    try {
      var dio = Dio();
      response = await dio.request(
        url.toString(),
        data: request,
        options: Options(
          method: method.name,
          headers: headers,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        // Server returned an error response
        response = e.response ??
            dio.Response(
              statusCode: 1000,
              requestOptions: RequestOptions(path: endPoint),
              data: {
                'error': {'message': 'Something went wrong'}
              },
            );
      } else {
        // Other types of errors (network issues, client-side exceptions)
        response = dio.Response(
          statusCode: 408,
          requestOptions: RequestOptions(path: endPoint),
          data: {
            'error': {'message': 'Something went wrong'}
          },
        );
      }
    }

    apidebugPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.post || method == HttpMethodType.put,
      request: jsonEncode(request),
      statusCode: response.statusCode!,
      responseBody: jsonEncode(response.data),
      methodtype: method.name,
    );

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(dio.Response response,
    {String endPoint = '',
    HttpResponseType httpResponseType = HttpResponseType.JSON,
    bool? avoidTokenError,
    bool? isSadadPayment}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.data;
  } else if (response.statusCode == 403) {
    SnackBarHelper.showStatusSnackBar(
        NavigationService.navigatorKey.currentContext!,
        StatusIndicator.warning,
        'Session Expired.');
    tokenExpired(NavigationService.navigatorKey.currentContext!);
  } else {
    var errorMessage = response.data['message'] ?? errorSomethingWentWrong;
    if (endPoint == 'auth/signup') {
      // If endpoint is 'auth/signup' and there's an 'error' key in response
      errorMessage =
          response.data['error'][0]['message'] ?? errorSomethingWentWrong;
    }
    throw errorMessage;
  }
}

void apidebugPrint({
  String url = '',
  String endPoint = '',
  String headers = '',
  String request = '',
  int statusCode = 0,
  String responseBody = '',
  String methodtype = '',
  bool hasRequest = false,
}) {
  debugPrint(
      '┌───────────────────────────────────────────────────────────────────────────────────────────────────────');
  debugPrint('\u001b[93m Url: \u001B[39m $url');
  debugPrint('\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m');
  debugPrint('\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m');
  debugPrint('\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m');
  debugPrint(statusCode == 200 ? '\u001b[32m' : '\u001b[31m');
  debugPrint('Response ($methodtype) $statusCode: $responseBody');
  debugPrint('\u001B[0m');
  debugPrint(
      '└───────────────────────────────────────────────────────────────────────────────────────────────────────');
}

Map<String, String> buildHeaderTokens({
  Map<String, dynamic>? extraKeys,
}) {
  var header = <String, String>{};
  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '');

  if (extraKeys != null) {
    extraKeys.forEach((key, value) {
      header[key] = value.toString();
    });
  }

  debugPrint(jsonEncode(header));
  return header;
}

Future<dio.Response<dynamic>> uploadImage(Uri url, File imageFile,
    {Map<String, String>? fields, bool isAuth = false}) async {
  late dio.Response<dynamic> response;

  try {
    var dio = Dio();
    var formData = FormData.fromMap({
      'profile_pic': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (isAuth && token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    response = await dio.patch(
      url.toString(),
      data: formData,
    );
  } catch (e) {
    response = dio.Response(
      statusCode: 408,
      requestOptions: RequestOptions(path: url.toString()),
      data: {
        'error': {'message': 'Timeout error'}
      },
    );
  }

  apidebugPrint(
    url: url.toString(),
    hasRequest: true,
    headers: response.requestOptions.headers.toString(),
    responseBody: jsonEncode(response.data),
    request: response.requestOptions.data.toString(),
    statusCode: response.statusCode!,
  );

  return response;
}
