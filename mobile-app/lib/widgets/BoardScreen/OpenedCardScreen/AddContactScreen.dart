import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/AddContactBloc.dart';
import 'package:oycrm/ui/ApplicationBar.dart';
import 'package:oycrm/ui/Button.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final AddContactBloc _addContactBloc = sl<AddContactBloc>();

  @override
  void initState() {
    _addContactBloc.contactSink.add({
      "surname": "",
      "name": "",
      "patronymic": "",
      "position": "",
      "email": "",
    });

    _addContactBloc.phonesSink.add([
      {"phone": "", "additional": ""}
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: ApplicationBar(
            title: 'Добавить контакт',
            notifications: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Фамилия'),
                  SizedBox(
                    height: 4.0,
                  ),
                  _ContactField(
                    onChanged: (value) =>
                        _addContactBloc.updateContactField('surname', value),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Имя'),
                  SizedBox(
                    height: 4.0,
                  ),
                  _ContactField(
                    onChanged: (value) =>
                        _addContactBloc.updateContactField('name', value),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Отчество'),
                  SizedBox(
                    height: 4.0,
                  ),
                  _ContactField(
                    onChanged: (value) =>
                        _addContactBloc.updateContactField('patronymic', value),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  _renderPhones(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Button(
                    text: 'Добавить еще один номер телефона',
                    color: 'blue',
                    onPressed: () => _addContactBloc.addPhone(),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Должность'),
                  SizedBox(
                    height: 4.0,
                  ),
                  _ContactField(
                    onChanged: (value) =>
                        _addContactBloc.updateContactField('position', value),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Email'),
                  SizedBox(
                    height: 4.0,
                  ),
                  _ContactField(
                    onChanged: (value) =>
                        _addContactBloc.updateContactField('email', value),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  StreamBuilder(
                    stream: _addContactBloc.contactIsValidStream,
                    builder: (context, isValid) {
                      if (isValid.connectionState == ConnectionState.active &&
                          isValid.data == true) {
                        return Button(
                          text: 'Сохранить',
                          onPressed: () {
                            _addContactBloc.store();
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        return Button(
                          text: 'Сохранить',
                          onPressed: null,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderPhones() {
    return StreamBuilder(
      stream: _addContactBloc.phonesStream,
      builder: (context, list) {
        if (list.connectionState == ConnectionState.active &&
            list.data != null) {
          List<Widget> phonesWidgets = [];
          list.data.asMap().forEach((index, el) {
            List<Widget> phoneWidgets = [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Номер телефона'),
                    SizedBox(height: 4.0),
                    _ContactField(
                      numbers: true,
                      onChanged: (value) => _addContactBloc.updatePhoneField(
                          index, 'phone', value),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Доб.'),
                    SizedBox(height: 4.0),
                    _ContactField(
                      numbers: true,
                      onChanged: (value) => _addContactBloc.updatePhoneField(
                          index, 'additional', value),
                    )
                  ],
                ),
              ),
            ];

            if (list.data.length > 1) {
              phoneWidgets.add(SizedBox(
                width: 8.0,
              ));

              phoneWidgets.add(Padding(
                padding: EdgeInsets.only(top: 23.0),
                child: GestureDetector(
                  onTap: () => _addContactBloc.removePhone(index),
                  child: Icon(
                    Feather.trash,
                    size: 18,
                  ),
                ),
              ));
            }

            phonesWidgets.add(Row(
              children: phoneWidgets,
            ));
          });
          return Column(
            children: phonesWidgets,
          );
        } else
          return Container();
      },
    );
  }
}

class _ContactField extends StatelessWidget {
  final Function onChanged;
  final bool numbers;

  _ContactField({this.onChanged, this.numbers = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: numbers ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[100])),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue[300])),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[100])),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      ),
    );
  }
}
