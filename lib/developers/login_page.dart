import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'channel_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController _loginController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('IPTV BOX LOGIN'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 200,
              width: 300,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      obscureText: true,
                      expands: false,
                      controller: _loginController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          alignment: Alignment.center,
                        ),
                        child: _isloading
                            ? Center(
                                child: Container(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ))
                            : Text('Login'),
                        onPressed: () async {
                          setState(() {
                            _isloading = true;
                          });
                          try {
                            final firestore = FirebaseFirestore.instance;
                            QuerySnapshot snapshot =
                                await firestore.collection('login').get();
                            //final data = snapshot.docs.elementAt(0);
                            print(snapshot.docs.first.toString());
                            // print(_loginController.text);
                            // ignore: unrelated_type_equality_checks
                            if (_loginController.text ==
                                snapshot.docs.first['pass']) {
                              _loginController.clear();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChannelListDev(
                                            isPlayer: false,
                                          )));
                            } else {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10))),
                                action: SnackBarAction(
                                  textColor: Colors.white,
                                  disabledTextColor: Colors.black,
                                  label: 'Close',
                                  onPressed: () {},
                                ),
                                content: Text(
                                  'Wrong Password!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } on FirebaseException catch (e) {
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              action: SnackBarAction(
                                textColor: Colors.white,
                                disabledTextColor: Colors.black,
                                label: 'Close',
                                onPressed: () {},
                              ),
                              content: Text(
                                '${e.code} \n ${e.message}',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            //print(e.toString());
                          }
                          setState(() {
                            _isloading = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: AdmobBanner(
        //   adUnitId: AdManager.bannerId,
        //   adSize: AdmobBannerSize.BANNER,
        // ),
      ),
    );
  }
}
