import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardBloc.dart';
import 'package:oycrm/ui/SmallInput.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/BoardScreen/OpenedCardScreen/NewManagerProfile/RawProfileData.dart';

class NewManagerProfile extends StatefulWidget {
  final profile;
  final bool disabled;

  NewManagerProfile({Key key, this.profile, this.disabled}) : super(key: key);

  @override
  _NewManagerProfileState createState() => _NewManagerProfileState();
}

class _NewManagerProfileState extends State<NewManagerProfile> {
  final OpenedCardBloc openedCardBloc = sl<OpenedCardBloc>();

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Анкета менеджера (Комментарии)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WI-FI (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                    widget.profile['wifi']['comment'] ?? 'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['wifi']['scoutComment'],
              onChange: (value) => _updateScoutComment('wifi', value),
            ),
          ),
          Text(
            "Интернет (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                    widget.profile['internet']['comment'] ?? 'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['internet']['scoutComment'],
              onChange: (value) => _updateScoutComment('internet', value),
            ),
          ),
          Text(
            "Локальная сеть (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(widget.profile['localNetwork']['comment'] ??
                    'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['localNetwork']['scoutComment'],
              onChange: (value) => _updateScoutComment('localNetwork', value),
            ),
          ),
          Text(
            "Телефония (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child:
                    Text(widget.profile['pbx']['comment'] ?? 'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['pbx']['scoutComment'],
              onChange: (value) => _updateScoutComment('pbx', value),
            ),
          ),
          Text(
            "Аутсорсинг (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(widget.profile['outsourcing']['comment'] ??
                    'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['outsourcing']['scoutComment'],
              onChange: (value) => _updateScoutComment('outsourcing', value),
            ),
          ),
          Text(
            "Видеонаблюдение (Бизнес задача)",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blueGrey[50]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                    widget.profile['cctv']['comment'] ?? 'Без комментария'),
              ),
            ),
          ),
          Text("Комментарий разведчика"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: SmallInput(
              maxLines: 3,
              value: widget.profile['cctv']['scoutComment'],
              onChange: (value) => _updateScoutComment('cctv', value),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _updateScoutComment(String property, String value) async {
    Map profile = widget.profile;
    profile[property]['scoutComment'] = value;
    await openedCardBloc.update('newManagerProfile', profile);
  }

  // Future setProperty(String property, dynamic value) async {
  //   Map profile = widget.profile;
  //   profile[property] = value;
  //   await openedCardBloc.update('newManagerProfile', profile);
  // }
}
