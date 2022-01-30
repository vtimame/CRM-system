import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/AddContactScreen.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/Contact.dart';

class Contacts extends StatefulWidget {
  final List contacts;
  Contacts({Key key, this.contacts}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    List<Widget> contactsViews = [];
    widget.contacts.asMap().forEach((index, el) => contactsViews.add(Contact(
          contact: el,
          contactsLength: widget.contacts.length,
          index: index,
        )));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Контакты',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 9.0),
                child: Icon(Feather.user_plus, size: 18.0),
              ),
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => AddContactScreen())),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          child: Wrap(
            children: contactsViews,
          ),
        )
      ],
    );
  }
}
