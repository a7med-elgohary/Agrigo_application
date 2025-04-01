import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// الأحداث (Events)
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// الحالات (States)
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess(this.token);

  @override
  List<Object?> get props => [token];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// الـ Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio;

  LoginBloc({required this.dio}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await dio.post(
        'https://green-api-ten.vercel.app/api/auth/login', // استبدل هذا بعنوان الـ API الخاص بك
        data: {
          'email': event.email,
          'password': event.password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        emit(LoginSuccess(response.data['token'])); // استخرج التوكن من الاستجابة
      } else {
        emit(LoginFailure(response.data['message'] ?? "Invalid credentials"));
      }
    } catch (e) {
      emit(LoginFailure("An error occurred: ${e.toString()}"));
    }
  }
}
