import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// 🔹 كلاس لإدارة الاتصال بالـ API عبر Dio
class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'https://green-lilac-pi.vercel.app/api/auth';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final errorMessage = e.response?.data['message'] ?? 'Unknown error';
      return Exception("API Error: $errorMessage");
    } else {
      return Exception("Network Error: ${e.message}");
    }
  }
}

/// 🔹 أحداث تسجيل الدخول
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// 🔹 حالات تسجيل الدخول
class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? token;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.token,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? token,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess, token];
}

/// 🔹 `LoginBloc`
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DioClient dioClient;

  LoginBloc({required this.dioClient}) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final response = await dioClient.login(event.email, event.password);
      if (response.statusCode == 200 && response.data['token'] != null) {
        emit(state.copyWith(
            isLoading: false, isSuccess: true, token: response.data['token']));
      } else {
        emit(state.copyWith(
            isLoading: false, errorMessage: "Invalid credentials"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
