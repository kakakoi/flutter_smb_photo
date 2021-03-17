import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libdsm/libdsm.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() => runApp(Smb());

Box<String> box;
String _address = "";
String _dns = "";
String _user = "";
String _pass = "";

class Smb extends StatefulWidget {
  @override
  _SmbState createState() {
    _init();
    return _SmbState();
  }

  void _init() async{
    box = await Hive.openBox<String>('database');
    _address = box.get("address") ?? "not found";
    _dns = box.get("dns") ?? "not found";
    _user = box.get("user") ?? "not found";
    _pass = box.get("pass") ?? "not found";
    print("smb info is $_address, $_dns, $_user, $_pass");
  }
}

class _SmbState extends State<Smb> {

  Dsm dsm = Dsm();

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
    debugPrint('Discovery : $json');
  }

  void _stopDiscovery() async {
    dsm.onDiscoveryChanged.listen(null);
    await dsm.stopDiscovery();
  }

  void _resolve() async {
    String name = _dns;
    await dsm.resolve(name);
  }

  void _inverse() async {
    String address = _address;
    await dsm.inverse(address);
  }

  void _login() async {
    await dsm.login(_dns, _user, _pass);
  }

  void _logout() async {
    await dsm.logout();
  }

  void _getShareList() async {
    await dsm.getShareList().then((value) => print("getShareList > $value"));
  }

  int tid = 0;

  void _treeConnect() async {
    tid = await dsm.treeConnect("pub");
  }

  void _treeDisconnect() async {
    int result = await dsm.treeDisconnect(tid);
    tid = 0;
  }

  void _find() async {
    //String result = await dsm.find(tid, "\\*");

    String result = await dsm.find(tid, "\\*");
  }

  void _fileStatus() async {
    String result =
    await dsm.fileStatus(tid, "\\splayer\\splayer_soundtouch\\Test.cpp");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Libdsm example'),
        ),
        body: ListView(
          // <Widget> is the type of items in the list.
          children: <Widget>[
            RaisedButton(
              onPressed: _create,
              child: Text('create'),
            ),
            RaisedButton(
              onPressed: _release,
              child: Text('release'),
            ),
            RaisedButton(
              onPressed: _startDiscovery,
              child: Text('startDiscovery'),
            ),
            RaisedButton(
              onPressed: _stopDiscovery,
              child: Text('stopDiscovery'),
            ),
            RaisedButton(
              onPressed: _resolve,
              child: Text('resolve'),
            ),
            RaisedButton(
              onPressed: _inverse,
              child: Text('inverse'),
            ),
            RaisedButton(
              onPressed: _login,
              child: Text('login'),
            ),
            RaisedButton(
              onPressed: _logout,
              child: Text('logout'),
            ),
            RaisedButton(
              onPressed: _getShareList,
              child: Text('getShareList'),
            ),
            RaisedButton(
              onPressed: _treeConnect,
              child: Text('treeConnect'),
            ),
            RaisedButton(
              onPressed: _treeDisconnect,
              child: Text('treeDisconnect'),
            ),
            RaisedButton(
              onPressed: _find,
              child: Text('find'),
            ),
            RaisedButton(
              onPressed: _fileStatus,
              child: Text('fileStatus'),
            ),
          ],
        ),
      ),
    );
  }
}