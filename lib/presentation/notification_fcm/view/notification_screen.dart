import 'dart:developer';
import 'package:demo/presentation/notification_fcm/controller/notification_get_controlller.dart';
import 'package:demo/presentation/notification_fcm/model/notification_get_model.dart';
import 'package:demo/presentation/orders/view/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationController>(
      context,
      listen: false,
    ).loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete_sweep),
        //     onPressed: () => _showClearAllDialog(context),
        //   ),
        // ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ll notify you when something arrives',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<NotificationController>(
                context,
                listen: false,
              ).loadNotifications();
            },
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              itemCount: controller.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                Datum notification = controller.notifications[index];
                final bool isRead = notification.read ?? false;
                // final timeAgo = _formatTimeAgo(notification.createdAt);

                return Dismissible(
                  key: Key(notification.id ?? index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmation(
                      context,
                      notification.id!,
                    );
                  },
                  onDismissed: (direction) {
                    Provider.of<NotificationController>(
                      context,
                      listen: false,
                    ).deleteNotificationById(notification.id!);
                  },
                  child: Material(
                    color: isRead ? Colors.grey[50] : Colors.blue[50],
                    child: InkWell(
                      onTap: () {
                        final orderId = notification.data?.orderId;

                        if (orderId != null && orderId.isNotEmpty) {
                          Provider.of<NotificationController>(
                            context,
                            listen: false,
                          ).markNotificationAsRead(notification.id!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => OrderDetailsScreen(orderId: orderId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No order linked to this notification',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isRead
                                        ? Colors.grey[300]
                                        : Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getNotificationIcon(notification.title),
                                size: 20,
                                color: isRead ? Colors.grey[600] : Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          notification.title ?? "No Title",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                isRead
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                            color:
                                                isRead
                                                    ? Colors.grey[600]
                                                    : Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // Text(
                                      //   timeAgo,
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     color: Colors.grey[500],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.body ?? "No Body",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isRead
                                              ? Colors.grey[600]
                                              : Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String? title) {
    if (title == null) return Icons.notifications;
    if (title.toLowerCase().contains('order')) return Icons.shopping_bag;
    if (title.toLowerCase().contains('payment')) return Icons.payment;
    if (title.toLowerCase().contains('shipping')) return Icons.local_shipping;
    return Icons.notifications;
  }

  String _formatTimeAgo(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d').format(date);
      }
    } catch (e) {
      return '';
    }
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String notificationId,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text("Delete Notification"),
                content: const Text(
                  "Are you sure you want to delete this notification?",
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
        ) ??
        false;
  }

  // void _showClearAllDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text("Clear All Notifications"),
  //       content: const Text(
  //         "Are you sure you want to delete all notifications?",
  //       ),
  //       actions: [
  //         TextButton(
  //           child: const Text("Cancel"),
  //           onPressed: () => Navigator.of(ctx).pop(),
  //         ),
  //         TextButton(
  //           child: const Text(
  //             "Clear All",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //             Provider.of<NotificationController>(context, listen: false)
  //                 .clearAllNotifications();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
