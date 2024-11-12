import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Barcode_Scanner.dart';
import 'History.dart';
import 'Scanner_Screen.dart';
import 'about.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code and Barcode Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the currently selected index

  // List of screens for navigation
  final List<Widget> _screens = [
    ScanScreen(),
    AboutPage()

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('QR Code And Barcode Scanner App')),
        backgroundColor: Colors.lightBlue,
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Handle item tap
      ),
    );
  }
}

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navogation QR Code Scanner screen

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QrCodeScannerPage())
              );

            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: Colors.blue, // Background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
            child: Text("Scan QR Code"),
          ),
          SizedBox(height: 20), // Add space between the buttons
          ElevatedButton(
            onPressed: () {
              // Action for Scan BarCode
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BarcodeScannerPage())
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: Colors.blue, // Background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
            child: Text("Scan BarCode"),
          ),
        ],
      ),
    );
  }
}

