import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

// الأحداث (Events)
abstract class ChatBotEvent extends Equatable {
  const ChatBotEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatBotEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ClearChatEvent extends ChatBotEvent {
  const ClearChatEvent();

  @override
  List<Object> get props => [];
}

// الحالات (States)
abstract class ChatBotState extends Equatable {
  const ChatBotState();

  @override
  List<Object> get props => [];
}

class ChatBotInitial extends ChatBotState {}

class ChatBotLoaded extends ChatBotState {
  final List<Map<String, String>> messages;

  const ChatBotLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatBotError extends ChatBotState {
  final String error;

  const ChatBotError(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"; // النقطة النهائية الصحيحة
  static const String apiKey =
      "AIzaSyASwRHpPYXZRPGFzvNCUiSRPHdk6POgygM"; // مفتاح API الخاص بك

  ChatBotBloc() : super(const ChatBotLoaded([])) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat); // إضافة معالج لمسح الشات
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatBotState> emit) async {
    final currentState = state;
    List<Map<String, String>> messages = [];

    if (currentState is ChatBotLoaded) {
      messages = List.from(currentState.messages); // الاحتفاظ بالرسائل القديمة
    }

    // إضافة رسالة المستخدم
    messages.add({"role": "user", "content": event.message});
    // إضافة رسالة مؤقتة للشات بوت
    messages.add({"role": "bot", "content": "loading"});
    emit(ChatBotLoaded(List.from(messages))); // إصدار حالة جديدة مع الرسائل

    try {
      // إرسال الرسالة إلى الـ API
      final dio = Dio();
      final response = await dio.post(
        "$apiUrl?key=$apiKey",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": event.message}
              ]
            }
          ]
        }),
      );

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        final data = response.data;

        // التحقق من وجود الحقول المطلوبة
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty &&
            data['candidates'][0]['content']['parts'][0]['text'] != null) {
          final botResponse =
              data['candidates'][0]['content']['parts'][0]['text'];
          print("Bot response: $botResponse");

          // استبدال الرسالة المؤقتة بالرد الفعلي
          messages.removeLast(); // إزالة الرسالة المؤقتة
          messages.add({"role": "bot", "content": botResponse});
          emit(ChatBotLoaded(List.from(messages))); // إصدار حالة جديدة مع الرد
        } else {
          print("Invalid API response structure: $data");
          messages.removeLast(); // إزالة الرسالة المؤقتة
          messages.add(
              {"role": "bot", "content": "Invalid API response structure"});
          emit(ChatBotLoaded(List.from(messages)));
        }
      } else {
        print("Error from API: ${response.statusCode} - ${response.data}");
        messages.removeLast(); // إزالة الرسالة المؤقتة
        messages
            .add({"role": "bot", "content": "Error: ${response.statusCode}"});
        emit(ChatBotLoaded(List.from(messages)));
      }
    } catch (e) {
      print("Exception: $e");
      messages.removeLast(); // إزالة الرسالة المؤقتة
      messages.add({"role": "bot", "content": "Error: Unable to get response"});
      emit(ChatBotLoaded(List.from(messages)));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<ChatBotState> emit) {
    emit(const ChatBotLoaded([])); // إعادة الحالة إلى قائمة فارغة
  }
}
