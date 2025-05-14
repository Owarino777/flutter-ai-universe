class Message {
  final int id;
  final int conversationId;
  final String content;
  final String sender; // "user" ou "character"
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    conversationId: json["conversation_id"],
    content: json["content"] ?? "",
    sender: json["is_sent_by_human"] == true ? "user" : "character",
    createdAt: DateTime.parse(json["created_at"]),
  );
}
