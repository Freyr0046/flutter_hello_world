import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  ListViewPageState createState() => ListViewPageState();
}

class ListViewPageState extends State<ListViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> colorCodes = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

    return Scaffold(
      appBar: AppBar(title: const Text('ListViewPage')),
      body: ListView.separated( // 建立一個上下滑動的listView，並用線隔開。
          padding: const EdgeInsets.symmetric(horizontal: 8), // 水平方向的padding
          itemCount: colorCodes.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 150,
              color: Colors.deepOrange[colorCodes[index]],
              child: Center(child: Text('ColorIndex${colorCodes[index]}')),
            );
          },
        //分隔線設定
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(color: Colors.black26, thickness: 2),
        ),
    );
  }
}
