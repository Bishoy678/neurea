// notification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final _db = Supabase.instance.client;
  List<Map<String, dynamic>> _notifications = [];
  String? get _userId => _db.auth.currentUser?.id;

  Future<void> loadNotifications() async {
    if (isClosed) return;

    final uid = _userId;
    if (uid == null) {
      emit(NotificationError('User not logged in'));
      return;
    }

    emit(NotificationLoading());

    try {
      final response = await _db
          .from('notifications')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      _notifications = List<Map<String, dynamic>>.from(response);
      _emitLoaded();
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    await _db.from('notifications').update({'is_read': true}).eq('id', id);

    _updateLocal(id, {'is_read': true});
    _emitLoaded();
  }

  Future<void> markAllAsRead() async {
    final uid = _userId;
    if (uid == null) return;

    await _db
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid);

    _notifications = _notifications
        .map((n) => {...n, 'is_read': true})
        .toList();

    _emitLoaded();
  }

  Future<void> deleteNotification(String id) async {
    await _db.from('notifications').delete().eq('id', id);

    _notifications.removeWhere((n) => n['id'] == id);
    _emitLoaded();
  }

  List<Map<String, dynamic>> getUnread() =>
      _notifications.where((n) => n['is_read'] == false).toList();

  void _updateLocal(String id, Map<String, dynamic> updates) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index == -1) return;
    _notifications[index] = {..._notifications[index], ...updates};
  }

  void _emitLoaded() {
    if (isClosed) return;
    emit(
      NotificationLoaded(
        notifications: List<Map<String, dynamic>>.from(_notifications),
        unreadCount: _notifications.where((n) => n['is_read'] == false).length,
      ),
    );
  }
}
