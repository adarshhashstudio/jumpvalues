import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:jumpvalues/main.dart';
import 'package:jumpvalues/network/status_codes.dart';
import 'package:jumpvalues/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

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

Future<Response<dynamic>> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.get,
  Map<String, dynamic>? request,
  Map<String, dynamic>? extraKeys,
  bool isAuth = false,
  bool isJsonEncode = false,
}) async {
  if (await isNetworkAvailable()) {
    Map<String, dynamic>? headerReq;
    if (appStore.isLoggedIn) {
      headerReq = {'Authorization': 'Bearer ${appStore.token}'};
    } else {
      headerReq = null;
    }
    var headers = buildHeaderTokens(extraKeys: isAuth ? headerReq : {});
    var url = buildBaseUrl(endPoint);

    late Response response;
    var dio = Dio();

    dio.options.connectTimeout = const Duration(seconds: 10);

    try {
      response = await dio.request(
        url.toString(),
        data: request,
        options: Options(
          method: method.name,
          headers: headers,
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        response = Response(
          statusCode: e.response?.statusCode ?? StatusCode.defaultError,
          requestOptions: RequestOptions(path: endPoint),
          data: e.response?.data,
        );
      } else {
        response = Response(
          statusCode: StatusCode.defaultError,
          requestOptions: RequestOptions(path: endPoint),
          data: {
            'error': {'message': handleDioError(e)}
          },
        );
      }
    } catch (e) {
      response = Response(
        statusCode: StatusCode.defaultError,
        requestOptions: RequestOptions(path: endPoint),
        data: {
          'error': {'message': e.toString()}// TODO: change as something went wrong
        },
      );
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
    return Response(
      statusCode: StatusCode.noInternetConnection,
      requestOptions: RequestOptions(path: endPoint),
      data: {
        'error': {'message': 'No internet connection available'}
      },
    );
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

Future<Response<dynamic>> uploadImage(Uri url, File imageFile,
    {Map<String, String>? fields, bool isAuth = false}) async {
  late Response<dynamic> response;
  var dio = Dio();
  var formData = FormData();
  try {
    formData = FormData.fromMap({
      'dp': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    if (isAuth && appStore.isLoggedIn) {
      dio.options.headers['Authorization'] = 'Bearer ${appStore.token}';
    }

    response = await dio.patch(url.toString(), data: formData);
  } on DioException catch (e) {
    response = Response(
      statusCode: StatusCode.defaultError,
      requestOptions: RequestOptions(path: url.toString()),
      data: {
        'error': {'message': handleDioError(e)}
      },
    );
  }

  apidebugPrint(
    url: url.toString(),
    headers: jsonEncode(dio.options.headers),
    hasRequest: false,
    request: jsonEncode(formData.fields),
    statusCode: response.statusCode!,
    responseBody: jsonEncode(response.data),
    methodtype: 'PATCH',
  );

  return response;
}

String handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionError:
      return 'Connection timeout';
    case DioExceptionType.sendTimeout:
      return 'Send timeout';
    case DioExceptionType.receiveTimeout:
      return 'Receive timeout';
    case DioExceptionType.cancel:
      return 'Request cancelled';
    case DioExceptionType.unknown:
      return 'Unknown error occurred';
    default:
      return error.message ?? 'Something went wrong, Try after sometime.';
  }
}
