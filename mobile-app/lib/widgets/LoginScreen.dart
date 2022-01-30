import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oycrm/bloc/ApplicationBloc.dart';
import 'package:oycrm/bloc/LoginScreen/LoginErrorBloc.dart';
import 'package:oycrm/bloc/LoginScreen/LoginModeBloc.dart';
import 'package:oycrm/bloc/UserBloc.dart';
import 'package:oycrm/ui/Button.dart';
import 'package:oycrm/ui/Logotype.dart';
import 'package:oycrm/utils/AppRouter.dart';
import 'package:oycrm/utils/ServiceLocator.dart';
import 'package:oycrm/widgets/LoginScreen/SwitchLoginMode.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginModeBloc loginModeBloc = sl<LoginModeBloc>();
    final LoginErrorBloc loginErrorBloc = sl<LoginErrorBloc>();
    final ApplicationBloc applicationBloc = sl<ApplicationBloc>();
    final UserBloc userBloc = sl<UserBloc>();

    applicationBloc.prepareApplication();

    userBloc.userStream.listen((user) {
      if (user != null) {
        AppRouter.pushReplacementNamed(context, AppRouter.boardScreen);
      }
    });

    return StreamBuilder(
      stream: applicationBloc.loadedStateStream,
      builder: (context, state) {
        if (state.connectionState == ConnectionState.waiting ||
            state.data == null ||
            state.data == false) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Logotype(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          SwitchLoginMode(),
                          StreamBuilder(
                            stream: loginErrorBloc.errorStream,
                            builder: (context, error) {
                              if (error.connectionState ==
                                      ConnectionState.active &&
                                  error.data != null) {
                                return Text(
                                  error.data,
                                  style: TextStyle(color: Colors.red[600]),
                                );
                              }

                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: loginModeBloc.loginModeStream,
                      builder: (context, mode) {
                        if (mode.connectionState == ConnectionState.waiting ||
                            mode.data == null) {
                          return Container();
                        } else {
                          return Button(
                            text: 'Назад',
                            onPressed: () =>
                                loginModeBloc.loginModeSink.add(null),
                            color: 'transparent',
                            textColor: Colors.black87,
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
