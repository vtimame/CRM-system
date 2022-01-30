import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  final Map contact;
  final int contactsLength;
  final int index;

  Contact({Key key, this.contact, this.contactsLength, this.index})
      : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  bool showAllNumbers = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: new InkWell(
        onTap: () => setState(() => showAllNumbers = !showAllNumbers),
        child: new Container(
          width: double.infinity,
          decoration: _decoration(),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[_contactName(), _numbers()],
            ),
          ),
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget _numbers() {
    List phones = widget.contact['phones'];
    var iterablePhones = showAllNumbers ? phones : phones.take(1);
    List<Widget> numbersViews = [];
    iterablePhones.forEach((el) {
      numbersViews.add(GestureDetector(
        onTap: () => launch('tel://+7${el['phone']}'),
        child: Text(
            '${Utils.decoratePhoneNumber(el['phone'])}${el['additional'] != null ? ', Доб.: ${el['additional']}' : ''}'),
      ));
    });

    if (phones.length > 1 && !showAllNumbers) {
      numbersViews.add(Icon(
        Feather.more_horizontal,
        size: 18,
        color: Colors.blueGrey[700],
      ));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.end, children: numbersViews);
  }

  Widget _contactName() {
    String surname = widget.contact['surname'] ?? '';
    String name = widget.contact['name'] ?? '';
    String patronymic = widget.contact['patronymic'] ?? '';

    return Text(
      '$surname $name $patronymic',
      style: TextStyle(
          fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.green),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: widget.index == widget.contactsLength - 1
                    ? Colors.blueGrey[50]
                    : Colors.blueGrey[100])));
  }
}
