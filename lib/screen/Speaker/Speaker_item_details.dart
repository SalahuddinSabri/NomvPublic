import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/rich_text_parser.dart';

class Speaker_item_details extends StatelessWidget {
  bool from_speaker;
  String name , description, image_url,session_date,start_time , end_time,location;

  Speaker_item_details({required this.name, required this.description, required this.image_url ,
    required this.session_date, required this.start_time,required this.end_time, required this.location,required this.from_speaker});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
      appBar: new AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Speaker Bio',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Karla',
            )),
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
      ),
      body: Align(
        child: Container(
          margin:
          EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0, bottom: 50.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 0.0),
                  child: Hero(
                    tag: 'AGPXE',
                    child: CircleAvatar(
                      radius: 60.0,
                      // backgroundImage: AssetImage('assets/images/leader_6.png'),
                      backgroundImage: NetworkImage(image_url),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),
                // _userName,
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                    fontFamily: 'Karla',
                  ),
                ),

                SizedBox(height: 2.0),
                Divider(
                  indent: 100.0,
                  endIndent: 100.0,
                  thickness: 5,
                  color: Color.fromRGBO(32, 49, 112, 1),
                ),

                SizedBox(height: 15.0),

                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 0, right: 0,),

                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 25, right: 5),
                    // alignment: Alignment.centerLeft,

                    child: Visibility(
                      visible: from_speaker,
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            child: Text('Date: $session_date ',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.0,
                                  fontFamily: 'Karla',
                                )),
                          ),
                          Container(
                            child: Text('Time: ${start_time + " - " +end_time}' ,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15.0,
                                  fontFamily: 'Karla',
                                )),
                          ),

                          Visibility(
                            visible: location != null,
                            child: Container(
                              child: Text(  location == null ? "To be available soon" : location,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontFamily: 'Karla',
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 15.0),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 0,
                    right: 20,
                    bottom: 10,
                  ),

                  child: Container(
                    margin: EdgeInsets.only(left: 5 , right: 5),
                    child: Html(
                      useRichText: true,
                      // data: description,
                      data: description ==null
                          ? "description available soon"
                          : description,
                      // customTextAlign: (_) => TextAlign.justify
                      defaultTextStyle:

                      TextStyle(
                        fontSize: 15 , fontFamily: 'Karla',color: Colors.black87,),
                    ),
                  ),

                  // child: Text(
                  //   description,
                  //   softWrap: true,
                  //   textAlign: TextAlign.start,
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontSize: 15.0,
                  //     fontFamily: 'Karla',
                  //   ),
                  // ),
                ),

                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
