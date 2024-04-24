// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

class ScreenShotScreen extends StatefulWidget {
  const ScreenShotScreen({
    super.key,
  });

  @override
  _ScreenShotScreenState createState() => _ScreenShotScreenState();
}

class _ScreenShotScreenState extends State<ScreenShotScreen> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 5.0),
                    color: Colors.amberAccent,
                  ),
                  child: const MyTable()),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              child: const Text(
                'Capture Above Widget',
              ),
              onPressed: () {
                screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  showCapturedWidget(context, capturedImage!);

                  savePdfToGallery(capturedImage);
                }).catchError((onError) {
                  print(onError);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // Future<void> savePdfToGallery(Uint8List pdfData) async {
  //   final dir = await getExternalStorageDirectory();
  //   final isPermissionGranted = await requestPermission(Permission.storage);

  //   if (isPermissionGranted) {
  //     final file = File('${dir!.path}/document.pdf');
  //     await file.writeAsBytes(pdfData);
  //     await OpenFile.open(file.path);
  //   }
  // }

  Future<void> savePdfToGallery(Uint8List capturedImage) async {
    final pdfData = await generatePdf(pw.MemoryImage(capturedImage));

    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      final isPermissionGranted = await requestPermission(Permission.storage);

      if (isPermissionGranted) {
        final file = File('${dir!.path}/document.pdf');
        await file.writeAsBytes(pdfData);
        await OpenFile.open(file.path);
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/document.pdf');
      await file.writeAsBytes(pdfData);
      await OpenFile.open(file.path);
    } else if (Platform.isMacOS) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/document.pdf');
      await file.writeAsBytes(pdfData);
      await Process.run('open', [file.path]);
    } else if (Platform.isWindows) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/document.pdf');
      await file.writeAsBytes(pdfData);
      await Process.run('start', [file.path]);
    }

    // else if (kIsWeb) {
    //   final blob = html.Blob([pdfData], 'application/pdf');
    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //   final anchor = html.AnchorElement()
    //     ..href = url
    //     ..download = 'document.pdf'
    //     ..style.display = 'none'
    //     ..target = '_blank';
    //   html.document.body?.children.add(anchor);
    //   anchor.click();
    //   html.Url.revokeObjectUrl(url);

    //   print('Saving PDF file is not supported on this platform.');
    // }
  }

  Future<Uint8List> generatePdf(pw.ImageProvider imageProvider) async {
    final pdf = pw.Document();
    final imagePage = pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(imageProvider),
        );
      },
    );
    pdf.addPage(imagePage);
    return pdf.save();
  }

  // Future<void> savePdfToGallery(Uint8List capturedImage) async {
  //   final dir = await getExternalStorageDirectory();
  //   final isPermissionGranted = await requestPermission(Permission.storage);

  //   if (isPermissionGranted) {
  //     final file = File('${dir!.path}/document.pdf');
  //     final pdfData = await generatePdf(pw.MemoryImage(capturedImage));
  //     await file.writeAsBytes(pdfData);
  //     await OpenFile.open(file.path);
  //   }
  // }

  // Future<Uint8List> generatePdf(pw.ImageProvider imageProvider) async {
  //   final pdf = pw.Document();
  //   final imagePage = pw.Page(
  //     pageFormat: PdfPageFormat.a4,
  //     build: (pw.Context context) {
  //       return pw.Center(
  //         child: pw.Image(imageProvider),
  //       );
  //     },
  //   );
  //   pdf.addPage(imagePage);
  //   return pdf.save();
  // }

  Future<void> getPdf(Uint8List screenShot) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    final output = File('Your path + File name');
    await output.writeAsBytes(await pdf.save());
  }

  Future screenToPdf(String fileName, Uint8List screenShot) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    String path = (await getTemporaryDirectory()).path;
    File pdfFile = await File('$path/$fileName.pdf').create();

    pdfFile.writeAsBytesSync(await pdf.save());
    await Share.shareXFiles([pdfFile as XFile]);
  }

  // _saved(File image) async {
  //   // final result = await ImageGallerySaver.save(image.readAsBytesSync());
  //   print("File Saved to Gallery");
  // }
}

class MyTable extends StatelessWidget {
  const MyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(), // Add border for the entire table
      children: const [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Name'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Age'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Gender'),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('John'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('30'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Male'),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Jane'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('25'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Female'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
