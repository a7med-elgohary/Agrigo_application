import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chatbot_bloc.dart';
import 'package:flutter/services.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final ScrollController scrollController = ScrollController(); // ← إضافة ScrollController

    void scrollToBottom() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<ChatBotBloc>().add(const ClearChatEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBotBloc, ChatBotState>(
              builder: (context, state) {
                if (state is ChatBotLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom(); // ← التمرير تلقائيًا عند تحديث الرسائل
                  });

                  return ListView.builder(
                    controller: scrollController, // ← ربط ScrollController
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isUser = message['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.green
                                    : Colors.blueGrey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: isUser
                                      ? const Radius.circular(12)
                                      : Radius.zero,
                                  bottomRight: isUser
                                      ? Radius.zero
                                      : const Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                message['content'] ?? '',
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: message['content'] ?? ''));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Text copied to clipboard!')),
                                );
                              },
                              icon: const Icon(Icons.copy,
                                  size: 16, color: Colors.grey),
                              label: const Text(
                                'Copy',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ChatBotError) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: Text('No messages yet.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    final message = controller.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ChatBotBloc>().add(SendMessageEvent(message));
                      controller.clear();
                      scrollToBottom(); // ← التمرير بعد الإرسال مباشرةً
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
