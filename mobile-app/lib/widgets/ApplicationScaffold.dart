import 'package:flutter/material.dart';

class ApplicationScaffold extends StatefulWidget {
  final Widget appBar;
  final Widget body;
  final Widget bottomNavigationBar;
  final Color backgroundColor;

  ApplicationScaffold(
      {Key key,
      this.appBar,
      this.body,
      this.bottomNavigationBar,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  _ApplicationScaffoldState createState() => _ApplicationScaffoldState();
}

class _ApplicationScaffoldState extends State<ApplicationScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.body,
    );
  }
}
