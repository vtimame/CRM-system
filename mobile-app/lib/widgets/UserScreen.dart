import 'package:flutter/material.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/ui/ApplicationBar.dart';
import 'package:oycrm/ui/ApplicationBottomBar.dart';
import 'package:oycrm/ui/LoadingScreen.dart';
import 'package:oycrm/ui/UserAvatar.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userBloc = sl<UserBloc>();

    return WillPopScope(
      onWillPop: () => AppRouter.pop(context),
      child: StreamBuilder(
        stream: userBloc.userStream,
        builder: (context, user) {
          if (user.connectionState == ConnectionState.active &&
              user.data != null) {
            return Container(
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  appBar: ApplicationBar(
                    title: user.data['alias'],
                  ),
                  bottomNavigationBar: ApplicationBottomBar(),
                  body: Padding(
                    padding:
                        EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  UserAvatar(
                                    userId: user.data['_id'],
                                    radius: 85,
                                  ),
                                  SizedBox(width: 8.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${user.data['surname']} ${user.data['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text('${user.data['email']}'),
                                      Text('${user.data['role']['name']}'),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              userBloc.logout();
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRouter.loginScreen, (route) => false);
                            },
                            color: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.red[100],
                            elevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            hoverElevation: 0,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Выйти',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return LoadingScreen();
        },
      ),
    );
  }
}
