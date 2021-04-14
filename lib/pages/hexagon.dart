import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:honeyroom/login/login_screen.dart';
import 'package:honeyroom/pages/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  HexagonType type = HexagonType.POINTY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.brown,
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
              icon: const Icon(Icons.menu),
              tooltip: 'My Page',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ]),
      body: Stack(
        children: [
          Positioned.fill(child: _buildGrid(context, type)),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, HexagonType type) {
    return InteractiveViewer(
        child: FittedBox(
            fit: BoxFit.fitHeight,
            child: HexagonGrid(
              height: 500,
              hexType: type,
              color: Colors.yellow,
              depth: 1,
              buildTile: (coordinates) => HexagonWidgetBuilder(
                  padding: 4.0,
                  cornerRadius: 12.0,
                  child: TextButton(
                    child: Text('매물정보'),
                    // onPressed: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ToRoomScaffold()));
                    // },
                  )
                  //Text('${coordinates.q}, ${coordinates.r}'),
                  // Text('${coordinates.x}, ${coordinates.y}, ${coordinates.z}\n  ${coordinates.q}, ${coordinates.r}'),
                  ),
            )));
  }

  Widget _buildVerticalGrid() {
    return InteractiveViewer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HexagonOffsetGrid.evenFlat(
            color: Colors.yellow.shade100,
            padding: EdgeInsets.all(8.0),
            columns: 2,
            rows: 4,
            buildTile: (col, row) => HexagonWidgetBuilder(
              color: row.isEven ? Colors.yellow : Colors.orangeAccent,
              elevation: 6.0,
              padding: 8.0,
            ),
            buildChild: (col, row) => Text('$col, $row'),
          ),
        ],
      ),
    );
  }
}
