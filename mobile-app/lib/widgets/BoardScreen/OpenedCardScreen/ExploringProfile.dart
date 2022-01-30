import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/ui/SmallInput.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class ExploringProfile extends StatefulWidget {
  final profile;
  final bool disabled;

  ExploringProfile({Key key, this.profile, this.disabled = false})
      : super(key: key);

  final List<DropdownMenuItem> roofTypes = [
    DropdownMenuItem(
      value: 'undefined',
      child: Text(
        'Не указано',
        style: TextStyle(fontSize: 13),
      ),
    ),
    DropdownMenuItem(
      value: 'slant',
      child: Text('Наклонная', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'flat',
      child: Text('Плоская', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'attic',
      child: Text('Мансарда', style: TextStyle(fontSize: 13)),
    ),
  ];

  final List<DropdownMenuItem> trackTypes = [
    DropdownMenuItem(
      value: 'undefined',
      child: Text(
        'Не указано',
        style: TextStyle(fontSize: 13),
      ),
    ),
    DropdownMenuItem(
      value: 'facade',
      child: Text('По фасаду', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'mortgages',
      child: Text('По закладным', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'staircase',
      child: Text('По лестничной клетке', style: TextStyle(fontSize: 13)),
    ),
  ];

  final List<DropdownMenuItem> entranceTypes = [
    DropdownMenuItem(
      value: 'undefined',
      child: Text(
        'Не указано',
        style: TextStyle(fontSize: 13),
      ),
    ),
    DropdownMenuItem(
      value: 'facade',
      child: Text('С фасада', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'yard',
      child: Text('Со двора', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'other',
      child: Text('Иное', style: TextStyle(fontSize: 13)),
    ),
  ];

  final List<DropdownMenuItem> windowTypes = [
    DropdownMenuItem(
      value: 'undefined',
      child: Text(
        'Не указано',
        style: TextStyle(fontSize: 13),
      ),
    ),
    DropdownMenuItem(
      value: 'facade',
      child: Text('На фасад', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'yard',
      child: Text('Во двор', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'other',
      child: Text('Иное', style: TextStyle(fontSize: 13)),
    ),
  ];

  final List<DropdownMenuItem> pointTypes = [
    DropdownMenuItem(
      value: 'undefined',
      child: Text(
        'Не указано',
        style: TextStyle(fontSize: 13),
      ),
    ),
    DropdownMenuItem(
      value: 'facade',
      child: Text('С фасада', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'yard',
      child: Text('Со двора', style: TextStyle(fontSize: 13)),
    ),
    DropdownMenuItem(
      value: 'other',
      child: Text('Иное', style: TextStyle(fontSize: 13)),
    ),
  ];

  @override
  _ExploringProfileState createState() => _ExploringProfileState();
}

class _ExploringProfileState extends State<ExploringProfile> {
  @override
  Widget build(BuildContext context) {
    Map profile;
    if (widget.profile == null) {
      profile = new Map();
    }
    if (widget.profile is List) {
      profile = widget.profile.asMap();
    } else {
      profile = Map<String, dynamic>.from(widget.profile);
    }
    final OpenedCardBloc openedCardBloc = sl<OpenedCardBloc>();

    return ExpandablePanel(
      header: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Разведка',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Управляющая компания'),
          SizedBox(height: 4.0),
          SmallInput(
              value: profile['YK'] ?? '',
              disabled: widget.disabled,
              onChange: (value) =>
                  openedCardBloc.update('exploring_profile.YK', value)),
          SizedBox(height: 4.0),
          Text('Как вести кабель по помещению'),
          SizedBox(height: 4.0),
          SmallInput(
            value: profile['how_to_lead'] ?? '',
            disabled: widget.disabled,
            onChange: (value) =>
                openedCardBloc.update('exploring_profile.how_to_lead', value),
          ),
          SizedBox(height: 4.0),
          Text('Как размещаем оборудование'),
          SizedBox(height: 4.0),
          SmallInput(
            value: profile['how_to_post'] ?? '',
            disabled: widget.disabled,
            onChange: (value) =>
                openedCardBloc.update('exploring_profile.how_to_post', value),
          ),
          SizedBox(height: 4.0),
          Text('Ограничения по времени работ'),
          SizedBox(height: 4.0),
          SmallInput(
            value: profile['time_limit'] ?? '',
            disabled: widget.disabled,
            onChange: (value) =>
                openedCardBloc.update('exploring_profile.time_limit', value),
          ),
          SizedBox(height: 4.0),
          Text('Крыша'),
          SizedBox(height: 4.0),
          SizedBox(
              width: double.infinity,
              child: DropdownButton(
                value: profile['roof'] ?? 'undefined',
                isExpanded: true,
                onChanged: widget.disabled
                    ? null
                    : (value) =>
                        openedCardBloc.update('exploring_profile.roof', value),
                items: widget.roofTypes,
              )),
          SizedBox(height: 4.0),
          Text('Трасса завода кабеля'),
          SizedBox(height: 4.0),
          SizedBox(
              width: double.infinity,
              child: DropdownButton(
                value: profile['track'] ?? 'undefined',
                isExpanded: true,
                onChanged: widget.disabled
                    ? null
                    : (value) =>
                        openedCardBloc.update('exploring_profile.track', value),
                items: widget.trackTypes,
              )),
          SizedBox(height: 4.0),
          Text('Вход в помещение'),
          SizedBox(height: 4.0),
          SizedBox(
              width: double.infinity,
              child: DropdownButton(
                value: profile['entrance'] ?? 'undefined',
                isExpanded: true,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.entrance', value),
                items: widget.entranceTypes,
              )),
          profile['entrance'] == 'other'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Text('Вход в помещение (иное)'),
                    SizedBox(height: 4.0),
                    SmallInput(
                      value: profile['entrance_other'] ?? '',
                      disabled: widget.disabled,
                      onChange: (value) => openedCardBloc.update(
                          'exploring_profile.entrance_other', value),
                    ),
                    SizedBox(height: 4.0),
                  ],
                )
              : Container(),
          SizedBox(height: 4.0),
          Text('Окна'),
          SizedBox(height: 4.0),
          SizedBox(
              width: double.infinity,
              child: DropdownButton(
                value: profile['window'] ?? 'undefined',
                isExpanded: true,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.window', value),
                items: widget.windowTypes,
              )),
          SizedBox(height: 4.0),
          profile['window'] == 'other'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Text('Окна (иное)'),
                    SizedBox(height: 4.0),
                    SmallInput(
                      value: profile['window_other'] ?? '',
                      disabled: widget.disabled,
                      onChange: (value) => openedCardBloc.update(
                          'exploring_profile.window_other', value),
                    ),
                    SizedBox(height: 4.0),
                  ],
                )
              : Container(),
          Text('Точка завода кабеля'),
          SizedBox(height: 4.0),
          SizedBox(
              width: double.infinity,
              child: DropdownButton(
                value: profile['point'] ?? 'undefined',
                isExpanded: true,
                onChanged: widget.disabled
                    ? null
                    : (value) =>
                        openedCardBloc.update('exploring_profile.point', value),
                items: widget.pointTypes,
              )),
          SizedBox(height: 4.0),
          profile['point'] == 'other'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 4.0),
                    Text('Точка завода кабеля (иное)'),
                    SizedBox(height: 4.0),
                    SmallInput(
                      value: profile['point_other'] ?? '',
                      disabled: widget.disabled,
                      onChange: (value) => openedCardBloc.update(
                          'exploring_profile.point_other', value),
                    ),
                    SizedBox(height: 4.0),
                  ],
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('220V в месте размещения'),
              Checkbox(
                value: profile['_220V'] ?? false,
                onChanged: widget.disabled
                    ? null
                    : (value) =>
                        openedCardBloc.update('exploring_profile._220V', value),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Требуется проект согласования'),
              Checkbox(
                value: profile['project_for_approval'] ?? false,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.project_for_approval', value),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Требуются списки работников'),
              Checkbox(
                value: profile['employee_lists'] ?? false,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.employee_lists', value),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Требуются гарантийные письма'),
              Checkbox(
                value: profile['guarantee_letters'] ?? false,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.guarantee_letters', value),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('План помещения'),
              Checkbox(
                value: profile['room_plan'] ?? false,
                onChanged: widget.disabled
                    ? null
                    : (value) => openedCardBloc.update(
                        'exploring_profile.room_plan', value),
              )
            ],
          )
        ],
      ),
    );
  }
}
