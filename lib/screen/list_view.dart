import 'package:flutter/material.dart';
import 'package:iptv_box/add_mob/ad_manager.dart';
import 'package:iptv_box/developers/add_channel.dart';
import 'package:iptv_box/developers/edit_channel.dart';
import 'package:iptv_box/screen/player.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class ChannelListView extends StatefulWidget {
  const ChannelListView({
    Key key,
    this.searchController,
    this.resultList,
    this.isEditing,
  }) : super(key: key);
  final TextEditingController searchController;
  final List resultList;
  final bool isEditing;

  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView> {
  //AdmobInterstitial interstitial;
  BannerAdController _adController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // interstitial = AdmobInterstitial(adUnitId: AdManager.interstitalId);
    // interstitial.load();
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
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: widget.isEditing
            ? AppBar(
                actions: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddChannel()));
                        },
                        icon: Icon(Icons.add)),
                  ),
                ],
              )
            : null,
        body: RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(Duration(seconds: 3));
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget.searchController,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                        itemCount: widget.resultList.length,
                        itemBuilder: (_, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              onTap: () {
                                // if (interstitial.isLoaded != null) {
                                //   interstitial.show();
                                // }
                                if (widget.isEditing) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditChannel(
                                                channelData:
                                                    widget.resultList[index],
                                                fullData: widget.resultList,
                                              )));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Player(
                                          channelData: widget.resultList[index],
                                          allData: widget.resultList),
                                    ),
                                  );
                                } //TODO: Add Channel later
                              },
                              leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                      widget.resultList[index]['img'] ?? '')),
                              title: Text(
                                widget.resultList[index]['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BannerAd(
          unitId: AdManager.bannerId,
          size: BannerSize.ADAPTIVE,
          controller: _adController,
        ),
      ),
    );
  }
}
