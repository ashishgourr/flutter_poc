import 'package:flutter/services.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:web_poc/screens/examples/dashboard.dart';
import 'package:web_poc/utils/common.dart';

class ScreenShotScreen extends StatefulWidget {
  const ScreenShotScreen({
    super.key,
  });

  @override
  _ScreenShotScreenState createState() => _ScreenShotScreenState();
}

class _ScreenShotScreenState extends State<ScreenShotScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  FocusNode focusNode = FocusNode();
  final ExportDelegate exportDelegate = ExportDelegate();

  final GlobalKey<_ScreenShotScreenState> key = GlobalKey();

  List<Uint8List> capturedImages = [];

  @override
  void initState() {
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: KeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) async {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyP) {
              //-- RepaintBoundary solution--//

              // Uint8List pdfBytes = await generateNewPdf(context);

              // final blob = html.Blob([pdfBytes], 'application/pdf');
              // final url = html.Url.createObjectUrlFromBlob(blob);
              // final anchor = html.AnchorElement()
              //   ..href = url
              //   ..download = 'document.pdf'
              //   ..style.display = 'none'
              //   ..target = '_blank';
              // html.document.body?.children.add(anchor);
              // anchor.click();
              // html.Url.revokeObjectUrl(url);

              //  savePdfToGallery(pdfBytes);

              //--Screenshot solution--//

              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((capturedImage) async {
                setState(() {
                  capturedImages.add(capturedImage!);
                });
                //  showCapturedWidget(context, capturedImage!);

                //  CommonUtils.savePdfToGallery(capturedImage!);
              }).catchError((onError) {
                print(onError);
              });
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                saveMultiplePdfToGallery(capturedImages);
                print("Generate PDF");
              },
              child: const Text("Welcome to Dashboard"),
            ),
          ),
          body: Center(
            child: Screenshot(
              controller: screenshotController,
              child: const DashboardScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveMultiplePdfToGallery(List<Uint8List> capturedImages) async {
    final pdfData = await CommonUtils.generateMultiplePdf(capturedImages);

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
    }
  }
}

KeyEventResult handleKeyEvent(KeyEvent keyEvent) {
  if (HardwareKeyboard.instance.isControlPressed ||
      HardwareKeyboard.instance.isShiftPressed ||
      HardwareKeyboard.instance.isAltPressed ||
      HardwareKeyboard.instance.isMetaPressed) {
    print('Modifier pressed: $keyEvent');
  }
  if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyA)) {
    print('Key A pressed.');
  }
  return KeyEventResult.ignored;
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
