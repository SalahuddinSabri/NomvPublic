import 'dart:convert';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Home_screen.dart';
import '../Home/home_data.dart';
import '../Speaker/Speaker_item_details.dart';
import '../Utils/const.dart';
import 'Session_Menu.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class All_Session extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

// class all_sessions {
//   final int id;
//   final String sess_date;
//   final String sess_name;
//   final String sess_location;
//   final int sess_presenter_id;
//   final String sess_description;
//   final String sess_start_time;
//   final String sess_end_time;
//   final String created_at;
//   final String updated_at;
//   final String sess_presenter_name;
//   final bool isbookmark;
//
//   all_sessions(
//       this.id,
//       this.sess_date,
//       this.sess_name,
//       this.sess_location,
//       this.sess_description,
//       this.sess_presenter_id,
//       this.sess_start_time,
//       this.sess_end_time,
//       this.created_at,
//       this.updated_at,
//       this.sess_presenter_name,
//       this.isbookmark);
//
//   factory all_sessions.fromJson(Map<String, dynamic> json) {
//     return all_sessions(
//       json['id'],
//       json['sess_date'],
//       json['sess_name'],
//       json['sess_location'],
//       json['sess_description'],
//       json['sess_presenter_id'],
//       json['sess_start_time'],
//       json['sess_end_time'],
//       json['created_at'],
//       json['updated_at'],
//       json['sess_presenter_name'],
//       json['isbookmark'],
//     );
//   }
// }

class _SessionState extends State<All_Session> with TickerProviderStateMixin {
  late TabController controller;

  List all_session = [];

