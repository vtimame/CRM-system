import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/utils/AppRouter.dart';

class ApplicationBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () => AppRouter.push(context, AppRouter.boardScreen),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Icon(
                FontAwesome.columns,
                color: AppRouter.currentRoute == AppRouter.boardScreen
                    ? Colors.blue[700]
                    : Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => AppRouter.push(context, AppRouter.tasksScreen),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Icon(
                Feather.activity,
                color: AppRouter.currentRoute == AppRouter.tasksScreen
                    ? Colors.blue[700]
                    : Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Icon(Feather.message_circle, color: Colors.black26),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Icon(Feather.grid, color: Colors.black26),
            ),
          ),
          GestureDetector(
            onTap: () => AppRouter.push(context, AppRouter.userScreen),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Icon(
                Feather.user,
                color: AppRouter.currentRoute == AppRouter.userScreen
                    ? Colors.blue[700]
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]))),
    );
  }
}
