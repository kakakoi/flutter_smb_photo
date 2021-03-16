import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key, this.title}) : super(key: key);
  static const String routeName = "/LoginView";
  final String title;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FirstPage'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(onPressed: () => {}, child: Text('Nextページへ'),
            )
          ],
        ),
    );
  }
}