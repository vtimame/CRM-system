import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';
import 'package:oycrm/bloc/BoardScreen/OpenedCardScreen/EventsBloc.dart';
import 'package:oycrm/bloc/CommentBloc.dart';
import 'package:oycrm/bloc/UsersBloc.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/utils/TipTap.dart';

class Comment extends StatelessWidget {
  final Map comment;
  Comment({this.comment});

  @override
  Widget build(BuildContext context) {
    Map user = sl<UsersBloc>().userInstance(comment['user_id']);
    List children = comment['children'];
    List<Widget> childViews = [];
    if (children != null && children.length > 0) {
      children.forEach((el) {
        childViews.add(Comment(
          comment: el,
        ));
      });
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        UserAvatar(userId: comment['user_id']),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${user['surname']} ${user['name']}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    child: comment['json_message'] != null
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TipTap.parse(
                                comment['json_message']['content']),
                          )
                        : Html(
                            data: _getHtmlDocument(),
                            style: {
                              "p": Style(margin: EdgeInsets.all(0)),
                            },
                          )),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Text(comment['created_at']),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => _addAnswer(),
                    child: Text(
                      'Ответить',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childViews,
              )
            ],
          ),
        )
      ],
    );
  }

  String _getHtmlDocument() {
    var document = parse(comment['message']);
    document.getElementsByClassName('mention').forEach((el) {
      Map mentionUser =
          sl<UsersBloc>().userInstance(el.attributes['data-mention-id']);
      el.nodes[0].remove();
      el.nodes.insert(
          0,
          parseFragment(
              '<span><strong>@${mentionUser['surname']}</strong><strong>${mentionUser['name']}</strong></span>'));
    });

    return document.outerHtml;
  }

  void _addAnswer() {
    Map parent = comment;
    if (comment['parent_id'] != null) {
      parent = sl<EventsBloc>().eventInstance(comment['parent_id']);
    }

    sl<CommentBloc>().typeSink.add('answer');
    sl<CommentBloc>().parentIdSink.add(parent['_id']);
  }
}
