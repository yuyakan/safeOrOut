import 'package:flutter/material.dart';
import 'package:flutter_application_1/Shuffle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/TestPage2.dart';
import 'package:flutter_application_1/main.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Setting();
  }
}

class _Setting extends State<Setting> {
  late BannerAd _ad;
  AdSize? _adSize;
  bool _isAdLoaded = false;

  Future<AdSize?> _getAdSize(BuildContext context) async {
    if (_adSize != null) {
      return _adSize;
    }
    _adSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).orientation == Orientation.portrait
            ? Orientation.portrait
            : Orientation.landscape,
        MediaQuery.of(context).size.width.toInt()) as AdSize;
    return _adSize;
  }

  var _cardsIndex = 4;
  var _bulletsIndex = 2;
  void set() {
    for (var i = 0; i < _cardsIndex + 1; i++) {
      outs.add(false);
    }
    for (var i = 0; i < _bulletsIndex + 1; i++) {
      outs[i] = true;
      if (i == _cardsIndex) {
        break;
      }
    }
    outs.shuffle();
  }

  final _cards = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];
  final _bullets = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/setting.png'),
                    fit: BoxFit.cover,
                    opacity: 0.6)),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "${_bullets[_bulletsIndex]}/${_cards[_cardsIndex]}",
                      style: TextStyle(
                          fontSize: 50, color: Color.fromARGB(255, 236, 17, 1)),
                    ),
                    Spacer(),
                    Row(children: [
                      Spacer(),
                      Stack(alignment: Alignment.center, // 重ねる位置を指定
                          children: [
                            Container(
                                width: 60,
                                child: Image.asset("images/card-.png")),
                            Text("Cards",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Color.fromARGB(255, 3, 236, 244))),
                          ]),
                      Spacer(),
                      SizedBox(
                        height: 130,
                        width: 200,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _cardsIndex = index;
                            });
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: 4,
                          ),
                          children: _cards.map((e) => Text(e)).toList(),
                        ),
                      ),
                      Spacer(),
                    ]),
                    Spacer(),
                    Row(children: [
                      Spacer(),
                      Stack(alignment: Alignment.center, // 重ねる位置を指定
                          children: [
                            Container(
                                width: 80,
                                padding: EdgeInsets.only(bottom: 20),
                                child: Image.asset("images/out.png")),
                            Text("Outs",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Color.fromARGB(255, 3, 236, 244))),
                          ]),
                      Spacer(),
                      SizedBox(
                        height: 130,
                        width: 200,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (index2) {
                            setState(() {
                              _bulletsIndex = index2;
                            });
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: 2,
                          ),
                          children: _bullets.map((e) => Text(e)).toList(),
                        ),
                      ),
                      Spacer(),
                    ]),
                    Spacer(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                          onPressed: () => {
                                set(),
                                print(outs),
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return Shuffle();
                                }))
                              },
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Image.asset("images/start.png"),
                          ))
                    ]),
                    Builder(builder: (context) {
                      return Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: size.width,
                        child: FutureBuilder(
                            future: _getAdSize(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString(),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.3),
                                  );
                                }

                                if (!_isAdLoaded) {
                                  _ad = BannerAd(
                                    adUnitId: AdHelper.bannerAdUnitId,
                                    size: _adSize!,
                                    request: AdRequest(),
                                    listener: BannerAdListener(
                                      onAdLoaded: (_) {
                                        setState(() {
                                          _isAdLoaded = true;
                                        });
                                      },
                                      onAdFailedToLoad: (ad, error) {
                                        //Load失敗時の処理
                                        ad.dispose();
                                        print(
                                            'Ad load failed (code=${error.code} message=${error.message})');
                                      },
                                    ),
                                  );
                                  _ad.load();
                                  return Container();
                                }
                                return AdWidget(ad: _ad);
                              } else {
                                return Container();
                              }
                            }),
                      );
                    }),
                  ]),
            )));
  }

  @override
  void dispose() {
    _ad.dispose();
    _adSize = null;
    _isAdLoaded = false;

    super.dispose();
  }
}
