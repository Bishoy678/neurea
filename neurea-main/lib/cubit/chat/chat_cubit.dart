import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Map<String, dynamic>> _messages = [];
  RealtimeChannel? _channel;
  String? _therapistId;

  Future<void> loadMessages(String? therapistId) async {
    _therapistId = therapistId;
    emit(ChatLoading());

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(ChatError('User not logged in'));
        return;
      }

      
      var query = Supabase.instance.client
          .from('chat_messages')
          .select()
          .eq('user_id', userId);

      if (therapistId != null && therapistId.isNotEmpty) {
        query = query.eq('therapist_id', therapistId);
      }

      final data = await query.order('created_at', ascending: true);

      _messages = List<Map<String, dynamic>>.from(data);
      emit(ChatLoaded(List.from(_messages)));

      _subscribeRealtime(userId, therapistId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _subscribeRealtime(String userId, String? therapistId) {
    _channel?.unsubscribe();

    _channel = Supabase.instance.client
        .channel('chat_messages_$therapistId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            final newMessage = payload.newRecord;
           
            final isDuplicate = _messages.any((msg) => 
                msg['content'] == newMessage['content'] && 
                msg['created_at'] == newMessage['created_at']);
            
            if (!isDuplicate && newMessage['user_id'] == userId &&
                newMessage['therapist_id'] == therapistId) {
              _messages.add(newMessage);
              emit(ChatLoaded(List.from(_messages)));
            }
          },
        )
        .subscribe();
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final tempMessage = {
      'user_id': userId,
      'therapist_id': _therapistId,
      'content': content.trim(),
      'is_sent': true,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    _messages.add(tempMessage);
    emit(ChatLoaded(List.from(_messages)));  

    try {
      await Supabase.instance.client.from('chat_messages').insert({
        'user_id': userId,
        'therapist_id': _therapistId,
        'content': content.trim(),
        'is_sent': true,
      });
      
    } catch (e) {
      _messages.removeWhere((msg) => msg == tempMessage);
      emit(ChatLoaded(List.from(_messages)));
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
} 
  