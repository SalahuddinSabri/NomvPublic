import 'dart:convert';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AllSessions/Session_Menu.dart';
import '../Home/Home_screen.dart';
import '../Speaker/Speaker_item_details.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../Utils/const.dart';

class My_Sessions extends StatefulWidget {
  @override
  _SessionState createState() => _SessionState();
}

class my_sessions {
  final int id;
  final String sess_date;
  final String sess_name;
  final String sess_location;
  final int sess_presenter_id;
  final String sess_description;
  final String sess_start_time;
  final String sess_end_time;
  final String created_at;
  final String updated_at;
  final String sess_presenter_name;

  my_sessions(
      this.id,
      this.sess_date,
      this.sess_name,
      this.sess_location,
      this.sess_description,
      this.sess_presenter_id,
      this.sess_start_time,
      this.sess_end_time,
      this.created_at,
      this.updated_at ,
      this.sess_presenter_name);

  // this.sess_presenter_name
  factory my_sessions.fromJson(Map<String, dynamic> json) {
    return my_sessions(
      json['id'],
      json['sess_date'],
      json['sess_name'],
      json['sess_location'],
      json['sess_description'],
      json['sess_presenter_id'],
      json['sess_start_time'],
      json['sess_end_time'],
      json['created_at'],
      json['updated_at'],
      json['sess_presenter_name'],
    );
  }
}

class _SessionState extends State<My_Sessions> with TickerProviderStateMixin {
  late TabController controller;

  List my_session = [];
  int activeIndex = 0;
  var s = "";

  Future<List<my_sessions>?> get_my_sessions(BuildContext context) async {
    SharedPreferences pref = await shared_pref;

    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      if (my_session.isEmpty) {
        if (pref.containsKey("nomv_userid")) {
          final uri_val = await http.get(
            Uri.parse(
                "${base_url}bookmarks?user_id=${pref.getString("nomv_userid")}"),
            headers: <String, String>{"Content-Type": "application/json"},
          );

          if (uri_val.statusCode == 200) {
            dynamic asdd = convert.jsonDecode(uri_val.body);

            if (asdd.containsKey('success') == true) {
              my_session = asdd["bookmarks"] as List;

              if (my_session.isNotEmpty) {
                return my_session
                    .map<my_sessions>((json) => my_sessions.fromJson(json))
                    .toList();
              }
            }
          } else {
            return null;
          }
        }
      } else {
        return my_session
            .map<my_sessions>((json) => my_sessions.fromJson(json))
            .toList();
      }
    }
    else {
      Fluttertoast.showToast(
          msg: "Internet Is Required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 0, vsync: this);
    controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    print(controller.index);
    activeIndex = controller.index;
    print("the index is :- $activeIndex");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/background_app.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        WillPopScope(
          onWillPop: () async => true,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
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
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                title: const Text('My Sessions',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
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
    return Container(
      child: FutureBuilder(
          future: get_my_sessions(context),
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
                List<String> original_dates = <String>[];

                List<my_sessions> mList = <my_sessions>[];
                for (int i = 0; i < snapshot.data.length; i++) {
                  mList.add(snapshot.data[i]);
                  s = snapshot.data[i].sess_date;
                  original_dates.add(s);
                  var split = s.split(',')[0].split(" ")[1].toString();
                  print(split);
                  strTabs.add(split);
                }

                strTabs = strTabs.toSet().toList();
                original_dates = original_dates.toSet().toList();
                original_dates.sort();
                strTabs.sort();

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
                              // MyFragment(getfiltered(strTabs[i], mList), i),
                              MyFragment(getfiltered(strTabs[i], mList),
                                  original_dates[i]),
                          ]),
                    ));
              }
            } else {
              if (my_session.isEmpty) {
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

                List<my_sessions> mList = <my_sessions>[];
                List<String> original_dates = <String>[];

                for (int i = 0; i < snapshot.data.length; i++) {
                  mList.add(snapshot.data[i]);
                  s = snapshot.data[i].sess_date;
                  original_dates.add(s);
                  var split = s.split(',')[0].split(" ")[1].toString();
                  print(split);
                  strTabs.add(split);
                }

                strTabs = strTabs.toSet().toList();
                original_dates = original_dates.toSet().toList();
                original_dates.sort();
                strTabs.sort();

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
                              MyFragment(getfiltered(strTabs[i], mList),
                                  original_dates[i]),
                            // MyFragment(getfiltered(strTabs[i], mList)),
                          ]),
                    ));
              }
            }
          }),
    );
  }

  List<my_sessions> getfiltered(String LBTab, List<my_sessions> mList) {
    List<my_sessions> filtered = [];

    for (int a = 0; a < mList.length; a++)
      if (mList[a].sess_date.split(",")[0].split(" ")[1] == LBTab)
        filtered.add(mList[a]);

    return filtered;
  }
}

