// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:label_app/providers/file_provider.dart';
import 'package:label_app/screens/label_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LabelScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
