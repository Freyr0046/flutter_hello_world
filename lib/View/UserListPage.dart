import 'package:flutter/material.dart';
import 'package:flutter_hello_world/Widget/Maincolor.dart';
import '../Model/HttpHandler.dart';

class UserListPage extends StatefulWidget {
  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  int _bonusId = 0;
  List? _goodsList = [];
  List? _bonusList = [];

  @override
  void initState() {
    super.initState();
    _getBonusList();
    _getBonusGoodsList();
  }

  _getBonusList() async {
    HttpHandler("users")
      ..setFormData({})
      ..get((dynamic data) async {
        setState(() {
          if (_bonusList!.isEmpty) {
            _bonusList?.insert(0, {'id': 0, 'name': '全部'});
          }
        });
      }, (String error) {
        print(error.toString());
      });
  }

  _getBonusGoodsList() async {
    var formData = {
      "bonus_id": _bonusId.toString(),
    };
    HttpHandler("users")
      ..setFormData({})
      ..get((dynamic data) async {
        setState(() {
          _goodsList = data;
        });
      }, (String error) {
        print(error.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('github UserList')),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: getGoodsList(),
          )
      ),
      //     // child: Column(
      //     //   children: <Widget>[
      //     //     Container(
      //     //       padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      //     //       child: getGoodsList(),
      //     //     )
      //     //   ],
      //     // ),
    );
  }

  Widget getGoodsList() {
    print("_goodsList：${_goodsList?.length}");
    if (_goodsList == null || _goodsList!.isEmpty) {
      return Column(
        children: <Widget>[
          Text(
            "loading",
            style: TextStyle(fontSize: 16, color: mainColor[300]),
          ),
        ],
      );
    } else {
      List dataList = _goodsList!;
      return Column(children: [
        Container(
          height: 15,
        ),
        Wrap(
          spacing: 0.0,
          children: dataList
              .map(
                (element) => GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300]!,
                                  offset: Offset(5, 0),
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Colors.grey[300]!,
                                  offset: Offset(0, 5),
                                  blurRadius: 5)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              width: MediaQuery.of(context).size.width * 0.395,
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "${element['login']}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: mainColor[330]),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                element['avatar_url']),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${element['node_id']}' + '\n',
                                    style: TextStyle(color: mainColor[330]),
                                    maxLines: 2,
                                  ),
                                  // bonusArea(element['is_bonus']),
                                  bonusArea(false),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                            '${element['html_url']}',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: mainColor[750],
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )
              .toList(),
        ),
      ]);
    }
  }

  Widget bonusArea(status) {
    if (!status) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '沒有活動',
              style: TextStyle(color: Colors.transparent),
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          border: Border.all(
            color: mainColor[750]!,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '優惠活動',
              style: TextStyle(color: mainColor[750]),
            )
          ],
        ),
      );
    }
  }
}