class MyFragment extends StatelessWidget {
  List<my_sessions> mList = [];
  String index = "";

  MyFragment(List<my_sessions> mList, String index) {
    this.mList = mList;
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    print("my session tab :-  ${index.split(",")[0]} ${index.split(",")[1]}");

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.only(left: 15, bottom: 10, top: 10),
              child: Text(
                index == "" ? "To be available soon" : index.split(",")[0] + ", " + index.split(",")[1],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Karla',
                ),
              )),
        ),
        Expanded(
          child: WillPopScope(
              onWillPop: () async => true,
              child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/images/background_app.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildList(mList),
              )),
        ),
      ],
    );
  }

  Widget _buildList(List<my_sessions> mList) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100, minHeight: 56.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          my_sessions data = mList[index];
          return new GestureDetector(
              onTap: () {
                if (data.sess_presenter_id != 0) {
                  showLoaderDialog(context);
                  show_speaker_data(
                      data.sess_presenter_id,
                      data.sess_date.split(",")[0] +
                          ", " +
                          data.sess_date.split(",")[1],data.sess_start_time, data.sess_end_time, data.sess_location, context);
                }
                //day 1 start
                else if (data.sess_name.contains("Welcome Reception") && data.sess_date.contains("May 1,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_1_welcome_reception ,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                //day 1 end

                //day 2 start
                else if (data.sess_name.contains("Breakfast Buffet") && data.sess_date.contains("May 2,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_2_breakfast,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                else if (data.sess_name.contains("Mid-Morning Break 1") ||data.sess_name.contains("Mid-Morning Break 2")  && data.sess_date.contains("May 2,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_2_mid_morning,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                else if (data.sess_name.contains("Lunch Break") && data.sess_date.contains("May 2,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_2_lunch_buffet,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                else if (data.sess_name.contains("Mid-Afternoon Break") && data.sess_date.contains("May 2,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(session_name: data.sess_name,hardcoded_list: globals.day_2_afternoon_break,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }

                else if (data.sess_name.contains("Vendor/Sponsor and Networking Reception With Prize Baskets and Mariachi Band") && data.sess_date.contains("May 2,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_2_vendor_reception,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                //day 2 end

                //day 3
                // (date ka check yaha check krna ha)
                else if (data.sess_name.contains("Breakfast Buffet") && data.sess_date.contains("May 3,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_3_breakfast_buffett,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                else if (data.sess_name.contains("Mid-Morining Break") && data.sess_date.contains("May 3,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_3_mid_morning,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                else if (data.sess_name.contains("Lunch Break -Grab Food and Get Settled") && data.sess_date.contains("May 3,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_3_lunch_buffet,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                } else if (data.sess_name.contains("Afternoon Mini-Break 1") || data.sess_name.contains("Afternoon Mini-Break 2") && data.sess_date.contains("May 3,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_3_afternoon_break,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                  //day 3 end..!!

                  //day 4 start
                  // (date ka check yaha check krna ha)
                } else if (data.sess_name.contains("Breakfast Buffet") && data.sess_date.contains("May 4,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name,hardcoded_list: globals.day_4_breakfast,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                } else if (data.sess_name.contains("Mid-Morning Break") && data.sess_date.contains("May 4,2022")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Session_Menu(
                            session_name: data.sess_name, hardcoded_list: globals.day_4_mid_morning,start_date: data.sess_start_time ,end_date: data.sess_end_time)),
                  );
                }
                //day 4 end

              },
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                height: 230,
                child: Opacity(
                  opacity: 0.7,
                  child: Card(
                    color: Color.fromRGBO(63, 73, 108, 0.7),
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 50),
                            new Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: SvgPicture.asset(
                                'assets/images/all_sessions.svg',
                                height: 70.0,
                                width: 70.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 5, right: 0, top: 10, bottom: 10),
                          child: VerticalDivider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 0, top: 0, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 30),

                              // child: Text(
                              //   mList[index].sess_date.split(",")[0] + ", " + mList[index].sess_date.split(",")[1] ,

                              Container(
                                child: Text(
                                    data.sess_date == null
                                        ? "To be available soon"
                                        : data.sess_date.split(",")[0] +
                                        ", " +
                                        data.sess_date.split(",")[1],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Karla',
                                        fontSize: 14)),
                              ),

                              SizedBox(height: 10),
                              // SizedBox(height: 50),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 2.5,

                                    child: Visibility(
                                      visible: data.sess_name != null,
                                      child: Text(
                                        data.sess_name == null
                                            ? "To be available soon"
                                            : data.sess_name,
                                        maxLines: 4,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'Karla'),
                                      ),
                                    ),

                                    // child: Visibility(
                                    //   visible: data.sess_presenter_name != null,
                                    //   child: Text(
                                    //     data.sess_presenter_name == null
                                    //         ? "To be available soon"
                                    //         : data.sess_presenter_name,
                                    //     maxLines: 5,
                                    //     softWrap: true,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: Colors.white,
                                    //         fontFamily: 'Karla'),
                                    //   ),
                                    // ),

                                    // child: Text(
                                    //   data.sess_presenter_name == null
                                    //       ? "John Lewis"
                                    //       : data.sess_presenter_name,
                                    //   maxLines: 2,
                                    //   softWrap: true,
                                    //   style: TextStyle(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: Colors.white,
                                    //       fontFamily: 'Karla'),
                                    // ),
                                  ),

                                  Container(
                                    width: 35,
                                    child: Visibility(
                                      visible: data.sess_presenter_id != 0,
                                      child: InkWell(
                                        onTap: () {
                                          showLoaderDialog(context);
                                          show_speaker_data(
                                              data.sess_presenter_id,
                                              data.sess_date.split(",")[0] +
                                                  ", " +
                                                  data.sess_date.split(",")[1],data.sess_start_time, data.sess_end_time, data.sess_location, context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/eye.png"),
                                              size: 15,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5,),
                              Visibility(
                                visible: data.sess_presenter_name != null,
                                child: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width / 2.3,
                                  child: new Text(
                                      data.sess_presenter_name == null
                                          ? "Changing Outlooks of Clinical Trials Life Operations and Clinical Data Managment with Covid Pandemic"
                                          : data.sess_presenter_name,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Karla',
                                          fontSize: 12)),
                                ),
                              ),
                              Visibility(
                                visible: data.sess_location != null,
                                child: Text(
                                  data.sess_location == null
                                      ? ""
                                      : data.sess_location,
                                  maxLines: 5,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontFamily: 'Karla'),
                                ),
                              ),
                              SizedBox(height: 10),

                              // Visibility(
                              //   visible: data.sess_description != null,
                              //   child: SizedBox(
                              //     width:
                              //     MediaQuery.of(context).size.width / 2.3,
                              //     child: new Text(
                              //         data.sess_description == null
                              //             ? "Changing Outlooks of Clinical Trials Life Operations and Clinical Data Managment with Covid Pandemic"
                              //             : data.sess_description,
                              //         maxLines: 3,
                              //         softWrap: true,
                              //         style: TextStyle(
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold,
                              //             fontFamily: 'Karla',
                              //             fontSize: 10)),
                              //   ),
                              // ),

                              SizedBox(height: 10),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width / 2.3,

                                    child: Text(
                                      data.sess_start_time +
                                          " - " +
                                          data.sess_end_time,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Karla',
                                        color: Colors.white,
                                      ),
                                    ),

                                    // child: IconButton(
                                    //   onPressed: () {},
                                    //   icon: Image.asset(
                                    //     'assets/images/clock.png',
                                    //     height: 15,
                                    //     width: 15,
                                    //   ),
                                    // ),
                                  ),
                                ],
                              ),

                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: <Widget>[
                              //     SizedBox(
                              //       child: IconButton(
                              //         onPressed: () {},
                              //         icon: Image.asset(
                              //           'assets/images/clock.png',
                              //           height: 15,
                              //           width: 15,
                              //         ),
                              //       ),
                              //     ),
                              //     Container(
                              //       child: Text(
                              //         data.sess_start_time +
                              //             " - " +
                              //             data.sess_end_time,
                              //         style: TextStyle(
                              //           fontSize: 10.0,
                              //           fontFamily: 'Karla',
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     IconButton(
                              //         onPressed: () {  },
                              //         icon: Image.asset('assets/images/clock.png' , height: 20, width: 20,),
                              //     ),
                              //     Text(
                              //       data.sess_start_time +
                              //           " - " +
                              //           data.sess_end_time,
                              //       style: TextStyle(
                              //         fontSize: 10.0,
                              //         fontFamily: 'Karla',
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // new Text(
                              //   data.sess_start_time +
                              //       " - " +
                              //       data.sess_end_time,
                              //   style: TextStyle(
                              //     fontSize: 10.0,
                              //     fontFamily: 'Karla',
                              //     color: Colors.white,
                              //   ),
                              // ),

                              // Padding(
                              //   child: new Text(
                              //     data.created_at == null ? "" : data.created_at,
                              //     style: TextStyle(
                              //       fontSize: 10.0,
                              //       fontFamily: 'Karla',
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 10),
                          child: VerticalDivider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 50),
                            // InkWell(
                            //   onTap: () {
                            //     showLoaderDialog(context);
                            //     post_bookmark(data.id, context);
                            //   },

                            // if(data.isbookmark)
                            Container(
                              margin: EdgeInsets.only(top: 35),
                              child: ExpandTapWidget(
                                onTap: () {
                                  showLoaderDialog(context);
                                  post_bookmark(data.id, context);
                                },
                                tapPadding: EdgeInsets.all(25.0),
                                // 'assets/images/bookmark.png'
                                child: new Image.asset(
                                  'assets/images/filled_bookmark.png',
                                  height: 20.0,
                                  color: Colors.white,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
        itemCount: mList.length,
      ),
    );
  }

  void post_bookmark(int session_id, BuildContext context) async {
    final String bookmark_url = base_url + 'bookmark';

    SharedPreferences pref = await shared_pref;
    String? sp = pref.getString('userid');
    print("session id is:- $session_id    $sp ");

    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (pref.containsKey("nomv_userid")) {
      final msg = jsonEncode({
        "session_id": session_id,
        "user_id": pref.getString('nomv_userid'),
      });

      final response = await post(
        Uri.parse(bookmark_url),
        headers: headers,
        body: msg,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne_body = jsonDecode(response.body);

        if (resposne_body.containsKey('success') == true) {
          String msg_val = resposne_body['message'];

          Fluttertoast.showToast(
              msg: msg_val,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          // //dismiss dialog..!!
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          Fluttertoast.showToast(
              msg: "Failed to bookmark , try again later",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to bookmark , try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<void> show_speaker_data(int sess_presenter_id,String sess_date, String start_date, String end_date, String loc, BuildContext context) async {
    print(" sess_presenter_id :-  $sess_presenter_id");
    final uri_val = await http.get(
      Uri.parse("${base_url}speakerById?presenter_id=$sess_presenter_id"),
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (uri_val.statusCode == 200) {
      Map<String, dynamic> resposne_body = jsonDecode(uri_val.body);
      if (resposne_body.containsKey('speaker_bio')) {
        Map<String, dynamic> speaker_json = resposne_body['speaker_bio'];
        print(
            " speaker details :- ${speaker_json['created_at']}  ${speaker_json['updated_at']}  ${speaker_json['name']}  ${speaker_json['comp_name']} ${speaker_json['description']}  ${speaker_json['image_url']}   ${speaker_json['session_type']}  ${speaker_json['created_at']}   ${speaker_json['created_at']}");

        //dismiss dialog
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Speaker_item_details(
                name:  speaker_json['name'],
                description: speaker_json['description'],
                session_date: sess_date,
                start_time: start_date,
                end_time: end_date,
                image_url: speaker_json['image_url'],
                location: loc,
                from_speaker: true,
              )),
        );

      } else {}
    } else {
      //dismiss dialog
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: "id is required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

class speaker_details {
  final String name;
  final String comp_name;
  final String description;
  final String image_url;
  final String session_type;
  final String created_at;
  final String updated_at;

  speaker_details(this.name, this.comp_name, this.description, this.image_url,
      this.session_type, this.created_at, this.updated_at);

  factory speaker_details.fromJson(Map<String, dynamic> json) {
    return speaker_details(
      json['name'],
      json['comp_name'],
      json['description'],
      json['image_url'],
      json['session_type'],
      json['created_at'],
      json['updated_at'],
    );
  }
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
