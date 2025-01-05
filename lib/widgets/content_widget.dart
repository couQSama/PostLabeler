import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ContentWidget extends StatefulWidget {
  final List<dynamic> posts;
  final int postIndex;
  final String? savePath;

  const ContentWidget({super.key, required this.posts, required this.postIndex, this.savePath});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late String _content;
  bool _isModifyMode = false;
  int? _postLabel;
  List<Map<String, dynamic>> _labelList = [];
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _content = widget.posts[widget.postIndex]['content'];
    _postLabel = widget.posts[widget.postIndex]['label'];
    _controller = TextEditingController(text: _content);
    loadLabelData();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isModifyMode
                ? TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
                : Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _content,
                style: const TextStyle(fontSize: 16),
                softWrap: true,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (_isModifyMode) {
                      saveContentToPost(_controller.text);
                      setState(() {
                        _content = _controller.text;
                        _isModifyMode = !_isModifyMode;
                      });
                    } else {
                      setState(() {
                        _isModifyMode = !_isModifyMode;
                      });
                    }
                  },
                  icon: Icon(_isModifyMode ? Icons.save : Icons.edit),
                  label: Text(_isModifyMode ? 'Lưu nội dung' : 'Chỉnh sửa'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Label:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _postLabel,
                            hint: const Text('Chọn thể loại'),
                            borderRadius: BorderRadius.circular(10),
                            items: _labelList.map((label) {
                              return DropdownMenuItem<int>(
                                value: label['value'],
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(label['name']),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _postLabel = newValue;
                                savePostLabel(newValue!);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveContentToPost(String content) async {
    widget.posts[widget.postIndex]['content'] = content;

    var encoder = JsonEncoder.withIndent('    ');
    String jsonString = encoder.convert(widget.posts);

    File file = File(widget.savePath ?? '');
    await file.writeAsString(jsonString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nội dung đã được lưu thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> savePostLabel(int postLabel) async {
    widget.posts[widget.postIndex]['label'] = postLabel;

    var encoder = JsonEncoder.withIndent('    ');
    String jsonString = encoder.convert(widget.posts);

    File file = File(widget.savePath ?? '');
    await file.writeAsString(jsonString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nhãn bài viết đã được lưu thành công!'),
        backgroundColor: Colors.green,
      ),
    );

  }

  Future<void> loadLabelData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/post_label.json');
      setState(() {
        _labelList = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
      });
    } catch (e) {
      print('Error loading label data: $e');
    }
  }
}
