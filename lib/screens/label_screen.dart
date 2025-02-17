import 'package:flutter/material.dart';
import 'package:label_app/providers/file_provider.dart';
import 'package:label_app/widgets/drawer_widget.dart';
import 'package:label_app/widgets/dropdown_widget.dart';
import 'package:label_app/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class LabelScreen extends StatefulWidget {
  const LabelScreen({Key? key}) : super(key: key);

  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  int? _selectedPost;

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final posts = fileProvider.data;
    final savePath = fileProvider.savePath;  // Lấy savePath từ FileProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Label App',
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
          ? Column(
              children: [
                SizedBox(height: 5,),
                DropdownWidget(
                  posts: posts,
                  selectedValue: _selectedPost,
                  onChanged: (int? newValue) {
                    setState(() => _selectedPost = newValue);
                  },
                ),
                Expanded(
                  child: _selectedPost != null && _selectedPost! < posts.length
                      ? PostWidget(
                          posts: posts,
                          postIndex: _selectedPost!,
                          savePath: savePath ?? '',  // Truyền savePath vào đây
                        )
                      : const Center(child: Text('Vui lòng chọn bài viết')),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Chưa có dữ liệu.\nNhấn nút tải lên JSON để bắt đầu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
