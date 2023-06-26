import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/View/CameraPage.dart';
import 'package:flutter_hello_world/View/UserListPage.dart';
import 'package:flutter_hello_world/widget/Maincolor.dart';
import 'package:flutter_hello_world/widget/Const.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Model/HttpHandler.dart';
import '../firebase_options.dart';
import 'ListViewPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Home Page',
        camera: camera,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.camera});

  final String title;

  final CameraDescription camera;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List? _bonusList = [];

  void _incrementCounter() {
    setState(() async {
      ///call Api
      await _getData();
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.29,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular((8.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: mainColor[100]!,
                                    offset: const Offset(2.0, 3.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0)
                              ],
                            ),
                            child: IconButton(
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 35,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: const Icon(Icons.camera_alt),
                                  ),
                                  Text(
                                    '拍照',
                                    style: TextStyle(color: mainColor[350]),
                                  )
                                ],
                              ),
                              onPressed: () {
                                    print("開啟相機功能：");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            //do nothing
                                            CameraPage(
                                                camera: widget.camera)));
                                  // }
                                // });
                              },
                            ),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Column(
                      //開子項目
                      children: [
                        //開子項目
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.29,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular((8.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: mainColor[100]!,
                                  offset: const Offset(2.0, 3.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0)
                            ],
                          ),
                          child: IconButton(
                            icon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/images/group.png'),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                Text(
                                  'github\nUserList',
                                  style: TextStyle(color: mainColor[350]),
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      //do nothing
                                      UserListPage()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.29,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular((8.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: mainColor[100]!,
                                    offset: const Offset(2.0, 3.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0)
                              ],
                            ),
                            child: IconButton(
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 35,
                                    width: 40,
                                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: ExactAssetImage(
                                            'assets/images2/menu.png'),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    // child: _couponCounter(),
                                  ),
                                  Text(
                                    'ListViewPage',
                                    style: TextStyle(color: mainColor[350]),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                    //do nothing
                                    ListViewPage()));
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'api response：',
                  ),
                  Text('$_bonusList'),
                ],
              ),
            ),
          ]))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _getData() async {
    HttpHandler("users")
      ..setFormData({})
      ..get((dynamic data) async {
        setState(() {
          _bonusList = data;
          print("_bonusList：$_bonusList");
        });
      }, (String error) {
        print(error.toString());
      });
  }

  ///取得多項權限
  Future<List<PermissionStatus>> getPermissions() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.camera, Permission.storage].request();

    List<PermissionStatus> statusList = [];
    if (status[Permission.camera] != null) {
      statusList.add(status[Permission.camera]!);
    }
    if (status[Permission.storage] != null) {
      statusList.add(status[Permission.storage]!);
    }
    return statusList;

    if (status[Permission.camera]!.isGranted) {
      print("取得相機權限：成功");
    } else if (status[Permission.camera]!.isPermanentlyDenied) {
      print("取得相機權限：拒絕且不再提示");
    } else {
      print("取得相機權限：拒絕");
    }

    if (status[Permission.storage]!.isGranted) {
      print("取得存取權限：成功");
    } else if (status[Permission.storage]!.isPermanentlyDenied) {
      print("取得存取權限：拒絕且不再提示");
    } else {
      print("取得存取權限：拒絕");
    }
  }

  ///取得單一權限
  Future<PermissionStatus> getCameraPermission() async {
    var status = await Permission.camera.request();

    return status;
  }

  showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("前往設定頁打開權限"),
      actions: [
        ElevatedButton(
            child: Text("取消"),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            child: Text("確認"),
            onPressed: () {
              openAppSettings();
            }),
      ],
    );

    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}
