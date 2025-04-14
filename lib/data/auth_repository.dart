import 'package:dio/dio.dart';

class AuthRepository {
  final Dio dio;
  AuthRepository({required this.dio}); // ✅ تمرير Dio كـ dependency

  Future<Response> login(String username, String password) async {
    try {
      final response = await dio.post(
        'https://green-lilac-pi.vercel.app/api/auth/login',
        data: {'email': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return response; // ✅ إرجاع الاستجابة إذا كانت ناجحة
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "Login failed: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: "Error: ${e.message}",
        type: e.type,
      );
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        'https://green-lilac-pi.vercel.app/api/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "Registration failed: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        message: "Error: ${e.message}",
        type: e.type,
      );
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}