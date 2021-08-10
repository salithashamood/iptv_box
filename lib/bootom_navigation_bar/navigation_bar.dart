import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:iptv_box/developers/channel_list.dart';
import 'package:iptv_box/developers/login_page.dart';
import 'package:iptv_box/screen/category.dart';
import 'package:iptv_box/screen/home_page.dart';
import 'package:new_version/new_version.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 1;
  PageController pageController;
  bool _isConnected = true;

  @override
  void initState() {
    // TODO: implement initState
    isInternet();
    _checkVersion();
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onTap(int pageValue) {
    setState(() {
      selectedIndex = pageValue;
    });
    pageController.jumpToPage(pageValue);
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.iptvbox.iptv_box",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "Update!!!",
      dismissButtonText: "Skip",
      dialogText:
          "Please update the app from ${status.localVersion} to ${status.storeVersion}",
      dismissAction: () {
        Navigator.pop(context);
      },
      updateButtonText: "Let\'s update",
      allowDismissal: true,
    );
  }

  Future<void> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    } else {
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want exit?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes')),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isConnected
          ? WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                bottomNavigationBar: CurvedNavigationBar(
                  color: Colors.white70,
                  backgroundColor: Colors.black12,
                  buttonBackgroundColor: Colors.white60,
                  height: 55,
                  items: [
                    Icon(
                      Icons.category,
                      size: 20,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.home,
                      size: 20,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                  animationDuration: Duration(microseconds: 200),
                  index: selectedIndex,
                  animationCurve: Curves.bounceInOut,
                  onTap: onTap,
                ),
                body: PageView(
                  controller: pageController,
                  children: [
                    Category(),
                    HomePage(),
                    ChannelListDev(isPlayer: true),
                  ],
                ),
                appBar: AppBar(
                  title: Text('IPTV BOX'),
                  centerTitle: true,
                  actions: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                              child: Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock),
                                TextButton(
                                  child: Text(
                                    'Admin Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                ),
                              ],
                            ),
                          )),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            )
          : AlertDialog(
              title: Text('Connection Lost'),
              actions: [
                TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: Text('Exit'),
                ),
                // TextButton(
                //   onPressed: () {

                //     Navigator.pop(context);
                //     isInternet()
                //   },
                //   child: Text('Try Again'),
                //),
              ],
            ),
    );
  }
}
