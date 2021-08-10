import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'channel_form.dart';

class AddChannel extends StatefulWidget {
  const AddChannel({Key key}) : super(key: key);

  @override
  _AddChannelState createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String img = '';
  String category = '';
  String url = '';
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Channel'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
          child: Container(
            height: 500,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChannelForm(
                    data: '',
                    text: 'Name',
                    icon: Icon(Icons.person),
                    onSaved: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  ChannelForm(
                    data: '',
                    text: 'Image',
                    icon: Icon(Icons.photo_size_select_actual_rounded),
                    onSaved: (value) {
                      setState(() {
                        img = value;
                      });
                    },
                  ),
                  ChannelForm(
                    data: '',
                    text: 'Category',
                    icon: Icon(Icons.category),
                    onSaved: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                  ),
                  ChannelForm(
                    data: '',
                    text: 'URL',
                    icon: Icon(Icons.link),
                    onSaved: (value) {
                      setState(() {
                        url = value;
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                      ),
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });
                        try {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            final snapshot = await FirebaseFirestore.instance
                                .collection('channel')
                                .add({
                              'name': name,
                              'img': img,
                              'url': url,
                              'category': category
                            }).then((value) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Channel Added!'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ok')),
                                      ],
                                    );
                                  });
                            }).catchError((onError) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Can\'t Added!'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ok')),
                                      ],
                                    );
                                  });
                            });
                          }
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok')),
                                  ],
                                );
                              });
                        }

                        setState(() {
                          _isloading = false;
                        });
                      },
                      child: _isloading
                          ? Center(
                              child: Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ))
                          : Text('Add Channel'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
