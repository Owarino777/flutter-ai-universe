import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late OpenAIService _openAIService;

  @override
  void initState() {
    super.initState();
    _openAIService = OpenAIService();
  }

  void _sendMessage(String text, Character character) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
    });

    String aiResponse = await _openAIService.generateResponse(
      text,
      character.name,
      character.description,
    );

    setState(() {
      _messages.add({"sender": "ai", "text": aiResponse});
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context)!.settings.arguments as Character;

    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion avec ${character.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(character.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(character.imageUrl, height: 150),
                        const SizedBox(height: 10),
                        Text(character.description),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Écris un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => _sendMessage(_messageController.text, character),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
