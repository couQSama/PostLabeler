import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List<dynamic> posts;
  final int? selectedValue;
  final ValueChanged<int?> onChanged;

  const DropdownWidget({
    Key? key,
    required this.posts,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Chọn bài viết',
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      hint: const Text('Chọn bài viết'),
      onChanged: onChanged,
      items: List.generate(posts.length, (index) =>
        DropdownMenuItem(value: index, child: Text('Post ${index + 1}')),
      ),
    );
  }
}
