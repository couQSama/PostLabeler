import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:label_app/models/comment_model.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  List<dynamic> posts;
  String? savePath;
  CommentWidget({super.key, required this.comment, required this.posts, required this.savePath});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late Comment _comment;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    switch (_comment.label) {
      case 0:
        backgroundColor = Colors.red.shade100;
        break;
      case 1:
        backgroundColor = Colors.blue.shade100;
        break;
      case 2:
        backgroundColor = Colors.orange.shade100;
        break;
      default:
        backgroundColor = Colors.white;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),  // Bo góc đều 10
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),  // Độ trong suốt nhẹ
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 4),  // Bóng đổ xuống nhẹ
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
          Row(
            children: [
              Radio<int>(
                value: 0,
                groupValue: _comment.label,
                onChanged: (int? value) {
                  setState(() {
                    _comment.label = value;
                    saveFile(widget.posts, _comment.index, value, widget.savePath);
                  });
                },
              ),
              const Text('Không ủng hộ', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 20),

              Radio<int>(
                value: 1,
                groupValue: _comment.label,
                onChanged: (int? value) {
                  setState(() {
                    _comment.label = value;
                    saveFile(widget.posts, _comment.index, value, widget.savePath);
                  });
                },
              ),
              const Text('Ủng hộ', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 20),

              Radio<int>(
                value: 2,
                groupValue: _comment.label,
                onChanged: (int? value) {
                  setState(() {
                    _comment.label = value;
                    saveFile(widget.posts, _comment.index, value, widget.savePath);
                  });
                },
              ),
              const Text('Trung lập', style: TextStyle(fontSize: 14)),
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

    var encoder = JsonEncoder.withIndent('    ');
    String jsonString = encoder.convert(posts);

    File file = File(savePath);
    await file.writeAsString(jsonString);

  }
}
