import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart'; // Add this package for sharing functionality
import 'package:flutter/services.dart'; // Add this package for clipboard functionality

class QrCodeScannerPage extends StatefulWidget {
  @override
  _QrCodeScannerPageState createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> with WidgetsBindingObserver {
  final MobileScannerController cameraController = MobileScannerController();
  String? scannedData;
  bool isFlashOn = false;

  // Store scanned data in a list for history
  List<String> scannedHistory = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      cameraController.stop(); // Stop the camera when the app is in the background
    } else if (state == AppLifecycleState.resumed) {
      if (mounted) {
        cameraController.start(); // Restart the camera when the app is resumed
      }
    }
  }

  // Function to handle QR code detection
  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedData = barcode.rawValue;
          scannedHistory.add(scannedData!); // Add scanned data to history
        });
        cameraController.stop(); // Stop scanning after detection
        break; // Exit after the first valid QR code
      }
    }
  }

  // Function to upload an image from the gallery
  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Here you can implement QR code scanning from the uploaded image
      // For simplicity, we will just display the image path
      setState(() {
        scannedData = 'Uploaded Image: ${image.path}';
        scannedHistory.add(scannedData!); // Add to history
      });
    }
  }

  // Function to toggle flashlight
  void toggleFlashlight() {
    setState(() {
      isFlashOn = !isFlashOn;
      isFlashOn ? cameraController.toggleTorch() : cameraController.toggleTorch();
    });
  }

  // Function to share the scanned data
  void shareScannedData() {
    if (scannedData != null) {
      Share.share(scannedData!);
    }
  }

  // Function to copy the scanned data to clipboard
  void copyScannedData() {
    if (scannedData != null) {
      Clipboard.setData(ClipboardData(text: scannedData!)); // Use null assertion operator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Copied to clipboard'),
      ));
    }
  }

  // Show History Dialog Box
  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Scan History"),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: scannedHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedHistory[index]),
                  onTap: () {
                    // Show detailed dialog for selected history item
                    showHistoryItemDialog(scannedHistory[index]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // Show individual history item details in a dialog
  void showHistoryItemDialog(String historyItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Scanned Data Detail"),
          content: Text("Scanned Data: $historyItem"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
            onPressed: toggleFlashlight,
          ),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: uploadImage,
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: showHistoryDialog, // Open history dialog box
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: onDetect,
            ),
          ),
          SizedBox(height: 20),
          if (scannedData != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Scanned Data: $scannedData',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: shareScannedData,
                        child: Text('Share'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: copyScannedData,
                        child: Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (scannedData == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No QR code detected yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
