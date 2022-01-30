import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logotype extends StatelessWidget {
  final double width;
  Logotype({Key key, this.width = 150.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'lib/assets/images/logo.svg',
      width: width,
    );
  }
}
