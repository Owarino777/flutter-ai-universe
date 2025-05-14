import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../models/character.dart';
import '../models/conversation.dart';
import '../services/message_service.dart';
import '../providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;
  final Character character;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.character,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  late String _token;
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    _token = context.read<AuthProvider>().token!;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final loaded = await _messageService.fetchMessages(
        _token,
        widget.conversation.id,
      );
      setState(() {
        _messages.clear();
        _messages.addAll(loaded);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Erreur chargement messages : $e");
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() => _isSending = true);

    try {
      final newMessages = await _messageService.sendMessage(
        _token,
        widget.conversation.id,
        text.trim(),
      );

      setState(() {
        _messages.addAll(newMessages);
        _controller.clear();
      });

      // Forcer la mise à jour de l'interface utilisateur
      setState(() {});
    } catch (e) {
      debugPrint("Erreur envoi message : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'envoi du message.")),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Widget _buildMessageBubble(Message msg) {
    final isUser = msg.sender == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion avec ${character.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(character.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        character.imageUrl.startsWith("http")
                            ? character.imageUrl
                            : "https://yodai.wevox.cloud/image_data/${character.imageUrl}",
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      Text(character.description),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text("Aucun message pour l'instant."))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isSending,
                    decoration: const InputDecoration(
                      hintText: "Écris un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _isSending ? Colors.grey : Colors.blue,
                  ),
                  onPressed: _isSending
                      ? null
                      : () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
