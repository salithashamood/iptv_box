import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iptv_box/add_mob/ad_manager.dart';
//import 'package:iptv_box/add_mob/ad_manager.dart';
import 'package:iptv_box/firebase/login.dart';
import 'package:iptv_box/screen/player.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAdController _adController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_adController.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _adController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        edgeOffset: 100,
        strokeWidth: 3,
        onRefresh: () async {
          return await Future.delayed(Duration(seconds: 3));
        },
        child: Container(
          padding: EdgeInsets.only(top: 25),
          child: FutureBuilder(
            future: ChannelData().getAllChannelData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 140,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                        crossAxisCount: 4,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Player(
                                    channelData: snapshot.data[index],
                                    allData: snapshot.data),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                child: Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    child: Image.network(
                                      snapshot.data[index]['img'] ?? '',
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                //height: 30.0,
                                width: 90.0,
                                child: Text(
                                  snapshot.data[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              }
            },
          ),
        ),
      ),
      // bottomNavigationBar: BannerAd(
      //   unitId: AdManager.bannerId,
      //   size: BannerSize.ADAPTIVE,
      //   controller: _adController,
      // ),
    );
  }
}
