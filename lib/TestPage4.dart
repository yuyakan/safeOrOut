import 'package:flutter/material.dart';
import 'package:flutter_application_1/TestPage2.dart';
import 'package:flutter_application_1/TestPage1.dart';

class TestPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Spacer(),
          Image.asset("images/safe.png"),
          Padding(
              padding: EdgeInsets.all(50),
              child: TextButton(
                onPressed: () => {
                  if (go_title)
                    {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return TestPage1();
                      }))
                    }
                  else
                    {
                      Navigator.of(context).pop(),
                    }
                },
                child: (() {
                  // 即時関数を使う
                  if (go_title) {
                    return const Text("title",
                        style: TextStyle(
                            fontSize: 40,
                            color: Color.fromARGB(255, 3, 236, 244)));
                  } else {
                    return const Text("continue",
                        style: TextStyle(
                            fontSize: 40,
                            color: Color.fromARGB(255, 3, 236, 244)));
                  }
                })(),
              ))
        ]))));
  }
}
