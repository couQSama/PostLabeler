import 'package:flutter/material.dart';
import 'package:label_app/providers/file_provider.dart';
import 'package:label_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final posts = fileProvider.data;

    int totalPosts = posts.length;
    int totalComments = 0;
    int totalCommentsWithLabel = 0;
    int totalCommentsWithSummary = 0;
    int totalPostsWithContent = 0;
    int level1Comments = 0;
    int level2Comments = 0;
    int level3Comments = 0;
    int level1CommentsWithLabel = 0; // Mới thêm: Số lượng comment cấp 1 đã gán nhãn
    Map<int, int> labelCounts = {0: 0, 1: 0, 2: 0};
    Map<int, int> level1LabelCounts = {0: 0, 1: 0, 2: 0}; // Mới thêm: Đếm nhãn riêng cho cấp 1

    void countComments(List<dynamic> comments, int level) {
      for (var comment in comments) {
        totalComments++;
        if (level == 1) level1Comments++;
        if (level == 2) level2Comments++;
        if (level == 3) level3Comments++;

        // Đếm số lượng comment cấp 1 đã gán nhãn
        if (level == 1 && comment['label'] != null) {
          level1CommentsWithLabel++;
          level1LabelCounts[comment['label']] = level1LabelCounts[comment['label']]! + 1; // Đếm nhãn cấp 1
        }

        if (comment['label'] != null) {
          totalCommentsWithLabel++;
          labelCounts[comment['label']] = labelCounts[comment['label']]! + 1;
        }

        if (comment['summary']?.isNotEmpty ?? false) {
          totalCommentsWithSummary++;
        }

        if (comment['comments']?.isNotEmpty ?? false) {
          countComments(comment['comments'], level + 1);
        }
      }
    }

    for (var post in posts) {
      if (post['content']?.isNotEmpty ?? false) {
        totalPostsWithContent++;
      }
      if (post['comments']?.isNotEmpty ?? false) {
        countComments(post['comments'], 1);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Thống Kê')),
      drawer: const DrawerWidget(),
      body: fileProvider.hasData
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Thông Tin')),
                    DataColumn(label: Text('Số Lượng')),
                  ],
                  rows: [
                    DataRow(cells: [DataCell(Text('Số lượng bài viết')), DataCell(Text('$totalPosts'))]),
                    DataRow(cells: [DataCell(Text('Số lượng bài viết có nội dung')), DataCell(Text('$totalPostsWithContent'))]),
                    DataRow(cells: [DataCell(Text('Số lượng comment')), DataCell(Text('$totalComments'))]),
                    DataRow(cells: [DataCell(Text('Số lượng comment đã có tóm tắt')), DataCell(Text('$totalCommentsWithSummary'))]),
                    DataRow(cells: [DataCell(Text('Số lượng comment đã gán nhãn')), DataCell(Text('$totalCommentsWithLabel'))]),
                    DataRow(cells: [
                      DataCell(Text('\t\t\t\t - Số lượng comment theo nhãn')),
                      DataCell(Text('Không ủng hộ: ${labelCounts[0]}, Ủng hộ: ${labelCounts[1]}, Trung lập: ${labelCounts[2]}')),
                    ]),
                    DataRow(cells: [DataCell(Text('Số lượng comment cấp 1')), DataCell(Text('$level1Comments'))]),
                    DataRow(cells: [DataCell(Text('\t\t\t\t - Số lượng comment cấp 1 đã gán nhãn')), DataCell(Text('$level1CommentsWithLabel'))]), // Mới thêm
                    DataRow(cells: [
                      DataCell(Text('\t\t\t\t - Số lượng comment cấp 1 theo nhãn')),
                      DataCell(Text(
                        'Không ủng hộ: ${level1LabelCounts[0]}, Ủng hộ: ${level1LabelCounts[1]}, Trung lập: ${level1LabelCounts[2]}',
                      )),
                    ]), // Mới thêm
                    DataRow(cells: [DataCell(Text('Số lượng comment cấp 2')), DataCell(Text('$level2Comments'))]),
                    DataRow(cells: [DataCell(Text('Số lượng comment cấp 3')), DataCell(Text('$level3Comments'))]),
                  ],
                ),
              ),
            )
          : const Center(child: Text('Chưa có dữ liệu thống kê.')),
    );
  }
}
