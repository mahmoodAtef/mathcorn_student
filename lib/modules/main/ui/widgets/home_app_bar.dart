import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_corn/core/extentions/string_direction_extention.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/utils/assets_manager.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/notifications/cubit/notifications_cubit.dart';
import 'package:sizer/sizer.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..getMessageOfTheDay(),
      child: SliverAppBar(
        expandedHeight: 35.h,
        collapsedHeight: 0,
        toolbarHeight: 0,
        pinned: false,
        floating: true,
        snap: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: _buildHeaderWithNotification(context),
          collapseMode: CollapseMode.parallax,
        ),
      ),
    );
  }

  Widget _buildHeaderWithNotification(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AssetsManager.notificationImage,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            left: 8.w,
            top: 8.h,
            right: 35.w,
            bottom: 15.h,
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   S.of(context).notifications,
                  //   style: TextStyle(
                  //     fontSize: 16.sp,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //     shadows: [
                  //       Shadow(
                  //         offset: Offset(1, 1),
                  //         blurRadius: 2,
                  //         color: Colors.white.withOpacity(0.8),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 1.h),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Builder(
                        builder: (context) {
                          return BlocBuilder<
                            NotificationsCubit,
                            NotificationsState
                          >(
                            builder: (context, state) {
                              String messageText;

                              switch (state.status) {
                                case NotificationsStatus.loading:
                                  messageText = "...";
                                  break;
                                case NotificationsStatus.failure:
                                  messageText = S.of(context).cannotGetMessage;
                                  break;
                                case NotificationsStatus.success:
                                  messageText =
                                      state.messageOfTheDay ??
                                      S.of(context).cannotGetMessage;
                                  break;
                                case NotificationsStatus.initial:
                                default:
                                  messageText = "...";
                                  break;
                              }

                              return Text(
                                messageText,
                                textAlign: TextAlign.center,
                                textDirection: messageText.getDirection,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 1,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
