// comment_widget.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:label_app/models/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final List<dynamic> posts;
  final String? savePath;

  const CommentWidget({super.key, required this.comment, required this.posts, required this.savePath});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late Comment _comment;
  final TextEditingController _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
    _summaryController.text = _comment.summary ?? ''; // Nếu 'summary' null, dùng chuỗi rỗng
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = switch (_comment.label) {
      0 => Colors.red.shade100,
      1 => Colors.blue.shade100,
      2 => Colors.orange.shade100,
      _ => Colors.white,
    };

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _comment.content,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            softWrap: true,
          ),
          const SizedBox(height: 12),        
          // Hiển thị tóm tắt
          TextField(
            controller: _summaryController, // Kết nối controller với TextField
            decoration: const InputDecoration(
              labelText: 'Tóm tắt',
              border: OutlineInputBorder(),
            ),
            maxLines: null,  // Cho phép tự động xuống dòng khi nội dung dài
            keyboardType: TextInputType.multiline,  // Chế độ nhập liệu đa dòng
          ),

          const SizedBox(height: 12),

          // Nút Lưu tóm tắt
          ElevatedButton(
            onPressed: () {
              saveFile(widget.posts, _comment.index, _comment.label, widget.savePath);

              // Cập nhật tóm tắt
              _comment.summary = _summaryController.text;

              // Hiển thị thông báo khi lưu thành công
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tóm tắt đã được lưu thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Lưu Tóm Tắt'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              for (var label in [0, 1, 2])
                Row(
                  children: [
                    Radio<int>(
                      value: label,
                      groupValue: _comment.label,
                      onChanged: (int? value) {
                        setState(() {
                          _comment.label = value;
                          saveFile(widget.posts, _comment.index, value, widget.savePath);
                        });
                      },
                    ),
                    Text(label == 0
                        ? 'Không ủng hộ'
                        : label == 1
                            ? 'Ủng hộ'
                            : 'Trung lập',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveFile(posts, index, label, savePath) async {
    var cmt = posts[index[0]];
    for (var i in index.sublist(1)) {
      cmt = cmt['comments'][i];
    }
    cmt['label'] = label;
    cmt['summary'] = _summaryController.text;  // Cập nhật giá trị summary từ TextField

    var encoder = JsonEncoder.withIndent('    ');
    String jsonString = encoder.convert(posts);

    File file = File(savePath);
    await file.writeAsString(jsonString);
  }
}
