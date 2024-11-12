import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:share_plus/share_plus.dart'; // For sharing functionality
import 'package:image_picker/image_picker.dart'; // For image picking functionality

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController cameraController = MobileScannerController();
  String? scannedData;
  bool isFlashlightOn = false;
  List<String> scanHistory = [];

  // Function to handle Barcode detection
  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          scannedData = barcode.rawValue;
          scanHistory.add(scannedData!); // Add scanned data to history
        });
        cameraController.stop(); // Stop scanning after detection
        break; // Exit after the first valid barcode
      }
    }
  }

  // Function to share the scanned barcode data
  void shareScannedData() {
    if (scannedData != null) {
      Share.share(scannedData!);
    }
  }

  // Function to copy the scanned data to clipboard
  void copyScannedData() {
    if (scannedData != null) {
      Clipboard.setData(ClipboardData(text: scannedData!));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Copied to clipboard'),
      ));
    }
  }

  // Function to toggle the flashlight
  void toggleFlashlight() {
    setState(() {
      isFlashlightOn = !isFlashlightOn;
    });
    cameraController.toggleTorch();
  }

  // Function to show scan history
  void showHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan History'),
          content: SingleChildScrollView(
            child: Column(
              children: scanHistory.map((data) => ListTile(title: Text(data))).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to upload an image from gallery and scan it
  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you can implement QR code scanning from the uploaded image
      // For simplicity, we'll just display the image path as a scanned result
      setState(() {
        scannedData = 'Uploaded Image: ${image.path}';
        scanHistory.add(scannedData!); // Add the scanned result to history
      });

      // You can use a package like `flutter_barcode_scanner` to scan the image
      // However, `mobile_scanner` doesn't support image scanning directly.
      // So you might need to implement a custom solution or use another package.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: showHistory, // Show scan history
          ),
          IconButton(
            icon: Icon(isFlashlightOn ? Icons.flash_off : Icons.flash_on),
            onPressed: toggleFlashlight, // Toggle flashlight
          ),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: uploadImage, // Open gallery to upload an image
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: onDetect, // Callback when barcode is detected
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
                'No Barcode detected yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
