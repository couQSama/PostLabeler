import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:label_app/widgets/post_widget.dart';

class LabelScreen extends StatefulWidget {
  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  List<dynamic> _posts = [];
  String? savePath;
  int? _selectedValue;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Label App',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue.shade50,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload_file, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Upload JSON File',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.file_upload, color: Colors.deepPurple),
                title: const Text('Tải lên file', style: TextStyle(fontSize: 16)),
                onTap: () {
                  pickFileData();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Chọn bài viết',
                border: OutlineInputBorder(),
              ),
              value: _selectedValue,
              hint: const Text('Chọn bài viết'),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
                // Cuộn về đầu khi chọn bài viết mới
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              items: List.generate(_posts.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text('Post ${index + 1}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _selectedValue != null && _selectedValue! < _posts.length
                  ? ListView(
                controller: _scrollController,
                children: [
                  PostWidget(
                    key: ValueKey<int>(_selectedValue!),
                    posts: _posts,
                    savePath: savePath,
                    postIndex: _selectedValue!,
                  ),
                ],
              )
                  : const Center(
                child: Text(
                  'Vui lòng chọn bài viết',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickFileData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        File f = File(path);
        savePath = path;
        try {
          String content = await f.readAsString();
          setState(() {
            _posts = json.decode(content);
            _selectedValue = null; // Reset the selected value after file load
          });
        } catch (e) {
          // In case of an error during JSON parsing
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải dữ liệu từ file JSON'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // If no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có file nào được chọn!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
