import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

class CommonUtils {
  static Future<void> savePdfToGallery(Uint8List capturedImage) async {
    print(capturedImage.length);
    final pdfData = await generatePdf(pw.MemoryImage(capturedImage));

    //  Uncomment for web
    if (kIsWeb) {
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..download = 'document.pdf'
        ..style.display = 'none'
        ..target = '_blank';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.Url.revokeObjectUrl(url);

      print('Saving PDF file is not supported on this platform.');
    } else if (Platform.isAndroid) {
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
  }

  static Future<Uint8List> generateMultiplePdf(
      List<Uint8List> capturedImages) async {
    final pdf = pw.Document();
    for (var imageBytes in capturedImages) {
      final imagePage = pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(imageBytes)),
          );
        },
      );
      pdf.addPage(imagePage);
    }
    return pdf.save();
  }

  // Function to capture screenshot of a widget

  Future<Uint8List> _captureWidget(BuildContext context) async {
    RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> generateNewPdf(BuildContext context) async {
    final pdf = pw.Document();
    final imageBytes = await _captureWidget(context);

    final pdfImage = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> saveFile(document, String name) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/$name.pdf');

    await file.writeAsBytes(await document.save());
    debugPrint('Saved exported PDF at: ${file.path}');
  }

  Future<Uint8List> convertPdfDocumentToUint8List(
      pw.Document pdfDocument) async {
    Uint8List bytes = await pdfDocument.save();
    return bytes;
  }

  static Future<bool> requestPermission(Permission permission) async {
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

  static Future screenToPdf(String fileName, Uint8List screenShot) async {
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

  static Future<void> getPdf(Uint8List screenShot) async {
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

  static Future<Uint8List> convertDocumentToUint8List(File documentFile) async {
    // Read the file as bytes
    List<int> bytes = await documentFile.readAsBytes();

    // Convert bytes to Uint8List
    Uint8List uint8list = Uint8List.fromList(bytes);

    return uint8list;
  }

  static Future<Uint8List> generatePdf(pw.ImageProvider imageProvider) async {
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
}
