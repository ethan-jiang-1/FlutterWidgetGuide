import 'package:flutter/material.dart';
import 'package:flutter_widget_guide/screens_rm/radial_menu.dart';
import 'package:flutter_widget_guide/screens_rm/radial_menu_item.dart';

//void main() {
//  runApp(MyApp());
//}

class MyRmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new RadialMenu(
            items: <RadialMenuItem<int>>[
              const RadialMenuItem<int>(
                value: 1,
                child: const Icon(Icons.add),
              ),
              const RadialMenuItem<int>(
                value: -1,
                child: const Icon(Icons.remove),
              ),
              const RadialMenuItem<int>(
                value: -1,
                child: const Icon(Icons.adjust),
              ),
              const RadialMenuItem<int>(
                value: -1,
                child: const Icon(Icons.delete),
              ),
              const RadialMenuItem<int>(
                value: -1,
                child: const Icon(Icons.ac_unit),
              ),
              const RadialMenuItem<int>(
                value: -1,
                child: const Icon(Icons.add_a_photo),
              ),
            ],
            radius: 100.0,
            onSelected: print,
          ),
        ),
      ),
    );
  }
}