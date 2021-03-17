import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libdsm/libdsm.dart';
import 'package:flutter_smb_photo/LoginView.dart';
import 'package:flutter_smb_photo/smb.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box<String> box;

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox<String>('database');
  runApp(new MaterialApp(
    title: "routes",
    routes: <String, WidgetBuilder>{
      '/': (_) => new MyApp(),
    },
  ));
}

const String dnsNotFound = "Not Found";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Dsm dsm = Dsm();
  Future<String> address;
  Future<String> dns;

  void _create() async {
    await dsm.init();
  }

  void _release() async {
    await dsm.release();
  }

  void _startDiscovery() async {
    dsm.onDiscoveryChanged.listen(_discoveryListener);
    await dsm.startDiscovery();
  }

  void _discoveryListener(String json) async {
    debugPrint('Dis	covery : $json');
  }

  void _stopDiscovery() async {
    dsm.onDiscoveryChanged.listen(null);
    await dsm.stopDiscovery();
  }

  void _resolve() async {
    String name = 'biezhihua';
    await dsm.resolve(name);
  }

  Future<String> _inverse(String address) async {
    box.put('address', address);
    return dsm.inverse(address);
  }

  void _login() async {
    await dsm.login("BIEZHIHUA-PC", "test", "test");
  }

  void _logout() async {
    await dsm.logout();
  }

  void _getShareList() async {
    await dsm.getShareList();
  }

  int tid = 0;

  void _treeConnect() async {
    tid = await dsm.treeConnect("F");
  }

  void _treeDisconnect() async {
    int result = await dsm.treeDisconnect(tid);
    tid = 0;
  }

  void _find() async {
    String result = await dsm.find(tid, "\\*");

    result = await dsm.find(tid, "\\splayer\\splayer_soundtouch\\*");
  }

  void _fileStatus() async {
    String result =
    await dsm.fileStatus(tid, "\\splayer\\splayer_soundtouch\\Test.cpp");
  }

  String _text = "";

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  String _dns = "";
  bool _isLoading = false;
  bool _existDns = false;

  void _inverseText(String e) async{
    _create();
    setState(() {
      _isLoading = true;
      dns = _inverse(e);
      dns.then((value) {
        print("_dns is " + value);
        if(value.isEmpty) {
          _dns = dnsNotFound;
          _existDns = false;
        } else {
          _dns = value;
          _existDns = true;
        }
        box.put('dns', _dns);
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter SMB Photo'),
        ),
        body: Column(
          // <Widget> is the type of items in the list.
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
            Text(
              "$_text",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500
              ),
            ),
            TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines:1 ,
              //パスワード
              onChanged: _handleText,
              onEditingComplete: (){
                _inverseText(_text);
              },
            ),
            Visibility(
                visible: _existDns,
                child: ElevatedButton(onPressed: () => {
                  Navigator.push(
                  context,
                      MaterialPageRoute(builder: (context)=>LoginView(),)
                  )
                }, child: Text(_dns))
            ),
            Visibility(
                visible: _existDns,
                child: ElevatedButton(onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Smb(),)
                  )
                }, child: Text("Check! $_dns"))
            )
          ],
        ),
      ),
    );
  }
}