import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// الأحداث (Events)
abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

// الحالات (States)
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// الـ Bloc
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Dio dio;

  RegisterBloc({required this.dio}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      // طباعة البيانات المرسلة
      print("Sending data: ${{
        'name': event.name,
        'email': event.email,
        'password': event.password,
      }}");

      final response = await dio.post(
        'https://green-api-ten.vercel.app/api/auth/register', // عنوان الـ API
        data: {
          'name': event.name,
          'email': event.email,
          'password': event.password,
        },
      );

      // طباعة الاستجابة
      print("Response: ${response.data}");

      // التحقق من حالة الاستجابة
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data['message'] != null) {
        emit(RegisterSuccess(response.data['message'])); // عرض رسالة النجاح
      } else {
        emit(RegisterFailure(
            response.data['error'] ?? "Failed to register. Please try again."));
      }
    } catch (e) {
      emit(RegisterFailure("An error occurred: ${e.toString()}"));
    }
  }
}