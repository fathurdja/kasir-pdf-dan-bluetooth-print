// import 'package:kasir_app/models/ipConfiguration.dart';
import 'package:kasir_app/state_util.dart';
import 'package:kasir_app/core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Kasir",
          navigatorKey: Get.navigatorKey,
          // home: const Home(),
          // home: WellcomePage(),
          home: Home(
            data: [],
          )),
    );
  }
}
