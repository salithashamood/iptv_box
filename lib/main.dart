import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv_box/add_mob/ad_manager.dart';
import 'package:iptv_box/bootom_navigation_bar/navigation_bar.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
//import 'add_mob/ad_manager.dart';
import 'bootom_navigation_bar/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: await_only_futures
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize(appOpenAdUnitId: AdManager.appopenId, bannerAdUnitId: AdManager.bannerId,);
  // // Initialize without device test ids.
  // Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      title: 'IPTV BOX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigation();
  }
}
