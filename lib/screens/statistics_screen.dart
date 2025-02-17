import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:label_app/widgets/drawer_widget.dart';
import 'package:label_app/providers/file_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final posts = fileProvider.data;

    // Khởi tạo các biến thống kê
    int totalPosts = posts.length;
    int totalComments = 0;
    int totalCommentsWithLabel = 0;
    int totalCommentsWithSummary = 0;
    int totalPostsWithContent = 0;
    Map<int, int> labelCounts = {0: 0, 1: 0, 2: 0}; // Đếm số lượng comment theo nhãn

    // Hàm đệ quy để đếm số lượng comment
    void countComments(List<dynamic> comments) {
      for (var comment in comments) {
        totalComments++;

        // Kiểm tra xem comment đã được gán nhãn chưa
        if (comment['label'] != null) {
          totalCommentsWithLabel++;
          labelCounts[comment['label']] = labelCounts[comment['label']]! + 1;
        }

        // Kiểm tra xem comment có tóm tắt không
        if (comment['summary'] != null && comment['summary'].isNotEmpty) {
          totalCommentsWithSummary++;
        }

        // Đệ quy cho các comment con
        if (comment['comments'] != null && comment['comments'].isNotEmpty) {
          countComments(comment['comments']);
        }
      }
    }

    // Đếm comment cho tất cả các bài viết
    for (var post in posts) {
      // Kiểm tra bài viết có nội dung không
      if (post['content'] != null && post['content'].isNotEmpty) {
        totalPostsWithContent++;
      }

      if (post['comments'] != null && post['comments'].isNotEmpty) {
        countComments(post['comments']);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống Kê',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Tải lên JSON',
            onPressed: () async {
              try {
                await fileProvider.pickFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tải dữ liệu thành công!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
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
                    DataRow(cells: [
                      DataCell(Text('Số lượng bài viết')),
                      DataCell(Text('$totalPosts')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Số lượng bài viết có nội dung')),
                      DataCell(Text('$totalPostsWithContent')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Số lượng comment')),
                      DataCell(Text('$totalComments')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Số lượng comment đã gán nhãn')),
                      DataCell(Text('$totalCommentsWithLabel')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Số lượng comment đã có tóm tắt')),
                      DataCell(Text('$totalCommentsWithSummary')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Số lượng comment theo nhãn')),
                      DataCell(Text('Không ủng hộ: ${labelCounts[0]}, Ủng hộ: ${labelCounts[1]}, Trung lập: ${labelCounts[2]}')),
                    ]),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'Chưa có dữ liệu thống kê.\nNhấn nút tải lên JSON để bắt đầu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
