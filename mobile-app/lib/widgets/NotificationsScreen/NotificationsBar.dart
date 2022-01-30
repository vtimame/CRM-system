import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:oycrm/bloc/NotificationsBloc.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class NotificationsBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize {
    return new Size.fromHeight(86.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Padding(
          padding: EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Уведомления',
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'TTcommonsBold',
                          fontSize: 20.0),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Только новые'),
                        SizedBox(width: 8.0),
                        SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: StreamBuilder(
                            stream: sl<NotificationsBloc>().onlyNewStream,
                            builder: (context, state) {
                              if (state.connectionState ==
                                      ConnectionState.active &&
                                  state.data != null) {
                                return Checkbox(
                                    value: state.data,
                                    onChanged: (value) =>
                                        sl<NotificationsBloc>()
                                            .setOnlyNewState(value));
                              } else
                                return Container();
                            },
                          ),
                        )
                      ],
                    )
                  ],
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
                    isScrollable: false,
                    tabs: <Tab>[
                      Tab(
                        text: 'Мои',
                      ),
                      Tab(
                        text: 'Личные',
                      ),
                      Tab(
                        text: 'Все',
                      )
                    ],
                  ),
                ),
//                Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Text("Прочитать все"),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        Text('Только новые'),
//                        Checkbox(
//                          value: false,
//                        )
//                      ],
//                    )
//                  ],
//                )
              ],
            ),
          )),
    );
  }

  _setOnlyNewState(bool state) {
    sl<NotificationsBloc>().setOnlyNewState(state);
  }
}
