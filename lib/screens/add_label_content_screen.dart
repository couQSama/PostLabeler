import 'package:flutter/material.dart';

class AddLabelContentScreen extends StatefulWidget {
  const AddLabelContentScreen({super.key});

  @override
  State<AddLabelContentScreen> createState() => _AddLabelContentScreenState();
}

class _AddLabelContentScreenState extends State<AddLabelContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Label app'),
      ),
      body: Placeholder(),
    );
  }
}
