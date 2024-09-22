import 'package:flutter/material.dart';
import 'package:hctypeorder/screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Invoice';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme:
            ThemeData(primarySwatch: Colors.deepOrange, fontFamily: 'Bookman'),
        //home: PdfPage(),
        // home: ScanTest(),
        home: const HomeScreenHc(),
      );
}
