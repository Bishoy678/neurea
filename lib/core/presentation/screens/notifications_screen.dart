// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neurea/Home/Home_Screen_daily.dart';
import 'package:neurea/cubit/notification/notification_cubit.dart';
import 'package:neurea/cubit/notification/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..loadNotifications(),
      child: const _NotificationScreenBody(),
    );
  }
}

class _NotificationScreenBody extends StatefulWidget {
  const _NotificationScreenBody();

  @override
  State<_NotificationScreenBody> createState() =>
      _NotificationScreenBodyState();
}

class _NotificationScreenBodyState extends State<_NotificationScreenBody> {
  int _selectedTab = 0;

  static const _purple = Color(0xFF5C2D91);
  static const _lightPurple = Color(0xFFF0E8FF);
  static const _grey = Color(0xFFF7F7F7);

  String _formatTime(String createdAt) {
    final diff = DateTime.now().difference(DateTime.parse(createdAt).toLocal());
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'wellness':
        return Icons.favorite_rounded;
      case 'journal':
        return Icons.menu_book_rounded;
      case 'achievement':
        return Icons.emoji_events_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> all) {
    switch (_selectedTab) {
      case 1:
        return all.where((n) => n['is_read'] == false).toList();
      case 2:
        return all.where((n) => n['is_read'] == true).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final cubit = context.read<NotificationCubit>();
        final all = state is NotificationLoaded
            ? state.notifications
            : <Map<String, dynamic>>[];
        final unreadCount = state is NotificationLoaded ? state.unreadCount : 0;
        final isLoading = state is NotificationLoading;
        final filtered = _filtered(List<Map<String, dynamic>>.from(all));

        return Scaffold(
          backgroundColor: const Color(0xFFFAF8FD),
          appBar: _buildAppBar(context, sw),
          body: Column(
            children: [
              _buildTabBar(sw, unreadCount),
              const SizedBox(height: 8),
              Expanded(
                child: _buildBody(context, cubit, sw, isLoading, filtered),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, double sw) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Colors.black87,
        ),
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreenDaily()),
          (r) => false,
        ),
      ),
      title: Text(
        'Notifications',
        style: TextStyle(
          color: const Color(0xFF3E225C),
          fontSize: sw * 0.042,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.shade100),
      ),
    );
  }

  Widget _buildTabBar(double sw, int unreadCount) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: 12),
      child: Row(
        children: [
          _tab(sw, 'All', 0, unreadCount),
          SizedBox(width: sw * 0.06),
          _tab(sw, 'Unread', 1, unreadCount),
          SizedBox(width: sw * 0.06),
          _tab(sw, 'Read', 2, unreadCount),
        ],
      ),
    );
  }

  Widget _tab(double sw, String label, int index, int unreadCount) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: 7),
        decoration: BoxDecoration(
          color: active ? _purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: active ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: sw * 0.033,
              ),
            ),
            if (index == 1 && unreadCount > 0) ...[
              SizedBox(width: sw * 0.015),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.018,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: active ? Colors.white.withOpacity(0.3) : _purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * 0.025,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationCubit cubit,
    double sw,
    bool isLoading,
    List<Map<String, dynamic>> filtered,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: _purple));
    }
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'No notifications',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: cubit.loadNotifications,
      color: _purple,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: 12),
        itemCount: filtered.length,
        itemBuilder: (context, i) =>
            _dismissible(context, cubit, sw, filtered[i]),
      ),
    );
  }

  Widget _dismissible(
    BuildContext context,
    NotificationCubit cubit,
    double sw,
    Map<String, dynamic> notif,
  ) {
    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: sw * 0.035),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: sw * 0.05),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Notification',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to delete this notification?',
          ),
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
      ),
      onDismissed: (_) => cubit.deleteNotification(notif['id']),
      child: _card(context, cubit, sw, notif),
    );
  }

  Widget _card(
    BuildContext context,
    NotificationCubit cubit,
    double sw,
    Map<String, dynamic> notif,
  ) {
    final isRead = notif['is_read'] == true;
    final type = notif['type'] ?? 'general';

    return GestureDetector(
      onTap: () {
        if (!isRead) cubit.markAsRead(notif['id']);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: sw * 0.035),
        padding: EdgeInsets.all(sw * 0.04),
        decoration: BoxDecoration(
          color: isRead ? _grey : _lightPurple,
          borderRadius: BorderRadius.circular(16),
          border: isRead
              ? Border.all(color: Colors.grey.shade200)
              : Border.all(color: _purple.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isRead
                    ? Colors.grey.shade200
                    : _purple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(type), color: _purple, size: sw * 0.05),
            ),
            SizedBox(width: sw * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif['title'] ?? '',
                          style: TextStyle(
                            fontSize: sw * 0.038,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _formatTime(notif['created_at']),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: sw * 0.028,
                            ),
                          ),
                          if (!isRead) ...[
                            SizedBox(width: sw * 0.02),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: _purple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: sw * 0.015),
                  Text(
                    notif['description'] ?? '',
                    style: TextStyle(
                      fontSize: sw * 0.033,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
