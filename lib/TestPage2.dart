import 'package:flutter/material.dart';
import 'package:flutter_application_1/TestPage3.dart';
import 'package:flutter_application_1/TestPage4.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TestPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestPage2();
  }
}

var go_title = false;
List<bool> outs = [];

class _TestPage2 extends State<TestPage2> {
  late BannerAd _ad;
  AdSize? _adSize;
  bool _isAdLoaded = false;

  var ans = false;

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

  var draw = false;

  void _drawT() {
    setState(() {
      draw = true;
    });
  }

  void _drawF() {
    setState(() {
      draw = false;
    });
  }

  void judge() {
    print(outs);
    ans = outs.removeLast();
  }

  void last() {
    go_title = outs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/white.png'),
                    fit: BoxFit.fitWidth,
                    opacity: 0.6)),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Spacer(),
                  SizedBox(
                    height: 10,
                  ),
                  Spacer(),
                  AnimatedOpacity(
                      opacity: draw ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Image.asset("images/card.png")),
                  Spacer(),
                  (() {
                    // 即時関数を使う
                    if (draw) {
                      return TextButton(
                          onPressed: () => {
                                judge(),
                                if (ans)
                                  {
                                    print(ans),
                                    _drawF(),
                                    last(),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return TestPage3();
                                    }))
                                  }
                                else
                                  {
                                    _drawF(),
                                    last(),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return TestPage4();
                                    }))
                                  }
                              },
                          child: Text("Open",
                              style: TextStyle(
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 3, 236, 244))));
                    } else {
                      return TextButton(
                          onPressed: () => {_drawT()},
                          child: Text("Draw",
                              style: TextStyle(
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 3, 236, 244))));
                    }
                  })(),
                  Spacer(),
                  Builder(builder: (context) {
                    return Container(
                      alignment: Alignment.bottomCenter,
                      height: 60,
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
                  })
                ]))));
  }

  @override
  void dispose() {
    _ad.dispose();
    _adSize = null;
    _isAdLoaded = false;

    super.dispose();
  }
}
