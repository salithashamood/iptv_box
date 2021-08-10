import 'package:flutter/material.dart';
import 'package:iptv_box/add_mob/ad_manager.dart';
import 'package:iptv_box/firebase/login.dart';
import 'package:iptv_box/screen/player.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class Category extends StatefulWidget {
  const Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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
        onRefresh: () async {
          return await Future.delayed(Duration(seconds: 3));
        },
        color: Colors.blue,
        edgeOffset: 100.0,
        strokeWidth: 3,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              child: Column(
                children: [
                  // MOVIES
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8, left: 8),
                      child: Text(
                        'Movie'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder(
                      future: ChannelData().getMovieChannelData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LinearProgressIndicator(),
                          );
                        } else if (snapshot.hasData == null) {
                          return Container();
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
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
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 100,
                                        child: Image.network(
                                          snapshot.data[index]['img'] ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          snapshot.data[index]['name'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // NEWS
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8, left: 8),
                      child: Text(
                        'News'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder(
                      future: ChannelData().getNewsChannelData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LinearProgressIndicator(),
                          );
                        } else if (snapshot.hasData == null) {
                          return Container();
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 100,
                                        child: Image.network(
                                          snapshot.data[index]['img'] ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          snapshot.data[index]['name'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // ANIMATION
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8, left: 8),
                      child: Text(
                        'Animation'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder(
                      future: ChannelData().getAnimationChannelData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LinearProgressIndicator(),
                          );
                        } else if (snapshot.hasData == null) {
                          return Container();
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 100,
                                        child: Image.network(
                                          snapshot.data[index]['img'] ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          snapshot.data[index]['name'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // MUSIC
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 8, left: 8),
                      child: Text(
                        'Music'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: FutureBuilder(
                      future: ChannelData().getMusicChannelData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LinearProgressIndicator(),
                          );
                        } else if (snapshot.hasData == null) {
                          return Container();
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 100,
                                        child: Image.network(
                                          snapshot.data[index]['img'] ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          snapshot.data[index]['name'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BannerAd(
        unitId: AdManager.bannerId,
        size: BannerSize.ADAPTIVE,
        controller: _adController,
      ),
    );
  }
}
