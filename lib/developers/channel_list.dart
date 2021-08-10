import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iptv_box/firebase/channel.dart';
import 'package:iptv_box/screen/list_view.dart';

class ChannelListDev extends StatefulWidget {
  const ChannelListDev({Key key, @required this.isPlayer}) : super(key: key);
  final bool isPlayer;

  @override
  _ChannelListDevState createState() => _ChannelListDevState();
}

class _ChannelListDevState extends State<ChannelListDev> {
  TextEditingController _searchController = TextEditingController();

  List _allResults = [];
  Future resultLoaded;
  List _resultList = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getIMG();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = getChannel();
  }

  _onSearchChanged() {
    searchResultList();
    //print(_searchController.text);
  }

  searchResultList() {
    var showResult = [];
    for (var names in _allResults) {
      var name = Channel.fromSnapshot(names).name.toLowerCase();

      if (name.contains(_searchController.text.toLowerCase())) {
        showResult.add(names);
      }
    }
    if (_searchController.text != "") {
    } else {
      showResult = List.from(_allResults);
    }
    setState(() {
      _resultList = showResult;
    });
  }

  Future getChannel() async {
    try {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot =
          await firestore.collection('channel').orderBy('name').get();
      setState(() {
        _allResults = snapshot.docs;
        _isLoading = true;
      });
      //print(_allResults.length);
      searchResultList();
      return 'complete';
    } on FirebaseException catch (e) {
      //print(e.code);
      //print(e.message);
    } catch (e) {
      //print(e.toString());
    }
    //print(_allResults);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? widget.isPlayer ? ChannelListView(
            searchController: _searchController,
            resultList: _resultList,
            isEditing: false,
          ) : ChannelListView(
            searchController: _searchController,
            resultList: _resultList,
            isEditing: true,
          )
        : SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}
