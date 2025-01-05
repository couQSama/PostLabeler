import 'package:flutter/material.dart';
import 'package:label_app/models/comment_model.dart';
import 'package:label_app/widgets/comment_widget.dart';
import 'package:label_app/widgets/content_widget.dart';

import 'comment_line_painter.dart';

class PostWidget extends StatelessWidget {
  final List<dynamic> posts;
  final String? savePath;
  final int postIndex;
  const PostWidget({super.key, required this.posts, required this.postIndex, required this.savePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _renderPost(posts[postIndex]),
      ),
    );
  }

  List<Widget> _renderPost(Map<String, dynamic> post) {
    List<Widget> listWidget = [];
    listWidget.add(ContentWidget(posts: posts, postIndex: postIndex, savePath: savePath,));
    var comments = post['comments'] as List<dynamic>?;

    if (comments != null) {
      for (var entry in comments.asMap().entries) {
        List<int>? index = [];
        index.add(postIndex);
        index.add(entry.key);

        listWidget.add(_buildCommentWithLine(entry.value, 0, index));
        if (entry.value.containsKey('comments')) {
          listWidget.addAll(_renderSubComments(entry.value['comments'], 1, index));  // Cấp 1
        }
      }
    }
    return listWidget;
  }

  List<Widget> _renderSubComments(List<dynamic> comments, int level, List<int>? index) {
    List<Widget> listWidget = [];

    for (var entry in comments.asMap().entries) {
      List<int> newIndex = List.from(index!);  // Tạo bản sao tại mỗi vòng lặp
      newIndex.add(entry.key);

      listWidget.add(_buildCommentWithLine(entry.value, level, newIndex));
      if (entry.value.containsKey('comments')) {
        listWidget.addAll(_renderSubComments(entry.value['comments'], level + 1, newIndex));
      }
    }
    return listWidget;
  }

  Widget _buildCommentWithLine(Map<String, dynamic> comment, int level, List<int>? index) {
    double indent = level * 30.0;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: indent),
          child: CommentWidget(
            posts: posts,
            savePath: savePath,
            comment: Comment.fromJson(comment, index),
          ),
        ),
        Positioned(
          left: indent - 20,
          top: 0,
          bottom: 0,
          child: CustomPaint(
            size: Size(20, 60),  // Điều chỉnh chiều cao của đường
            painter: CommentLinePainter(),
          ),
        ),
      ],
    );
  }
}
