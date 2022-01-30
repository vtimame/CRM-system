import 'package:flutter/material.dart';
import 'package:oycrm/ui/NotificationsButton.dart';

class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool notifications;
  final double height;

  ApplicationBar(
      {this.title = 'Неизвестный экран',
      this.notifications = true,
      this.height = 75.0});

  Size get preferredSize {
    return new Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> barWidgets = [
      Text(
        title,
        style: TextStyle(
            color: Colors.black87, fontFamily: 'TTcommonsBold', fontSize: 20.0),
      )
    ];

    if (notifications) {
      barWidgets.add(NotificationsButton());
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: barWidgets,
            ),
          )),
    );
  }
}
