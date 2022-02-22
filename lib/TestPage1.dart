import 'package:flutter/material.dart';
import 'package:flutter_application_1/Setting.dart';

class TestPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestPage1();
  }
}

class _TestPage1 extends State<TestPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/title.jpeg'),
              fit: BoxFit.cover,
            )),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Safe",
                        style: TextStyle(
                            fontSize: 80,
                            color: Color.fromARGB(255, 3, 236, 244))),
                  ),
                  Text("or",
                      style: TextStyle(fontSize: 50, color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Out",
                        style: TextStyle(fontSize: 80, color: Colors.red)),
                  ),
                  Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () => {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Setting();
                              }))
                            },
                        child: Text("start",
                            style:
                                TextStyle(fontSize: 40, color: Colors.white)))
                  ])
                ]))));
  }
}
