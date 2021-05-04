import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          '즐겨찾기',
          style: TextStyle(color: Colors.white),
        ),
        // leading: TextButton(
        //   onPressed: () {},
        //   child: SizedBox(
        //     height: 40,
        //     width: 40,
        //     child: Image.asset('assets/images/RoomGowithB.png'),
        //   ),
        // ),
      ),
      body: buildFavoite(),
      backgroundColor: Colors.yellow[50],
    );
  }
}

Widget buildFavoite() {
  // return ListView(
  //   children: [
  //     for (int i = 0; i < 10; i++) {ListTile(), Divider()}
  //   ],
  // );
  return ListView(
    children: [
      ListTile(
        title: Text('경기도 수원시 장안구 연무동 28-12 305호'),
        subtitle: Text('빌라, 보증금 500 만원, 월세 35만원, 관리비 5만원'),
        trailing: Icon(Icons.delete_outline_outlined),
      ),
      Divider(),
      ListTile(
        title: Text('경기도 수원시 장안구 연무동 25-4 반지하'),
        subtitle: Text('빌라, 보증금 300 만원, 월세 30만원, 관리비 없음'),
        trailing: Icon(Icons.delete_outline_outlined),
      ),
      Divider(),
      ListTile(
        title: Text('경기도 수원시 장안구 우만동 24 403호'),
        subtitle: Text('빌라, 보증금 500 만원, 월세 40만원, 관리비 5만원'),
        trailing: Icon(Icons.delete_outline_outlined),
      ),
      Divider(),
      ListTile(
        title: Text('경기도 수원시 장안구 연무동 신미주아파트 1201호'),
        subtitle: Text('아파트, 전세 4000만원, 관리비 5만원'),
        trailing: Icon(Icons.delete_outline_outlined),
      ),
      Divider(),
      ListTile(
        title: Text('경기 수원시 영통구 대학3로4번길 2 파인랙스'),
        subtitle: Text('오피스텔, 보증금 600만원, 월세 65만원, 관리비 5만원'),
        trailing: Icon(Icons.delete_outline_outlined),
      ),
      Divider(),
    ],
  );
}
