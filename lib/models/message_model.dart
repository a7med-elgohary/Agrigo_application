enum Role { user, assistant }

class Message {
  final String messageId; // معرف الرسالة
  final String chatId; // معرف المحادثة
  final Role role; // دور المرسل (مستخدم أو مساعد)
  final String message; // نص الرسالة
  final List<String> imagesUrls; // روابط الصور (إذا كانت موجودة)
  final DateTime timeSent; // وقت إرسال الرسالة

  // Constructor
  Message({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.timeSent,
  });

  // تحويل الرسالة إلى خريطة (Map) لتخزينها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message,
      'imagesUrls': imagesUrls,
      'timeSent': timeSent.toIso8601String(),
    };
  }

  // إنشاء رسالة من خريطة (Map)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      message: map['message'],
      imagesUrls: List<String>.from(map['imagesUrls']),
      timeSent: DateTime.parse(map['timeSent']),
    );
  }
}