import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oycrm/bloc/LoginScreen/LoginCredentialsBloc.dart';
import 'package:oycrm/bloc/LoginScreen/LoginModeBloc.dart';
import 'package:oycrm/ui/Button.dart';
import 'package:oycrm/ui/Input.dart';
import 'package:oycrm/utils/ServiceLocator.dart';

class SwitchLoginMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginModeBloc loginModeBloc = sl<LoginModeBloc>();

    return StreamBuilder(
      stream: loginModeBloc.loginModeStream,
      builder: (context, mode) {
        Widget renderWidget = renderSwitchWidgets(loginModeBloc);

        if (mode.connectionState == ConnectionState.waiting ||
            mode.data == null) {
          renderWidget = renderSwitchWidgets(loginModeBloc);
        } else {
          switch (mode.data) {
            case "sms":
            default:
              renderWidget = renderSmsWidgets(context);
              break;
          }
        }

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(
            child: child,
            scale: animation,
          ),
          child: renderWidget,
        );
      },
    );
  }

  Widget renderSmsWidgets(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final LoginCredentialsBloc loginCredentialsBloc =
        sl<LoginCredentialsBloc>();

    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: loginCredentialsBloc.loginCredentialsStream,
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting ||
                state == null ||
                !state.data['mobilePhoneIsChecked']) {
              return Input(
                  hint: 'Номер телефона',
                  type: TextInputType.number,
                  onChanged: (value) {
                    loginCredentialsBloc.setField('mobile_phone', value);
                    passwordController.text = '';
                  });
            } else {
              return Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 14.0, right: 10.0, top: 12.0, bottom: 12.0),
                        child: Icon(Feather.arrow_left),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.0),
                              bottomLeft: Radius.circular(3.0))),
                    ),
                    onTap: () => loginCredentialsBloc.setField(
                        'mobilePhoneIsChecked', false),
                  ),
                  Expanded(
                    flex: 1,
                    child: Input(
                      hint: 'Пин-код',
                      controller: passwordController,
                      type: TextInputType.number,
                      obscure: true,
                      onChanged: (value) =>
                          loginCredentialsBloc.setField('password', value),
                    ),
                  )
                ],
              );
            }
          },
        ),
        Button(
          text: 'Продолжить',
          onPressed: () => loginCredentialsBloc.onFormSubmit(),
        )
      ],
    );
  }

  Widget renderSwitchWidgets(LoginModeBloc loginModeBloc) {
    return Column(
      children: [
        Button(
          text: 'Войти с помощью SMS сообщения',
          onPressed: () => loginModeBloc.loginModeSink.add('sms'),
        )
      ],
    );
  }
}
