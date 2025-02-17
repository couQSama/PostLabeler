// label_dropdown.dart
import 'package:flutter/material.dart';

class LabelDropdown extends StatelessWidget {
  final int? label;
  final ValueChanged<int?> onChanged;

  const LabelDropdown({
    Key? key,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: label,
      hint: const Text('Chọn nhãn'),
      items: const [
        DropdownMenuItem(value: 0, child: Text('Không ủng hộ')),
        DropdownMenuItem(value: 1, child: Text('Ủng hộ')),
        DropdownMenuItem(value: 2, child: Text('Trung lập')),
      ],
      onChanged: onChanged,
      borderRadius: BorderRadius.circular(10),
    );
  }
}