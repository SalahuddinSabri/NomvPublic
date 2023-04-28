
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../Utils/const.dart';
import 'Leadership_details.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Leadership extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Leadership_State();
  }
}

class Leadership_Data {
  final String name;
  final String comp_name, description,top_name;
  final String image_url;

  Leadership_Data(this.name, this.top_name, this.comp_name, this.description, this.image_url);

  factory Leadership_Data.fromJson(Map<String, dynamic> json) {
    return Leadership_Data(json['name'],json['top_name'], json['comp_name'], json['description'],
        json['image_url']);
  }
}

class Leadership_State extends State<Leadership> {
  List<String> file_data= [];
  List<Leadership_Data> plenary_session = [];
  bool should_load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          leadership_fetchdata();
        }),
    );
  }


  Future<List<Leadership_Data>?> leadership_fetchdata() async {

    SharedPreferences pref = await shared_pref;

    if (pref.containsKey("json_leadership")) {
      dynamic asdd = convert.jsonDecode(pref.getString("json_leadership").toString());
      var leaders_array = asdd["leadership"] as List;
      print("leaders_array ${leaders_array.length}");

      if (leaders_array.isNotEmpty) {
        setState(() {
          if (pref.containsKey("pdf_downloaded_info")) {
            file_data = pref.getStringList("pdf_downloaded_info")!;
          } else {
            file_data.clear();
          }
          plenary_session= leaders_array.map<Leadership_Data>((json) => Leadership_Data.fromJson(json)).toList();
          should_load = true;
        });
        print("all_leaders  ${file_data.length}     ${plenary_session.length}     $should_load");

      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (should_load) {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            // onWillPop: () async => true,
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
              return true;
            },

            child: Scaffold(
                backgroundColor: Color(0xfffdfdfd),
                appBar: new AppBar(
                  centerTitle: true,
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/leadership_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    constraints: BoxConstraints(maxHeight: 36),
                    icon: Image.asset(
                      'assets/images/menu.png',
                      height: 15,
                      width: 15,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                    },
                  ),
                  title: const Text('Leadership Team',
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                ),


                body: Container(
                  color: Color(0xfffdfdfd),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: _buildList(plenary_session, file_data),
                )),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            // onWillPop: () async => true,
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
              return true;
            },

            child: Scaffold(
                backgroundColor: Color(0xfffdfdfd),
                appBar: new AppBar(
                  centerTitle: true,
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/leadership_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    constraints: BoxConstraints(maxHeight: 36),
                    icon: Image.asset(
                      'assets/images/menu.png',
                      height: 15,
                      width: 15,
                      color: Colors.white,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                    },
                  ),
                  title: const Text('Leadership Team',
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                ),


                body: Center(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    child: const CircularProgressIndicator(
                        backgroundColor: Color(0xffd7b563),
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
                  ),
                ),),
          ),
        ],
      );
    }
  }


  Widget _buildList(List<Leadership_Data> plenary_session, List<String> file_data) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListView.builder(
            itemCount: plenary_session.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Leadership_details(
                            index_val : index,
                            name_val: plenary_session[index].name,
                            top: plenary_session[index].top_name,
                            company_name: plenary_session[index].comp_name,
                            description: plenary_session[index].description,
                            is_file_storage: file_data.isEmpty,
                            file_path : file_data,
                            img_url: plenary_session[index].image_url)),
                  );
                },

                child: Container(
                  margin: EdgeInsets.only(
                      top: 5, bottom: 5, left: 20, right: 20),
                  // margin: EdgeInsets.only(left: 10, right: 10),
                  height: 120,
                  child: Card(
                    // color: Color(0xfffbf7ed),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.transparent),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color(0xfffbf7ee),
                              Color(0xfffbf7ee),
                              Color(0xfffdf9ef),
                              // Color.fromRGBO(130, 52, 243, 1),
                            ],
                          )),

                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 0.1.toInt(),
                            child: Container(
                                margin: EdgeInsets.only(left: 15),

                                child: ClipRRect(
                                  child: Container(
                                    width: 60,
                                    height: 60,

                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        // Image border
                                        child: SizedBox.fromSize(
                                            size: Size.fromRadius(30),
                                            // Image radius

                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(file_data[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                        )),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Container(
                                child: LeadershipListTile(
                                    index,
                                    plenary_session[index].name,
                                    plenary_session[index].top_name,
                                    plenary_session[index].comp_name,
                                    plenary_session[index].description,
                                    file_data.isEmpty,
                                    file_data,
                                    plenary_session[index].image_url,
                                    context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },

        ),
      )
    );
  }
}


class LeadershipListTile extends ListTile {
  LeadershipListTile(int index_val, String name, String main_name, String company_name, String description,bool is_empty, List<String> file, String img_url, BuildContext context)
      : super(
            minVerticalPadding: 5.0,
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
      visualDensity: VisualDensity(horizontal: 1, vertical: -4),


      title: Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
          company_name.isEmpty ? "To be available soon" : company_name.replaceAll(RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true), "").replaceAll("\n", " "),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.0,
            color: Color.fromRGBO(195, 174, 121, 1),
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(left: 10),
        child: Text(
          name.isEmpty ? "To be available soon" : name.replaceAll(RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true), "").replaceAll("\n", " "),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(210, 172, 79, 1),
            fontFamily: 'Lato',
          ),
        ),
      ),

      trailing: Container(
              height: double.infinity,
              margin: EdgeInsets.only(right: 10),
              child: ClipRRect(
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  child: Image.asset(
                    "assets/images/forward_icon.png",
                    height: 15.0,
                    width: 15.0,
                  ),
                ),
              ),
            ),

            dense: true,
            onTap: () {
              if(img_url==null)
                img_url= "https://businessplus.ie/wp-content/uploads/2022/08/merck-2.jpg";

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Leadership_details(
                        index_val : index_val,
                        name_val: name,
                        top: main_name,
                        company_name: company_name,
                        description: description,
                        is_file_storage: is_empty,
                        file_path : file,
                        img_url: img_url)),
              );
            });

    static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
}

