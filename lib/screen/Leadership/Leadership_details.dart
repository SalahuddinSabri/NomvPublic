import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:io';

class Leadership_details extends StatelessWidget {

  int index_val;
  String name_val , top,company_name, description, img_url;
  bool is_file_storage;
  List<String> file_path= [];

  Leadership_details({required this.index_val, required this.name_val, required this.top, required this.company_name, required this.description, required this.is_file_storage, required this.file_path, required this.img_url});

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    print("all_data_clicked   $name_val");
    print("all_data_clicked1   $company_name ");
    print("all_data_clicked2  $description ");
    print("all_data_clicked3   $img_url ");

    return Scaffold(
        backgroundColor: Color(0xfffdfdfd),
        appBar: new AppBar(
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                AssetImage('assets/images/leadership_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: IconButton(
            icon: Image.asset(
              'assets/images/menu.png',
              height: 15,
              width: 15,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title:  Text(top,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Align(
          child: Container(
            height: (MediaQuery.of(context).size.height / 1.2),
            width: MediaQuery.of(context).size.width,

            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                // decoration: BoxDecoration(color: Color.fromRGBO(61,163,153, 0.15), borderRadius: BorderRadius.circular(10)),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/box_leadership_details.png'),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: Container(
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              // Image border
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(50),
                                // Image radius

                                child: Container(
                                  color: Colors.transparent,
                                  margin: EdgeInsets.only(top: 10),

                                  child: is_file_storage
                                      ? CachedNetworkImage(
                                    imageUrl: img_url,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    // CircularProgressIndicator(value: downloadProgress.progress),
                                    Transform.scale(
                                      scale: 0.5,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          backgroundColor: Color(0xffd7b563),
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF),
                                          )),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  )
                                      :
                                  Transform.scale(
                                    scale: 1,
                                    // child: Image.file(
                                    //   File(file_path[index_val]),
                                    // ),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(file_path[index_val]),
                                          ),
                                        )),
                                  )
                                ),


                               /* child: CachedNetworkImage(
                                  imageUrl: img_url,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  // CircularProgressIndicator(value: downloadProgress.progress),
                                  Transform.scale(
                                    scale: 0.5,
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                        backgroundColor: Color(0xffd7b563),
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF),
                                        )),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),*/

                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Text(
                        company_name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(195, 174, 121, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        name_val.replaceAll(RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true), "").replaceAll("\n", " "),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xffC3AE79),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0),
                    SizedBox(height: 10.0),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 0,
                          right: 20,
                          bottom: 5,
                        ),

                        child: Html(
                          data: description.isEmpty ? "To be available soon" : description,
                          shrinkWrap: true,
                          style: {
                            'p': Style(textAlign: TextAlign.justify,fontFamily: 'Lato', color: Color.fromRGBO(102, 105, 114, 1), fontSize: FontSize.medium),
                            // 'h3': TextStyle(
                            //   fontSize: 24.0,
                            //   fontFamily: 'Karla',
                            //   fontWeight: FontWeight.w400,
                            //   // color: Color.fromRGBO(102, 105, 114, 1),
                            // ),
                            // 'p': TextStyle(
                            //       fontSize: 14.0,
                            //       fontFamily: 'Lato',
                            //       color: Color.fromRGBO(102, 105, 114, 1),
                            //   // color: Color.fromRGBO(102, 105, 114, 1),
                            // ),
                          },
                        ),

                        // child: Html(
                        //   data: description.isEmpty ? "To be available soon" : description,
                        //   customTextAlign: (_) => TextAlign.justify,
                        //
                        //   defaultTextStyle: TextStyle(
                        //     fontSize: 14.0,
                        //     fontFamily: 'Lato',
                        //     color: Color.fromRGBO(102, 105, 114, 1),
                        //     fontWeight: FontWeight.w400,
                        //
                        //   ),
                        //   onLinkTap: (url) {
                        //     print("Opening $url...");
                        //   },
                        // ),

                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}


