import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:honeyroom/pages/hexagon.dart';

//import 'login/transition_route_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '꿀방',
      theme: ThemeData(
        backgroundColor: Colors.yellow[50],
        // brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        accentColor: Colors.orange,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        // fontFamily: 'SourceSansPro',
        iconTheme: IconThemeData(color: Colors.brown),
        textTheme: TextTheme(
          button: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black,
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          headline1: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            //fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.black,
          ),
          headline5: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
          headline6: TextStyle(fontFamily: 'NotoSans', color: Colors.black),
          bodyText1: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
          subtitle2: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
          overline: TextStyle(
            fontFamily: 'NotoSans',
            color: Colors.black,
          ),
        ),
      ),
      home: MyHomePage(),
      //navigatorObservers: [TransitionRouteObserver()],
    );
  }
}
