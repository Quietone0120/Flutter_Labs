import 'dart:async';

// --------------------------------------------------------------------------
// DATA MODEL
// --------------------------------------------------------------------------
class ChatMessage {
  final String text;
  final DateTime time;
  final String senderId; // 'A' or 'B'
  final MessageStatus status;

  ChatMessage({
    required this.text,
    required this.time,
    required this.senderId,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({MessageStatus? status}) {
    return ChatMessage(
      text: text,
      time: time,
      senderId: senderId,
      status: status ?? this.status,
    );
  }
}

enum MessageStatus { sending, sent, delivered, seen }

// --------------------------------------------------------------------------
// SHARED CHAT BLOC
// --------------------------------------------------------------------------
class ChatBloc {
  final List<ChatMessage> _messages = [];
  final StreamController<List<ChatMessage>> _controller =
      StreamController<List<ChatMessage>>.broadcast();

  Stream<List<ChatMessage>> get messageStream => _controller.stream;
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String text, String senderId) {
    if (text.trim().isEmpty) return;

    final msg = ChatMessage(
      text: text.trim(),
      time: DateTime.now(),
      senderId: senderId,
      status: MessageStatus.sent,
    );
    _messages.add(msg);
    _controller.sink.add(List.from(_messages));

    // Simulate "seen" after short delay when the other person is active
    Future.delayed(const Duration(milliseconds: 800), () {
      final idx = _messages.indexOf(msg);
      if (idx != -1) {
        _messages[idx] = msg.copyWith(status: MessageStatus.seen);
        _controller.sink.add(List.from(_messages));
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}
