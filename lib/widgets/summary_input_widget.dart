import 'package:flutter/material.dart';

class SummaryInput extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;

  const SummaryInput({
    Key? key,
    required this.isEditMode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập tóm tắt...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(controller.text, style: const TextStyle(fontSize: 16)),
          );
  }
}