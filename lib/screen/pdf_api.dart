import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PDFApi {
  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;


    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    var file_updated;

    final filename = basename(url);
    final file = '/storage/emulated/0/Download/NomV Files';

    var directory = await Directory(file).create(recursive: true);

    if (directory.existsSync()) {
      file_updated = File('$file/$filename');
      print("storeFile4  $file_updated");
    }

    await file_updated.writeAsBytes(bytes, flush: true);
    return file_updated;
  }
}
