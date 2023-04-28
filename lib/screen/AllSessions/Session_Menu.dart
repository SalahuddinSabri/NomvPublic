import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Session_Menu_Items.dart';

class Session_Menu extends StatelessWidget  {
  List<String> hardcoded_list = [];
  String  start_date = "";
  String  session_name = "";
  String  end_date = "";

  Session_Menu({required this.session_name, required this.hardcoded_list , required this.start_date , required this.end_date});

  var colors_main = [
    Color.fromRGBO(255, 238, 231, 0.6),
    Color.fromRGBO(255, 232, 242, 0.6),
    Color.fromRGBO(246, 227, 247, 0.6),
    Color.fromRGBO(223, 235, 252, 0.6),
    Color.fromRGBO(238, 230, 254, 0.6),
  ];

  var colors_text = [
    Color.fromRGBO(89, 191, 231, 1.0),
    Color.fromRGBO(64, 173, 126, 1.0),
    Color.fromRGBO(141, 64, 184, 1.0),
    Color.fromRGBO(39, 94, 46, 1.0),
    Color.fromRGBO(254, 132, 111, 0.8),
    Color.fromRGBO(255, 129, 117, 1),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        appBar: new AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          title:  Text(session_name,
              style: TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
        ),
        body: Container(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom: 30.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Karla',
                      ),
                    ),
                    Divider(
                      indent: 140.0,
                      endIndent: 140.0,
                      thickness: 3,
                      color: Color.fromRGBO(32, 49, 112, 1),
                    ),
                    SizedBox(height: 5),
                    
                    Container(
                      child: ListView.builder(
                        itemCount: hardcoded_list.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          String data = hardcoded_list[index];
                          return ListTile(
                            // isDense: true,
                            // contentPadding: EdgeInsets.only(top: 0),
                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                            title: Card(
                              color: colors_main[index % colors_main.length],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 5),

                                  child: Padding(
                                    padding: EdgeInsets.only(left:15, right: 20, ),
                                    child: Text(
                                      data,
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Karla',
                                          color: colors_text[
                                          index % colors_text.length],
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              // borderRadius: BorderRadius.circular(10)
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                            ),
                            child: Container(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.grey[100],
                                  // ),
                                  child: Center(
                                    child: Text(
                                      start_date + "- " + end_date,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Karla',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ));
  }
}

