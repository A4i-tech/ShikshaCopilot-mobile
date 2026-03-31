import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays an individual chat message bubble.
///
/// This widget can render a message from the user or from the chatbot,
/// with appropriate styling and a copy option for bot messages.
class MessageBubble extends StatelessWidget {
  /// Creates a new [MessageBubble].
  ///
  /// The [text] is the content of the message, and [isUser] determines
  /// if it's a user's message (true) or a bot's message (false).
  const MessageBubble({required this.text, required this.isUser, super.key});

  /// The text content of the message.
  final String text;

  /// A boolean indicating whether the message was sent by the user.
  /// If `true`, the message is styled as a user message; otherwise, it's a bot message.
  final bool isUser;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      // if (!isUser)
      //   const CircleAvatar(
      //     backgroundColor: AppColors.kED7D2D,
      //     child: Text('C', style: TextStyle(color: Colors.white)),
      //   ),
      // if (!isUser) SizedBox(width: 8.w),
      Flexible(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          margin: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: isUser
                ? AppColors.k46A0F1
                : AppColors.kEDF6FE.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              bottomRight: isUser ? Radius.zero : const Radius.circular(24).r,
              bottomLeft: !isUser ? Radius.zero : const Radius.circular(24).r,
              topLeft: const Radius.circular(24).r,
              topRight: const Radius.circular(24).r,
            ),
            border: isUser ? Border.all(color: AppColors.k46A0F1) : null,
          ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isUser
                    ? Text(
                        text,
                        style: AppTextStyle.lato(color: AppColors.kFFFFFF),
                      )
                    : MarkdownBody(
                        data: text,
                        styleSheet: MarkdownStyleSheet(
                          p: AppTextStyle.lato(),
                          strong: AppTextStyle.lato(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                if (!isUser) ...<Widget>[
                  Divider(color: AppColors.k46A0F1.withOpacity(0.2)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: text));
                          if (!Get.isSnackbarOpen) {
                            appSnackBar(
                              message: 'Copied!',
                              type: SnackBarType.top,
                              state: SnackBarState.success,
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.kFFFFFF,
                          radius: 12.dg,
                          child: Icon(
                            Icons.copy_outlined,
                            size: 14.sp,
                            color: AppColors.k46A0F1,
                          ),
                        ),
                      ),
                      // 12.horizontalSpace,
                      // InkWell(
                      //   onTap: () {
                      //     Clipboard.setData(ClipboardData(text: text));
                      //     if (!Get.isSnackbarOpen) {
                      //       appSnackBar(
                      //         message: 'Liked!',
                      //         type: SnackBarType.top,
                      //         state: SnackBarState.success,
                      //       );
                      //     }
                      //   },
                      //   child: CircleAvatar(
                      //     backgroundColor: AppColors.kFFFFFF,
                      //     radius: 12.dg,
                      //     child: Icon(
                      //       Icons.thumb_up_alt_outlined,
                      //       size: 14.sp,
                      //       color: AppColors.k46A0F1,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
