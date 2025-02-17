import 'dart:convert';
import 'dart:io';

void addSummaryBeforeComments(List<dynamic> posts) {
  // Hàm đệ quy để thêm summary vào trước comments
  for (var post in posts) {
    // Nếu chưa có 'summary', thêm vào và đảm bảo 'comments' đứng sau
    if (!post.containsKey('summary')) {
      post['summary'] = ""; // Gán giá trị rỗng
    }

    // Nếu 'comments' có trong phần tử, đảm bảo 'summary' nằm trước 'comments'
    if (post['comments'] != null) {
      // Tạo lại Map sao cho 'summary' nằm trước 'comments'
      var newPost = <String, dynamic>{};
      newPost['content'] = post['content']; // Giữ lại các trường khác
      newPost['summary'] = post['summary']; // Đảm bảo 'summary' trước
      newPost['label'] = post['label'];
      newPost['comments'] = post['comments']; // Cuối cùng là 'comments'

      // Thay thế phần tử cũ bằng phần tử mới
      post.clear();
      post.addAll(newPost);
    }

    // Nếu có 'comments' con, gọi đệ quy
    if (post['comments'] != null && post['comments'].isNotEmpty) {
      addSummaryBeforeComments(post['comments']);
    }
  }
}

Future<void> processFile(String inputPath, String outputPath) async {
  try {
    // Đọc nội dung file từ đường dẫn input
    File inputFile = File(inputPath);
    String content = await inputFile.readAsString();
    
    // Chuyển đổi từ JSON sang đối tượng Dart
    List<dynamic> posts = jsonDecode(content);

    // Sửa cấu trúc JSON
    addSummaryBeforeComments(posts);

    // Chuyển đối tượng Dart lại thành chuỗi JSON
    var encoder = JsonEncoder.withIndent('    ');
    String jsonString = encoder.convert(posts);

    // Lưu kết quả vào file mới
    File outputFile = File(outputPath);
    await outputFile.writeAsString(jsonString);

    print('File đã được lưu thành công tại $outputPath');
  } catch (e) {
    print('Lỗi: $e');
  }
}

void main() async {
  // Đường dẫn đến file cần sửa
  String inputPath = r'C:\Users\ASUS\Downloads\data.json';
  
  // Đường dẫn đến file kết quả
  String outputPath = r'E:\Work\AI\Project\PostLabeler\assets\data_add_summary.json'; 

  await processFile(inputPath, outputPath);
}
