import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:label_app/widgets/post_widget.dart';
import 'package:label_app/widgets/drawer_widget.dart';
import 'package:label_app/widgets/dropdown_widget.dart';

class LabelScreen extends StatefulWidget {
  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  List<dynamic> _posts = [];
  String? savePath;
  int? _selectedPost;
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
      drawer: DrawerWidget(onFilePicked: pickFileData),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownWidget(
              posts: _posts,
              selectedValue: _selectedPost,
              onChanged: (int? newValue) {
                setState(() => _selectedPost = newValue);
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _selectedPost != null && _selectedPost! < _posts.length
                  ? ListView(
                      controller: _scrollController,
                      children: [
                        PostWidget(
                          key: ValueKey<int>(_selectedPost!),
                          posts: _posts,
                          savePath: savePath,
                          postIndex: _selectedPost!,
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
            _selectedPost = null;
          });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tải dữ liệu thành công!'),
            backgroundColor: Colors.red,
          ),
      );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể tải dữ liệu từ file JSON'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có file nào được chọn!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
