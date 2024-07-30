import 'package:dio/dio.dart';

class TwilioFunctionsService {
  TwilioFunctionsService._();
  static final instance = TwilioFunctionsService._();

  final Dio _dio = Dio();
  final String accessTokenUrl = '<SERVERLESS_TWILIO_URL>';

  Future<String> createToken(String identity) async {
    try {
      final response =
          await _dio.get(accessTokenUrl, queryParameters: {'user': identity});
      return response.data['accessToken'];
    } catch (error) {
      throw Exception('Failed to create token: $error');
    }
  }
}
