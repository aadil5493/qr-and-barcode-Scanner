import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> scannedHistory; // Parameter to accept scanned history

  // Constructor to pass the scanned data to the HistoryPage
  HistoryPage({ required this.scannedHistory });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Data History'),
      ),
      body: scannedHistory.isEmpty
          ? Center(child: Text('No scanned data history'))
          : ListView.builder(
        itemCount: scannedHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scannedHistory[index]),
          );
        },
      ),
    );
  }
}
