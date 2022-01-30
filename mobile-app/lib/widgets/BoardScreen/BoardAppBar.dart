import 'dart:collection';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/BoardScreen/BoardsBloc.dart';
import 'package:oycrm/bloc/BoardScreen/CardsBloc.dart';
import 'package:oycrm/ui/NotificationsButton.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class BoardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List columns;
  BoardAppBar({Key key, this.columns}) : super(key: key);

  Size get preferredSize {
    return new Size.fromHeight(88.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _showBoardSheet(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: sl<BoardsBloc>().currentBoardStream,
                          builder: (context, instance) {
                            String boardName = 'Загрузка...';

                            if (instance.connectionState ==
                                    ConnectionState.active &&
                                instance.data != null) {
                              boardName = instance.data['name'];
                            }

                            return Text(
                              boardName,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'TTcommonsBold',
                                  fontSize: 18.0),
                            );
                          },
                        ),
                        Icon(
                          Feather.chevron_down,
                          color: Colors.black87,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _showFilterSheet(context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Фильтр',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'TTcommonsBold',
                                  fontSize: 18.0),
                            ),
                            Icon(
                              Feather.chevron_down,
                              color: Colors.black87,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      NotificationsButton()
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TabBar(
              labelColor: Colors.blue[600],
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: Colors.blue[100],
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              isScrollable: true,
              tabs: columns,
            ),
          )
        ],
      ),
    );
  }

  void _showBoardSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              width: double.infinity,
              child: StreamBuilder(
                stream: sl<BoardsBloc>().boardsListStream,
                builder: (context, list) {
                  if (list.connectionState == ConnectionState.waiting ||
                      list.data == null) {
                    return LinearProgressIndicator();
                  }

                  List<Widget> boardList = [];
                  list.data.forEach((el) => boardList.add(ListTile(
                        title: Text(el['name']),
                        onTap: () {
                          sl<BoardsBloc>().setCurrentBoard(el);
                          Navigator.pop(context);
                        },
                      )));

                  return Wrap(children: boardList);
                },
              ),
            ),
          );
        });
  }

  void _showFilterSheet(context) {
    final CardsBloc cardsBloc = sl<CardsBloc>();
    cardsBloc.unsetFilter();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.blueGrey[50]))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                'Фильтр по создателям',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          StreamBuilder(
                            stream: cardsBloc.cardsListStream,
                            builder: (context, list) {
                              if (list.connectionState ==
                                      ConnectionState.active &&
                                  list != null) {
                                List<dynamic> creators =
                                    _getCreators(list.data).toSet().toList();

                                List<Widget> creatorsWidgets = [];
                                creators.forEach((el) =>
                                    creatorsWidgets.add(Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          cardsBloc.filterCardsByCreatorId(el);
                                          Navigator.pop(context);
                                        },
                                        child: UserAvatar(
                                          userId: el,
                                          borderColor: Colors.transparent,
                                        ),
                                      ),
                                    )));

                                if (creators.length > 0) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: creatorsWidgets,
                                        ),
                                      ));
                                } else {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Text(
                                          'Похоже здесь нет ни одной карточки'));
                                }
                              } else {
                                return LinearProgressIndicator();
                              }
                            },
                          )
                        ],
                      )),
                )
              ],
            ),
          );
        });
  }

  List<dynamic> _getCreators(List<dynamic> cards) {
    List cardsWithCreators =
        cards.where((el) => el['creator_id'] != null).toList();
    List<dynamic> creators =
        cardsWithCreators.map((el) => el['creator_id']).toList();
    return LinkedHashSet<dynamic>.from(creators).toList();
  }
}
