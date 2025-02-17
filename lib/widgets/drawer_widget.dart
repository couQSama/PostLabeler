// drawer_widget.dart
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Future<void> Function() onFilePicked;

  const DrawerWidget({Key? key, required this.onFilePicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text('Upload JSON File', style: TextStyle(fontSize: 18, color: Colors.white))
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload, color: Colors.deepPurple),
              title: const Text('Tải lên file', style: TextStyle(fontSize: 16)),
              onTap: () {
                onFilePicked();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}