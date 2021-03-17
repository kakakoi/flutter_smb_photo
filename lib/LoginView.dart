import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libdsm/libdsm.dart';

Box<String> box;
String _dns = "";
String _user = "";
String _pass = "";

class LoginView extends StatefulWidget {
  LoginView({Key key, this.title}) : super(key: key);
  static const String routeName = "/LoginView";
  final String title;

  @override
  _LoginViewState createState() {
    init();
    return _LoginViewState();
  }

  void init() async{
    box = await Hive.openBox<String>('database');
    _dns = box.get("dns") ?? "not found";
    print(routeName + ":_dns is " + _dns);
  }
}

class _LoginViewState extends State<LoginView> {
  Dsm dsm = Dsm();

  String _userText = "";

  void _handleUserText(String e) {
    setState(() {
      _userText = e;
    });
  }

  void _putUserText(String e) async{
    setState(() {
      _user = e;
    });
  }

  String _passText = "";

  void _handlePassText(String e) async{
    setState(() {
      _passText = e;
    });
  }

  int _result = 0;
  void _putPassText(String e) async{
    print("_putPassText:" + e);
    box.put('user', _user);
    box.put('pass', e);
    _isLoading = true;
    setState(() {
      _pass = e;
    });
    print("_putPassText login($_dns,$_user,$e)");
    await dsm.init();
    Future<int> result = dsm.login(_dns, _user, e);
    result.then((value) {
      _result = value;
      _isLoading = false;
      print("login result is " + _result.toString());

      _treeConnect();
      _startDiscovery();
      dsm.getShareList().then((value) => print("getShareList: $value"));
//      dsm.find(tid, "\\*").then((value) => print("dsm.find : "+value.length.toString()));
    });
  }

  int tid = 0;

  void _treeConnect() async {
    tid = await dsm.treeConnect("F");
  }

  void _startDiscovery() async {
    dsm.onDiscoveryChanged.listen(_discoveryListener);
    await dsm.startDiscovery();
  }

  void _discoveryListener(String json) async {
    debugPrint('Dis	covery : $json');
  }

  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_dns),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Visibility(
              visible: _isLoading,
              child: LinearProgressIndicator(),
            ),
            Text(
              "$_dns",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "User:"
              ),
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines:1 ,
              onChanged: _handleUserText,
              onEditingComplete:  (){
                _putUserText(_userText);
              },
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Pass:"
              ),
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines:1 ,
              //パスワード
              onChanged: _handlePassText,
              onEditingComplete: (){
                _putPassText(_passText);
              },
            ),
          ],
        ),
    );
  }
}