class ChatMessage {
  final String content;
  final Sender sender;

  ChatMessage({required this.content, required this.sender});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      sender: json['sender'] == 'user' ? Sender.user : Sender.ai,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender == Sender.user ? 'user' : 'ai',
    };
  }
}

enum Sender { user, ai }