  // Future<List<all_sessions>?> get_all_sessions(BuildContext context) async {
  //   SharedPreferences pref = await shared_pref;
  //   bool isOnline = await globals.hasNetwork();
  //
  //   if (isOnline) {
  //     if (pref.containsKey("nomv_userid")) {
  //       if (all_session.isEmpty) {
  //         final uri_val = await http.get(
  //           Uri.parse(
  //               "${base_url}allsessions?user_id=${pref.getString("userid")}"),
  //           headers: <String, String>{"Content-Type": "application/json"},
  //         );
  //
  //         if (uri_val.statusCode == 200) {
  //           dynamic asdd = convert.jsonDecode(uri_val.body);
  //
  //           if (asdd.containsKey('success') == true) {
  //             all_session = asdd["sessions"] as List;
  //
  //             if (all_session.isNotEmpty) {
  //               return all_session
  //                   .map<all_sessions>((json) => all_sessions.fromJson(json))
  //                   .toList();
  //             }
  //           }
  //         } else {
  //           return null;
  //         }
  //       } else {
  //         return all_session
  //             .map<all_sessions>((json) => all_sessions.fromJson(json))
  //             .toList();
  //       }
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Internet Is Required..!!",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //
  //     return null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Stack(
      children: <Widget>[
        WillPopScope(
          onWillPop: () async => true,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,

                actions: <Widget>[
                  // FlatButton(
                  //   textColor: Colors.white,
                  //   onPressed: () {},
                  //   child: Text("Save"),
                  //   shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                  // ),

                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Center(
                      child: Text("22 FEB",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Karla',
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontWeight: FontWeight.w700)),
                    ),
                  ),

                ],

                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/upcoming_session.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                leading: IconButton(
                  constraints: BoxConstraints(maxHeight: 36),
                  icon: Image.asset(
                    'assets/images/menu.png',
                    height: 20,
                    width: 20,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),


                title: const Text('Upcoming Conferences',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Container(
                color: Colors.transparent,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: _buildList(),
              )),
        ),
      ],
    );
  }

  Widget _buildList() {
    /*return Container(
      child: FutureBuilder(
          future: get_all_sessions(context),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text(
                      "No Data Found...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Karla',
                      ),
                    ),
                  ),
                );
              } else {
                List<Tab> tabs = <Tab>[];
                List<String> strTabs = <String>[];

                List<all_sessions> mList = <all_sessions>[];
                List<String> dates = [];
                for (int i = 0; i < snapshot.data.length; i++) {
                  mList.add(snapshot.data[i]);
                  s = snapshot.data[i].sess_date;
                  dates.add(s);
                  var split = s.split(',')[0].split(" ")[1].toString();
                  print(split);
                  strTabs.add(split);
                }

                dates = dates.toSet().toList();
                strTabs = strTabs.toSet().toList();
                strTabs.sort();
                dates.sort();

                print("the dates is hshsh:-  ${dates[activeIndex].toString()}");

                for (String str in strTabs) {
                  print(str);
                  tabs.add(Tab(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        str,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ));
                }

                controller = new TabController(
                    initialIndex: activeIndex,
                    length: strTabs.length,
                    vsync: this);
                controller.addListener(_handleTabSelection);

                return DefaultTabController(
                    length: snapshot.data.length,
                    initialIndex: activeIndex,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(kToolbarHeight),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: TabBar(
                                    unselectedLabelColor: Colors.grey,
                                    unselectedLabelStyle:
                                        TextStyle(fontSize: 15),
                                    isScrollable: true,
                                    tabs: tabs,
                                    controller: controller,
                                    labelColor: Colors.white,
                                    indicatorColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontFamily: 'Karla',
                                    ),
                                    indicatorWeight: 3.0,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                          controller: controller,
                          physics: BouncingScrollPhysics(),
                          children: [
                            for (int i = 0; i < controller.length; i++)
                              MyFragment(getfiltered(strTabs[i], mList), i),
                          ]),
                    ));
              }
            } else {
              if (all_session.isEmpty) {
                return Center(
                  child: Container(
                      width: 40.0,
                      height: 40.0,
                      child: const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.red))),
                );
              } else {
                List<Tab> tabs = <Tab>[];
                List<String> strTabs = <String>[];

                List<all_sessions> mList = <all_sessions>[];
                List<String> dates = [];
                for (int i = 0; i < snapshot.data.length; i++) {
                  mList.add(snapshot.data[i]);
                  s = snapshot.data[i].sess_date;
                  dates.add(s);
                  var split = s.split(',')[0].split(" ")[1].toString();
                  print(split);
                  strTabs.add(split);
                }

                dates = dates.toSet().toList();
                strTabs = strTabs.toSet().toList();
                strTabs.sort();
                dates.sort();

                print("the dates is :-  ${dates.length}");

                for (String str in strTabs) {
                  print(str);
                  tabs.add(Tab(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        str,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ));
                }
                // print("the index is :- mkmkk");
                controller = new TabController(
                    initialIndex: activeIndex,
                    length: strTabs.length,
                    vsync: this);
                controller.addListener(_handleTabSelection);

                return DefaultTabController(
                    length: snapshot.data.length,
                    initialIndex: activeIndex,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: PreferredSize(
                        preferredSize:
                            const Size.fromHeight(kToolbarHeight + 35),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 55, left: 20),
                                  alignment: Alignment.bottomLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    dates[activeIndex].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontFamily: 'Karla',
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: TabBar(
                                    unselectedLabelColor: Colors.grey,
                                    unselectedLabelStyle:
                                        TextStyle(fontSize: 15),
                                    isScrollable: true,
                                    tabs: tabs,
                                    indicator: BoxDecoration(
                                      color: Colors.transparent,
                                      // color: _hasBeenPressed ? Color(0xffffffff) : Color(0xffff00a8),
                                    ),
                                    controller: controller,
                                    labelColor: Colors.white,
                                    indicatorColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontFamily: 'Karla',
                                    ),
                                    indicatorWeight: 3.0,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                          controller: controller,
                          physics: BouncingScrollPhysics(),
                          children: [
                            for (int i = 0; i < controller.length; i++)
                              MyFragment(getfiltered(strTabs[i], mList), i),
                          ]),
                    ));
              }
            }
          }),
    );*/

    return ListView.builder(
        itemCount: upcoming_session.length,
        itemBuilder: (BuildContext context, int index) {
          Upcoming_Session data = upcoming_session[index];
          return Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            height: 120,
            child: Card(
              elevation: 10.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7))),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(62, 169, 189, 0.15),
                      Color.fromRGBO(88, 107, 198, 0.1),
                      // Color.fromRGBO(130, 52, 243, 1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(child: Upcoming_List(data, context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Widget Upcoming_List(Upcoming_Session data, BuildContext context) {
  return new ListTile(
    title: Container(
      margin: EdgeInsets.only(top: 15),
      child: new Text(data.name,
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Karla',
              color: Color(0xff36489C),
              fontWeight: FontWeight.w700)),
    ),

    subtitle: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          Container(
            child: Row(
              children: [
                Text(
                  data.university_name.isEmpty
                      ? "To be available soon"
                      : data.university_name,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color(0xff1E2A60),
                    fontFamily: 'Karla',
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Row(children: [
            Container(
              padding: EdgeInsets.zero,
              child: Image.asset("assets/images/upcoming_sessiondate.png",  fit: BoxFit.fitHeight),
            ),


            SizedBox(width: 10),
            Text(
              data.date.isEmpty ? "To be available soon" : data.date,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0,
                color: Color(0xff242124),
                fontFamily: 'Karla',
              ),
            ),
          ]),
        ],
      ),
    ),


    trailing: Container(
      margin: EdgeInsets.only(top: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0), //or 15.0
        child: Container(
          height: 50.0,
          width: 50.0,
          child: Image.asset(
            "assets/images/upcoming_icon.png",
            height: 70.0,
            width: 70.0,
          ),
        ),
      ),
    ),
  );
}

showLoaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: Container(
              width: 40.0,
              height: 40.0,
              child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
        );
      });
}
