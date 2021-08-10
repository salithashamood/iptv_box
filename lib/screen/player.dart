import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  const Player({Key key, @required this.channelData, @required this.allData})
      : super(key: key);
  final DocumentSnapshot channelData;
  final allData;
  @override
  _PlayerState createState() => _PlayerState();
}

Offset startPosition;
double movePan;
double layoutWidth;
double layoutHeight;
double percentage;
String boxFit = '';
double playDialogOpacity = 0.0;
double boxFitOpacity = 0.0;
bool allowHorizontal = false;
double brightness = 0.0;
bool brightnessOk = false;
bool _isHideAppBar = true;
bool isListBar = false;
bool _isBackButton = true;
bool _isExpanded = false;
bool _isHasError = false;
bool _isVolume = false;
bool _isErroMessageLoading = true;
int x;
Icon _icon;
BoxFit y;

class _PlayerState extends State<Player> {
  VideoPlayerController _playerController;
  Duration videoPosition;
  Size get _window => MediaQueryData.fromWindow(window).size;
  String url;
  String name;

  previousChannel() {
    for (var i = 0; i < widget.allData.length; i++) {
      if (widget.allData[i]['url'] == url) {
        if (i != 0) {
          _playerController.dispose();
          setState(() {
            percentage = 100;
            _isBackButton = false;
            url = widget.allData[i - 1]['url'];
            name = widget.allData[i - 1]['name'];
          });
          _playerController = VideoPlayerController.network(url)
            ..addListener(() {
              setState(() {
                videoPosition = _playerController.value.position;
              });
            })
            ..initialize().then((value) {
              _playerController.play();
              setState(() {});
            });
          break;
        }
      }
    }
  }

