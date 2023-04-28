import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../Utils/const.dart';
import 'Speaker_item_details.dart';

class Speaker_Bio extends StatefulWidget {
  @override
  _StackOverState createState() => _StackOverState();
}

class _StackOverState extends State<Speaker_Bio>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool should_load = false;
  List<speaker_data> plenary_session = [];
  List<speaker_data> breakout_session = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    plenary_fetch(context);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("should_load is :- $should_load");

    if (should_load) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        appBar: new AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text('Speaker Bios',
              style: TextStyle(fontFamily: 'Karla', color: Colors.white)),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(43, 50, 81, 0.9),
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'Plenary Session',
                    ),
                    Tab(
                      text: 'Breakout Session',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Plenary_Fragment(plenary_session),
                    Breakout_Fragment(breakout_session),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    else
      return Scaffold(
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        appBar: new AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text('Speaker Bios',
              style: TextStyle(fontFamily: 'Karla', color: Colors.white)),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 45,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(43, 50, 81, 0.9),
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  border: Border.all(color: Colors.white),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'Plenary Session',
                    ),
                    Tab(
                      text: 'Breakout Session',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Center(
                  child: Container(
                      height: 40.0,
                      width: 40.0,
                      child: Align(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red)))),
                ),
              ),
            ])),
      );
  }

  Future<List<speaker_data>?> plenary_fetch(BuildContext context) async {
    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      final uri_val = await http.get(
        Uri.parse("cspeakerbios"),
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (uri_val.statusCode == 200) {
        dynamic asdd = convert.jsonDecode(uri_val.body);

        if (asdd.containsKey('success') == true) {
          var plenary_sess = asdd["speakerbios"] as List;

          if (plenary_sess.isNotEmpty) {
            setState(() {
              plenary_session = plenary_sess
                  .map<speaker_data>((json) => speaker_data.fromJson(json))
                  .where((element) => element.session_type == "Plenary Session")
                  .toList();
            });

            if (plenary_session.isNotEmpty) {
              breakout_fetch(context);
            }
          }
        }
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Internet Is Required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff586BC6),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<List<speaker_data>?> breakout_fetch(BuildContext context) async {
    final uri_val = await http.get(
      Uri.parse("${base_url}speakerbios"),
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (uri_val.statusCode == 200) {
      dynamic asdd = convert.jsonDecode(uri_val.body);

      if (asdd.containsKey('success') == true) {
        var breakout_sess = asdd["speakerbios"] as List;

        if (breakout_sess.isNotEmpty) {
          setState(() {
            breakout_session = breakout_sess
                .map<speaker_data>((json) => speaker_data.fromJson(json))
                .where((element) => element.session_type == "Breakout Session")
                .toList();
            should_load = true;
          });
          print(
              "the message is :- ${plenary_session.length} ${breakout_session.length}");
        }
      }
    } else {
      return null;
    }
  }
}

class Plenary_Fragment extends StatelessWidget {
  List<speaker_data> mList = [];

  Plenary_Fragment(List<speaker_data> mList) {
    this.mList = mList;

    print("the plenary is :- ${mList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mList.length == null ? 10 : mList.length,
        itemBuilder: (BuildContext context, int index) {
          // LeadershipData data = leadership_hardcode[index];
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 140,
            child: Card(
              color: Colors.transparent,
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(70, 90, 165, 1).withOpacity(0.5),
                      Color.fromRGBO(32, 49, 112, 1).withOpacity(0.5),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 0.2.toInt(),
                      child: Container(
                        width: 110,
                        padding: EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage:
                              NetworkImage("${mList[index].image_url}"),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: Plenary_ListTile(mList[index], context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class speaker_data {
  final int id;
  final String name;
  final String comp_name;
  final String description;
  final String image_url;
  final String session_type;

  speaker_data(this.id, this.name, this.comp_name, this.description,
      this.image_url, this.session_type);

  factory speaker_data.fromJson(Map<String, dynamic> json) {
    return speaker_data(
      json['id'],
      json['name'],
      json['comp_name'],
      json['description'],
      json['image_url'],
      json['session_type'],
    );
  }
}

class Breakout_Fragment extends StatelessWidget {
  List<speaker_data> mList_breakout = [];

  Breakout_Fragment(List<speaker_data> mList_breakout) {
    this.mList_breakout = mList_breakout;

    print("the plenary is :- ${mList_breakout.length}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mList_breakout.length == null ? 10 : mList_breakout.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 140,
            child: Card(
              color: Colors.transparent,
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(70, 90, 165, 1).withOpacity(0.5),
                      Color.fromRGBO(32, 49, 112, 1).withOpacity(0.5),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 0.2.toInt(),
                      child: Container(
                        width: 110,
                        padding: EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              "${mList_breakout[index].image_url}"),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: BreakOut_ListTile(
                              mList_breakout[index], context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class BreakOut_ListTile extends ListTile {
  BreakOut_ListTile(dynamic data, BuildContext context)
      : super(
            title: Container(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 0, bottom: 10, right: 0, top: 20),
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Karla',
                      ),
                      // + "\nsss"
                      text: data.name.toUpperCase()),
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            subtitle: Container(
              padding: EdgeInsets.only(left: 0, bottom: 0, right: 10, top: 0),

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.comp_name,
                      // data.comp_name.length < 40
                      //     ? data.comp_name + "            "
                      //     : data.comp_name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Karla',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Speaker_item_details(
                                  name: data.name,
                                  description: data.description,
                                  session_date: "",
                                  start_time: "",
                                  end_time: "",
                                  location: "",
                                  image_url: data.image_url,
                                  from_speaker: false,
                                )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30, right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "More",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                            fontFamily: 'Karla',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // child: new Text(
              //   data.comp_name,
              //   style: TextStyle(
              //     fontSize: 13.0,
              //     fontFamily: 'Karla',
              //     color: Colors.white,
              //   ),
              // ),
            ),
            dense: false,
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(
                //     builder: (context) => Speaker_item_details(
                //           name: data.name,
                //           description: data.description,
                //           created_at: "",
                //           updated_at: "",
                //           image_url: data.image_url,
                //           from_speaker: false,
                //         )),
                MaterialPageRoute(
                    builder: (context) => Speaker_item_details(
                          name: data.name,
                          description: data.description,
                          session_date: "",
                          start_time: "",
                          end_time: "",
                          location: "",
                          image_url: data.image_url,
                          from_speaker: false,
                        )),
              );
            });
}

class Plenary_ListTile extends ListTile {
  Plenary_ListTile(dynamic data, BuildContext context)
      : super(
            title: Container(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 0, bottom: 10, right: 0, top: 20),
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Karla',
                      ),
                      // + "\nsss"
                      text: data.name.toUpperCase()),
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            subtitle: Container(
              padding: EdgeInsets.only(left: 0, bottom: 10, right: 10, top: 0),
              // child: new Text(
              //   data.comp_name,
              //   style: TextStyle(
              //     fontSize: 13.0,
              //     fontFamily: 'Karla',
              //     color: Colors.white,
              //   ),
              // ),

              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.comp_name,
                      // data.comp_name.length < 40
                      //     ? data.comp_name + "            "
                      //     : data.comp_name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Karla',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        //   MaterialPageRoute(
                        //       builder: (context) => Speaker_item_details(
                        //             name: data.name == null ? "" : data.name,
                        //             description: data.description == null
                        //                 ? "No Description Available..!!"
                        //                 : data.description,
                        //             created_at: data.description,
                        //             updated_at: data.description,
                        //             image_url: data.image_url,
                        //             from_speaker: false,
                        //           )),
                        // );
                        MaterialPageRoute(
                            builder: (context) => Speaker_item_details(
                              name: data.name == null ? "" : data.name,
                              description: data.description == null
                                  ? "No Description Available..!!"
                                  : data.description,
                              session_date: "",
                              start_time: "",
                              end_time: "",
                              location: "",
                              image_url: data.image_url,
                              from_speaker: false,
                            )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30, right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "More",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                            fontFamily: 'Karla',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            dense: false,
            onTap: () {
              Navigator.push(
                context,
                //   MaterialPageRoute(
                //       builder: (context) => Speaker_item_details(
                //             name: data.name == null ? "" : data.name,
                //             description: data.description == null
                //                 ? "No Description Available..!!"
                //                 : data.description,
                //             created_at: data.description,
                //             updated_at: data.description,
                //             image_url: data.image_url,
                //             from_speaker: false,
                //           )),
                // );
                MaterialPageRoute(
                    builder: (context) => Speaker_item_details(
                          name: data.name == null ? "" : data.name,
                          description: data.description == null
                              ? "No Description Available..!!"
                              : data.description,
                          session_date: "",
                          start_time: "",
                          end_time: "",
                          location: "",
                          image_url: data.image_url,
                          from_speaker: false,
                        )),
              );
            });
}
