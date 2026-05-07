// ignore_for_file: unused_local_variable, empty_catches, unused_element
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TherapistChatWithMessagesScreen extends StatefulWidget {
  final String therapistName;
  final String therapistImage;
  final String? therapistId;

  const TherapistChatWithMessagesScreen({
    super.key,
    required this.therapistName,
    required this.therapistImage,
    this.therapistId,
  });

  @override
  State<TherapistChatWithMessagesScreen> createState() => _TherapistChatWithMessagesScreenState();
}

class _TherapistChatWithMessagesScreenState extends State<TherapistChatWithMessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToRealtime();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    if (widget.therapistId == null || widget.therapistId!.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final response = await Supabase.instance.client
        .from('chat_messages')
        .select()
        .eq('user_id', userId)
        .eq('therapist_id', widget.therapistId!)
        .order('created_at', ascending: true);

    setState(() {
      _messages = List<Map<String, dynamic>>.from(response);
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _subscribeToRealtime() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    
    if (widget.therapistId == null || widget.therapistId!.isEmpty) return;

    _channel = Supabase.instance.client
        .channel('chat_messages_${widget.therapistId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            final newMessage = payload.newRecord;
            if (newMessage['user_id'] == userId && 
                newMessage['therapist_id'] == widget.therapistId) {
              setState(() {
                _messages.add(newMessage);
              });
              _scrollToBottom();
            }
          },
        )
        .subscribe();
  }

  Future<void> _deleteMessage(Map<String, dynamic> message, int index) async {
    try {
      
      await Supabase.instance.client
          .from('chat_messages')
          .delete()
          .eq('id', message['id']);
      
    
      setState(() {
        _messages.removeAt(index);
      });
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted'), backgroundColor: Colors.green),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    
    if (widget.therapistId == null || widget.therapistId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Therapist ID not found'), backgroundColor: Colors.red),
      );
      return;
    }

    _messageController.clear();

    final tempId = DateTime.now().millisecondsSinceEpoch;
    final tempMessage = {
      'id': tempId,
      'content': text,
      'is_sent': true,
      'created_at': DateTime.now().toIso8601String(),
      'user_id': userId,
      'therapist_id': widget.therapistId,
    };
    
    setState(() {
      _messages.add(tempMessage);
    });
    _scrollToBottom();

    
    try {
      final response = await Supabase.instance.client
          .from('chat_messages')
          .insert({
            'user_id': userId,
            'therapist_id': widget.therapistId,
            'content': text,
            'is_sent': true,
          })
          .select();
      
      
      if (response.isNotEmpty) {
        final realMessage = response[0];
        final index = _messages.indexWhere((msg) => msg['id'] == tempId);
        if (index != -1) {
          setState(() {
            _messages[index] = realMessage;
          });
        }
      }
    } catch (e) {
      
      setState(() {
        _messages.removeWhere((msg) => msg['id'] == tempId);
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message'), backgroundColor: Colors.red),
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.therapistImage.startsWith('http')
                      ? NetworkImage(widget.therapistImage)
                      : AssetImage(widget.therapistImage) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4AD991),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.therapistName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Color(0xFF4AD991),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Messages are end-to-end encrypted.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF5C2D91)))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSent = message['is_sent'] ?? true;
                      final isTemp = message['id'] is int && message['id'] > 1000000;
                      
                      return Dismissible(
                        key: Key(message['id'].toString()),
                        direction: isSent ? DismissDirection.endToStart : DismissDirection.none,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Message'),
                              content: const Text('Are you sure you want to delete this message?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) => _deleteMessage(message, index),
                        child: Align(
                          alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSent ? const Color(0xFF5C2D91) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: isTemp ? Border.all(color: Colors.orange, width: 1) : null,
                            ),
                            child: Text(
                              message['content'] ?? '',
                              style: TextStyle(
                                color: isSent ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Write a message...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5C2D91),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
