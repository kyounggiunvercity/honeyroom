import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:honeyroom/login/login_screen.dart';
import 'widget.dart';

class ToRoomScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('꿀방'),
          leading: TextButton(
            onPressed: () {},
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset('assets/images/RoomGowithB.png'),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: 'My Page',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ]),
      body: Column(
        children: <Widget>[MenuBox()],
      ),
    );
  }
}
