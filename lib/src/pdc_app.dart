import 'package:flutter/material.dart';
import 'package:prairie_devcon/src/pages/pdc_home_page.dart';

class PDCApp extends StatelessWidget {
  const PDCApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PDCHomePage(title: 'Prairie Dev Con Regina'),
    );
  }
}
