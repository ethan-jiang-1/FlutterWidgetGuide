import 'package:flutter_widget_guide/screens_btd/home_page.dart';
import 'package:flutter/material.dart';

//void main() => runApp(new MyApp());

class MyBtdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      title: 'Buy Tickets',
      home: HomePage(),
    );
  }
}
