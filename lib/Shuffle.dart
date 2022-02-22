import 'package:flutter/material.dart';
import 'package:flutter_application_1/TestPage2.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Shuffle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Shuffle();
  }
}

class _Shuffle extends State<Shuffle> with TickerProviderStateMixin {
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

  late AnimationController _controller; //アニメーションコントローラ
  late Animation<double> _rotateAnimation; //角度

  void shuffle() {
    outs.shuffle();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1), //アニメーションの時間
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

//回転する角度の設定
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(_controller);
  }

  void _animationChange() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/white.png'),
              fit: BoxFit.cover,
            )),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Spacer(),
                  SizedBox(
                    height: 10,
                  ),
                  Spacer(),
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Image.asset('images/card2.png'),
                  ),
                  Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Spacer(),
                    TextButton(
                        onPressed: () =>
                            {_animationChange(), shuffle(), print(outs)},
                        child: Text('shuffle',
                            style: TextStyle(
                                fontSize: 35,
                                color: Color.fromARGB(255, 3, 236, 244)))),
                    Spacer(),
                    TextButton(
                        onPressed: () => {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TestPage2();
                              }))
                            },
                        child: Text("start",
                            style: TextStyle(
                                fontSize: 38,
                                color: Color.fromARGB(255, 3, 236, 244)))),
                    Spacer(),
                  ]),
                  Spacer(),
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
