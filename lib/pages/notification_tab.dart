import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../cubits/notification/notification_cubit.dart';
import '../models/notifications.dart';
import '../utils/constants.dart';


/// Tab that displays in app notifications.
class NotificationTab extends StatelessWidget {
  /// Method ot create this page with necessary `BlocProvider`
  static Widget create() {
    return Material(
      color: Colors.transparent,
      child: NotificationTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding;
    return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial) {
            return preloader;
          } else if (state is NotificationEmpty) {
            return const Center(
                child: Text('You don\'t have any notifications yet'));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            return RefreshIndicator(
              onRefresh: () {
                return BlocProvider.of<NotificationCubit>(context)
                    .loadNotifications();
              },
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 16 + safeAreaPadding.top,
                  bottom: 16 + safeAreaPadding.bottom,
                ),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _NotificationCell(
                    notification: notifications[index],
                  );
                },
              ),
            );
          }
          throw UnimplementedError();
        });
  }
}

class _NotificationCell extends StatelessWidget {
  const _NotificationCell({
    Key? key,
    required AppNotification notification,
  })  : _notification = notification,
        super(key: key);

  final AppNotification _notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // switch (_notification.type) {
        //   case NotificationType.like:
        //     Navigator.of(context).push(
        //         ViewVideoPage.route(videoId: _notification.targetVideoId!));
        //     break;
        //   case NotificationType.comment:
        //     Navigator.of(context).push(
        //         ViewVideoPage.route(videoId: _notification.targetVideoId!));
        //     break;
        //   case NotificationType.mentioned:
        //     Navigator.of(context).push(
        //         ViewVideoPage.route(videoId: _notification.targetVideoId!));
        //     break;
        //   case NotificationType.follow:
        //     Navigator.of(context)
        //         .push(ProfilePage.route(_notification.actionUid!));
        //     break;
        //   case NotificationType.other:
        //     break;
        // }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        child: Row(
          children: [
            // ProfileImage(
            //   imageUrl: _notification.actionUserImageUrl,
            //   onPressed: () {
            //     Navigator.of(context)
            //         .push(ProfilePage.route(_notification.actionUid!));
            //   },
            // ),
            SizedBox(
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: (){},
                child: ClipOval(
                  child:  _notification.actionUserImageUrl == null
                      ? Image.asset(
                    'assets/images/user.png',
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    _notification.actionUserImageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(text: _notificationText),
                        TextSpan(
                          text: ' ${howLongAgo(_notification.createdAt)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_notification.isNew)
                    const Positioned(
                      top: -2,
                      right: -2,
                      child: SizedBox(
                        width: 6,
                        height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: redOrangeGradient,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (_notification.targetPostThumbnail != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _notification.targetPostThumbnail!,
                  width: 40,
                  height: 40,
                ),
              ),
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(_notificationIconPath),
            ),
          ],
        ),
      ),
    );
  }

  String get _notificationText {
    switch (_notification.type) {
      case NotificationType.like:
        return '${_notification.actionUserName} liked your video';
      case NotificationType.comment:
        return '${_notification.actionUserName} commented'
            ' "${_notification.commentText}"';
      case NotificationType.mentioned:
        return '${_notification.actionUserName} mentioned you in'
            ' a comment "${_notification.commentText}"';
      case NotificationType.follow:
        return '${_notification.actionUserName} started following you';
      case NotificationType.other:
        return '';
    }
  }

  String get _notificationIconPath {
    switch (_notification.type) {
      case NotificationType.like:
        return 'assets/images/like.png';
      case NotificationType.comment:
        return 'assets/images/comment.png';
      case NotificationType.mentioned:
        return 'assets/images/mentioned.png';
      case NotificationType.follow:
        return 'assets/images/follower.png';
      case NotificationType.other:
        return 'assets/images/like.png';
    }
  }
}