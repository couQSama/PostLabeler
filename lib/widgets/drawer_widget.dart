// drawer_widget.dart
import 'package:flutter/material.dart';
import 'package:label_app/screens/label_screen.dart';
import 'package:label_app/screens/statistics_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text('Menu', style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.label, color: Colors.deepPurple),
            title: const Text('Label', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LabelScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: Colors.green),
            title: const Text('Thống kê', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
