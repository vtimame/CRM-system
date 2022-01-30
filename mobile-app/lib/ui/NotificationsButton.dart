import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class NotificationsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.push(context, AppRouter.notificationsScreen),
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Stack(
          children: <Widget>[
            Icon(
              Feather.bell,
              size: 20,
              color: AppRouter.currentRoute == AppRouter.notificationsScreen
                  ? Colors.blue[600]
                  : Colors.black87,
            ),
            StreamBuilder(
              stream: sl<NotificationsBloc>().notificationsListStream,
              builder: (context, list) {
                if (list.connectionState == ConnectionState.waiting ||
                    list.data == null) {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                } else {
                  var notRead = list.data.where((el) => el['read_at'] == null);

                  if (notRead.length > 0) {
                    return Positioned(
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                      ),
                    );
                  } else
                    return Container(
                      width: 0,
                      height: 0,
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
