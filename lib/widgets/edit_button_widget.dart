import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onPressed;

  const EditButton({
    Key? key,
    required this.isEditMode,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isEditMode ? Icons.save : Icons.edit),
      label: Text(isEditMode ? 'Lưu' : 'Chỉnh sửa'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
