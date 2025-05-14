import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import '../models/message.dart';
import '../models/character.dart';
import '../models/conversation.dart';
import '../services/message_service.dart';
import '../providers/auth_provider.dart';
import '../widgets/cached_auth_image.dart';

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
  final ScrollController _scrollController = ScrollController();

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
      if (!mounted) return;

      setState(() {
        _messages.clear();
        _messages.addAll(loaded);
        _isLoading = false;
      });

      // Attendre la fin de frame + petit délai, puis scroll à la fin
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
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

      if (!mounted) return;

      setState(() {
        _messages.addAll(newMessages);
        _controller.clear();
      });

      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Erreur envoi message : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'envoi du message.")),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Widget _buildMessageBubble(Message msg) {
    final isUser = msg.sender == "user";
    final bgColor = isUser ? Colors.amberAccent : const Color.fromARGB(25, 255, 255, 255);
    final textColor = isUser ? Colors.black : Colors.white;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Text(
          msg.content,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: const Color.fromARGB(153, 0, 0, 0)),

          SafeArea(
            child: Column(
              children: [
                // 👤 HEADER avec retour
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          character.imageUrl.startsWith("http")
                              ? character.imageUrl
                              : "https://yodai.wevox.cloud/image_data/${character.imageUrl}",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Discussion avec ${character.name}",
                          style: const TextStyle(
                            fontFamily: 'MedievalSharp',
                            fontSize: 20,
                            color: Colors.amberAccent,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.grey[900],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 500, maxWidth: 360),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Text(
                                        character.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      CachedAuthImage(
                                        imageUrl: character.imageUrl.startsWith("http")
                                            ? character.imageUrl
                                            : "https://yodai.wevox.cloud/image_data/${character.imageUrl}",
                                        token: _token,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        character.description,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // 💬 MESSAGES
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                      : _messages.isEmpty
                      ? const Center(
                    child: Text(
                      "Aucun message pour l'instant.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                      : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
                  ),
                ),

                // 📝 TEXTFIELD avec envoi par entrée
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: !_isSending,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: _isSending ? null : _sendMessage,
                          decoration: InputDecoration(
                            hintText: "Écris ton message ici...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: const Color.fromARGB(25, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: _isSending ? Colors.grey : Colors.amberAccent),
                        onPressed: _isSending ? null : () => _sendMessage(_controller.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
