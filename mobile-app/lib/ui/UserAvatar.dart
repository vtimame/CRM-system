import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

import '../config.dart';

class UserAvatar extends StatelessWidget {
  final String userId;
  final double radius;
  final Color borderColor;

  UserAvatar(
      {this.userId, this.radius = 38.0, this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    final user = sl<UsersBloc>().userInstance(userId);
    final String avatarUrl =
        '${Config.baseUrl}avatars/${user['alias']}${radius > 38.0 ? '/' : '/thumbnails/w_64_'}${user['avatar_name']}';
    final Widget placeholder = CircleAvatar(
      radius: 20,
      backgroundColor: Colors.red[100],
      child: Text('${user['surname'][0]}${user['name'][0]}'),
    );

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(100))),
      width: radius,
      height: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
        ),
      ),
    );
  }
}
