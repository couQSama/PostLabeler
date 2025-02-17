import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileProvider with ChangeNotifier {
  List<dynamic> _data = [];
  bool _hasData = false;
  String? _savePath;  // Thêm biến lưu trữ đường dẫn của file

  List<dynamic> get data => _data;
  bool get hasData => _hasData;
  String? get savePath => _savePath;  // Getter cho savePath

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        _savePath = path;  // Lưu lại đường dẫn của file
        File file = File(path);
        try {
          String content = await file.readAsString();
          _data = json.decode(content);
          _hasData = true;
          notifyListeners();  // Cập nhật UI sau khi đọc xong
        } catch (e) {
          throw Exception('Không thể đọc dữ liệu từ file JSON');
        }
      }
    } else {
      throw Exception('Không có file nào được chọn');
    }
  }
}
