import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sikshana/app/utils/exports.dart';

class ProfileImageCircle extends StatelessWidget {
  const ProfileImageCircle({
    required this.userInitials,
    super.key,
    this.imagePath,
    this.backgroundColor,
    this.icon,
    this.radius,
    this.canEdit = false,
    this.onTapEdit,
  });

  final String? imagePath;
  final String userInitials;
  final Color? backgroundColor;
  final IconData? icon;
  final double? radius;
  final bool canEdit;
  final VoidCallback? onTapEdit;

  @override
  Widget build(BuildContext context) {
    final double circleRadius = radius ?? 23.r;
    final Widget profileCircle = Container(
      height: circleRadius * 2,
      width: circleRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.k46A0F1,
        image: imagePath != null && !(imagePath?.trim().isEmpty ?? true)
            ? DecorationImage(
                image: imagePath!.startsWith('http')
                    ? CachedNetworkImageProvider(imagePath!)
                    : FileImage(File(imagePath!)) as ImageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imagePath == null || (imagePath?.trim().isEmpty ?? true)
          ? Center(
              child: icon != null
                  ? Icon(
                      icon,
                      size: circleRadius * 0.8,
                      color: AppColors.kFFFFFF,
                    )
                  : Text(
                      userInitials,
                      style: AppTextStyle.lato(
                        color: AppColors.kFFFFFF,
                        fontSize: circleRadius * 0.7,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            )
          : const SizedBox(),
    );

    if (!canEdit) {
      return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'logout') {
            DialogManager.showLogoutDialog(
              onPositiveClick: UserProvider.onLogout,
            );
          }
        },
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(4.r),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'logout',
            height: 30.dg,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(LocaleKeys.logout.tr, style: AppTextStyle.lato()),
                8.horizontalSpace,
                Icon(
                  Icons.logout_rounded,
                  color: AppColors.k46A0F1,
                  size: 18.dg,
                ),
              ],
            ),
          ),
        ],
        child: profileCircle,
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        profileCircle,
        GestureDetector(
          onTap: onTapEdit,
          child: Container(
            padding: EdgeInsets.all(circleRadius * 0.16),
            decoration: BoxDecoration(
              color: AppColors.k46A0F1,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: circleRadius * 0.32,
            ),
          ),
        ),
      ],
    );
  }
}