  nextChannel() {
    for (var i = 0; i < widget.allData.length; i++) {
      if (widget.allData[i]['url'] == url) {
        if (i + 1 != widget.allData.length) {
          _playerController.dispose();
          setState(() {
            percentage = 100;
            _isBackButton = false;
            url = widget.allData[i + 1]['url'];
            name = widget.allData[i + 1]['name'];
          });
          _playerController = VideoPlayerController.network(url)
            ..addListener(() {
              setState(() {
                videoPosition = _playerController.value.position;
              });
            })
            ..initialize().then((value) {
              _playerController.play();
              setState(() {});
            });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _icon = Icon(Icons.crop_free);
    y = BoxFit.cover;
    x = 0;
    url = widget.channelData['url'];
    name = widget.channelData['name'];
    Future.delayed(Duration(seconds: 7), () {
      if (this.mounted) {
        setState(() {
          _isHideAppBar = false;
        });
      }
    });
    percentage = 100;
    _playerController = VideoPlayerController.network(url)
      ..addListener(() {
        if (_playerController.value.hasError) {
          setState(() {
            _isHasError = true;
          });
        }
        setState(() {
          videoPosition = _playerController.value.position;
        });
      })
      ..initialize().then((value) {
        _playerController.play();
        setState(() {});
      });
    _isBackButton ? SystemChrome.setEnabledSystemUIOverlays([]) : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isBackButton
        ? SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
          ])
        : null;
    _playerController.dispose();
    _isExpanded = false;
    brightnessOk = false;
    allowHorizontal = false;
    isListBar = false;
    _isHasError = false;
    _isBackButton
        ? SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        setState(() {
          _isBackButton = true;
        });
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: _isHideAppBar
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(100),
                        child: _showAppBar(),
                      )
                    : null,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Future.delayed(Duration(seconds: 7), () {
                          if (this.mounted) {
                            setState(() {
                              _isHideAppBar = false;
                            });
                          }
                        });
                        setState(() {
                          _isHideAppBar = !_isHideAppBar;
                          isListBar = false;
                          _isExpanded = false;
                        });
                      },
                      onVerticalDragStart: _onVerticalDragStart,
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          child: _playerController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _window.aspectRatio,
                                  child: _playerController.value.isBuffering
                                      ? Container(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : FittedBox(
                                          fit: y,
                                          child: SizedBox(
                                            width: _playerController
                                                .value.size.width,
                                            height: _playerController
                                                .value.size.height,
                                            child: VideoPlayer(
                                              _playerController,
                                            ),
                                          ),
                                        ),
                                  //     BetterPlayer(
                                  //   controller: b_controller,
                                  // ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: playDialogOpacity,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isVolume ? 'Volume' : 'Brightness',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SliderBar(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: boxFitOpacity,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          child: Text(
                            boxFit,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    _isHideAppBar ? PlayerControllerBar() : Container(),
                    isListBar ? List_View() : Container(),
                    _isHasError ? HasError() : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(name),
      elevation: 0.0,
    );
  }

  void _onVerticalDragStart(details) async {
    _reset(context);
    startPosition = details.globalPosition;
    print(startPosition);
    if (startPosition.dx < (layoutWidth / 2)) {
      brightness = await Screen.brightness;
      brightnessOk = true;
    }
  }

  void _onVerticalDragUpdate(details) {
    movePan += (-details.delta.dy);
    if (startPosition.dx < (layoutWidth / 2)) {
      if (brightnessOk = true) {
        setState(() {
          _isVolume = false;
          percentage = (_setBrightnessValue() * 100).toDouble();
          playDialogOpacity = 1.0;
        });
      }
    } else {
      setState(() {
        _isVolume = true;
        percentage = (_setVerticalValue(num: 2) * 100).toDouble();
        playDialogOpacity = 1.0;
      });
    }
  }

  void _onVerticalDragEnd(_) async {
    if (startPosition.dx < (layoutWidth / 2)) {
      if (brightnessOk) {
        await Screen.setBrightness(_setBrightnessValue());
        brightnessOk = false;

        setState(() {
          playDialogOpacity = 0.0;
        });
      }
    } else {
      await _playerController.setVolume(_setVerticalValue());
      setState(() {
        playDialogOpacity = 0.0;
      });
    }
  }

  double _setBrightnessValue() {
    double value =
        double.parse((movePan / layoutHeight + brightness).toStringAsFixed(2));
    if (value >= 1.00) {
      value = 1.00;
    } else if (value <= 0.00) {
      value = 0.00;
    }
    return value;
  }

  double _setVerticalValue({int num = 1}) {
    double value = double.parse(
        (movePan / layoutHeight + _playerController.value.volume)
            .toStringAsFixed(num));
    if (value >= 1.0) {
      value = 1.0;
    } else if (value <= 0.0) {
      value = 0.0;
    }
    return value;
  }

  void _reset(BuildContext context) {
    startPosition = Offset(0, 0);
    movePan = 0;
    layoutHeight = context.size.height;
    layoutWidth = context.size.width;
    percentage = 0;
  }

  SliderBar() {
    final double min = 0;
    final double max = 100;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 60,
        thumbShape: SliderComponentShape.noOverlay,
        overlayShape: SliderComponentShape.noOverlay,
        valueIndicatorShape: SliderComponentShape.noOverlay,
        trackShape: RectangularSliderTrackShape(),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Container(
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                activeColor: _isVolume ? Colors.blue : Colors.yellow[800],
                value: percentage,
                min: min,
                max: max,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    percentage = value;
                  });
                },
              ),
            ),
            Center(
              child: Text(
                '${percentage.round()}%',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String converToMinutesSeconds(Duration duration) {
    final paresedMinutes = duration.inMinutes % 60;
    final minutes =
        paresedMinutes < 10 ? '0$paresedMinutes' : paresedMinutes.toString();
    final paresedSeconds = duration.inSeconds % 60;
    final seconds =
        paresedSeconds < 10 ? '0$paresedSeconds' : paresedSeconds.toString();
    return '$minutes:$seconds';
  }

  List_View() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: _isExpanded ? _window.width * 0.5 : _window.width * 0.3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 2),
              child: Container(
                alignment: Alignment.center,
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.allData.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _isBackButton = false;
                            isListBar = false;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Player(
                                        channelData: widget.allData[index],
                                        allData: widget.allData,
                                      )));
                          //print(name);
                        },
                        tileColor: url == widget.allData[index]['url']
                            ? Colors.blue
                            : null,
                        title: Text(widget.allData[index]['name']),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              widget.allData[index]['img'],
                              scale: 1.0),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  HasError() {
    return Center(
      child: _isErroMessageLoading
          ? Container(
              height: _window.height,
              width: _window.width,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Soryy',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'This URL is not working',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isErroMessageLoading = false;
                        });
                        String response;
                        // ignore: deprecated_member_use
                        final smtpServer =
                            gmail('iptvbox070@gmail.com', 'SSJM_iptv0box');
                        final message = Message()
                          ..from = Address('iptvapp7@gmail.com')
                          ..recipients.add('salithashamood@gmail.com')
                          ..ccRecipients.add('janithmadhuwantha@gmail.com')
                          ..subject = 'Not Working :: ${DateTime.now()}'
                          ..text =
                              'Name - ${widget.channelData['name']}. \nURL - ${widget.channelData['url']}';

                        try {
                          final sendReport = await send(message, smtpServer);
                          response = 'Message Sent';
                          setState(() {
                            _isErroMessageLoading = true;
                          });
                        } on MailerException catch (e) {
                          response = 'Message Not Sent';
                          setState(() {
                            _isErroMessageLoading = true;
                          });
                        }
                        final snackBar = SnackBar(
                          content: Text(response),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        'Submit Error.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      )),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  PlayerControllerBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_playerController.value.isInitialized
                      ? '${converToMinutesSeconds(videoPosition)}'
                      : ''),
                  Expanded(
                    child: VideoProgressIndicator(
                      _playerController,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(10),
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    'Live',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _isHideAppBar = false;
                          isListBar = true;
                        });
                      },
                      icon: Icon(Icons.playlist_play)),
                  Divider(
                    color: Colors.black,
                  ),
                  IconButton(
                      onPressed: () {
                        previousChannel();
                      },
                      icon: Icon(Icons.arrow_back_ios_new_sharp)),
                  Divider(
                    color: Colors.black,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _playerController.value.isPlaying
                              ? _playerController.pause()
                              : _playerController.play();
                        });
                      },
                      icon: Icon(_playerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                  Divider(
                    color: Colors.black,
                  ),
                  IconButton(
                      onPressed: () {
                        nextChannel();
                      },
                      icon: Icon(Icons.arrow_forward_ios_sharp)),
                  Divider(
                    color: Colors.black,
                  ),
                  IconButton(
                      onPressed: () {
                        if (x == 0) {
                          setState(() {
                            x = 1;
                            _icon = Icon(Icons.crop_landscape);
                            y = BoxFit.cover;
                            boxFitOpacity = 1.0;
                            boxFit = 'Best Fit';
                          });
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (this.mounted) {
                              setState(() {
                                boxFitOpacity = 0.0;
                              });
                            }
                          });
                        } else if (x == 1) {
                          setState(() {
                            x = 2;
                            _icon = Icon(Icons.crop_16_9);
                            y = BoxFit.scaleDown;
                            boxFitOpacity = 1.0;
                            boxFit = '16 / 9';
                          });
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (this.mounted) {
                              setState(() {
                                boxFitOpacity = 0.0;
                              });
                            }
                          });
                        } else if (x == 2) {
                          setState(() {
                            x = 3;
                            _icon = Icon(Icons.crop);
                            y = BoxFit.fill;
                            boxFitOpacity = 1.0;
                            boxFit = 'Crop';
                          });
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (this.mounted) {
                              setState(() {
                                boxFitOpacity = 0.0;
                              });
                            }
                          });
                        } else if (x == 3) {
                          setState(() {
                            x = 4;
                            _icon = Icon(Icons.crop_5_4);
                            y = BoxFit.fitHeight;
                            boxFitOpacity = 1.0;
                            boxFit = '4 / 3';
                          });
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (this.mounted) {
                              setState(() {
                                boxFitOpacity = 0.0;
                              });
                            }
                          });
                        } else {
                          setState(() {
                            x = 0;
                            _icon = Icon(Icons.crop_free);
                            y = BoxFit.cover;
                            boxFitOpacity = 1.0;
                            boxFit = 'Stretch';
                          });
                          Future.delayed(Duration(milliseconds: 800), () {
                            if (this.mounted) {
                              setState(() {
                                boxFitOpacity = 0.0;
                              });
                            }
                          });
                        }
                      },
                      icon: _icon),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
