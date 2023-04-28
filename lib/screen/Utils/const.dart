import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> shared_pref = SharedPreferences.getInstance();
const String base_url = "https://apis.celeritasdigital.com/nomv-apis/api/";
const String base_url_listing = "https://apis.celeritasdigital.com/nomv-apis/api";

class globals {
  static List<String> speakers_list = [];

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
