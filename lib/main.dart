import 'package:flutter/material.dart';
import 'package:sqlfl/pags/home_page.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TaskDBApp",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
