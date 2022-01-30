import 'package:flutter/material.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class TipTap {
  static Widget parse(List content) {
    List<Widget> document = [];
    content.forEach((row) {
      List rowContent = row['content'];
      if (rowContent != null) {
        List<Widget> rowWidgets = [];

        rowContent.forEach((item) {
          switch (item['type']) {
            case 'text':
              FontWeight fontWeight = FontWeight.w500;
              FontStyle fontStyle = FontStyle.normal;
              TextDecoration decoration = TextDecoration.none;

              if (item['marks'] != null) {
                item['marks'].forEach((markType) {
                  switch (markType['type']) {
                    case 'bold':
                      fontWeight = FontWeight.w600;
                      break;
                    case 'italic':
                      fontStyle = FontStyle.italic;
                      break;
                    case 'underline':
                      decoration = TextDecoration.underline;
                      break;
                    default:
                      break;
                  }
                });
              }

              if (item['text'] != null) {
                rowWidgets.add(Text(
                  item['text'],
                  style: TextStyle(
                      fontWeight: fontWeight,
                      fontStyle: fontStyle,
                      decoration: decoration),
                ));
              }

              rowWidgets.add(SizedBox(width: 3.0));

              break;
            case 'mention':
              Map mentionUser =
                  sl<UsersBloc>().userInstance(item['attrs']['id']);
              if (mentionUser != null) {
                rowWidgets.add(Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    UserAvatar(
                      userId: mentionUser['_id'],
                      radius: 28,
                    ),
                    Text(
                      '${mentionUser['surname']} ${mentionUser['name']}',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    )
                  ],
                ));
                rowWidgets.add(SizedBox(width: 3.0));
              }
              break;
            default:
              rowWidgets.add(Container());
              break;
          }
        });

        document.add(Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: rowWidgets,
        ));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: document,
    );
  }

  static Map buildJsonMessage(String message) {
    List<String> lines = message.split('\n');
    List<Map> paragraphs = [];
    lines.forEach((line) {
      List<String> items = line.split(' ');
      List<Map> paragraphItems = [];
      items.forEach((item) {
        if (item.startsWith('@')) {
          Map user = sl<UsersBloc>().userInstanceByAlias(item.substring(1));
          if (user != null) {
            paragraphItems.add({
              "type": "mention",
              "attrs": {"id": user['_id'], "label": user['alias']}
            });
          }
        } else {
          paragraphItems
              .add({"type": "text", "text": item.length > 0 ? item : null});
        }
      });
      paragraphs.add({"type": "paragraph", "content": paragraphItems});
    });

    print(paragraphs);

    return {"type": "doc", "content": paragraphs};
  }
}
