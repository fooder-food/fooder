import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_notification/model/user_model.dart';

Widget fooderAvatar({
 User? user,
}) {
  if(user == null || user.avatar.isEmpty) {
    return ClipOval(
      child: SvgPicture.asset(
        'assets/img/guest-avatar.svg'
      )
    );
  } else {
    if (user.avatar.isNotEmpty) {
      if (user.avatarType.isNotEmpty && user.avatarType.contains('svg')) {
        return ClipOval(
          child: SvgPicture.network(
            user.avatar,
          ),
        );
      }
    }
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: user.avatar,
      imageBuilder: (ctx, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) =>
      const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
    );
  }


}