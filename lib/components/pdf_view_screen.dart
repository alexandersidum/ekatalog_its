import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PdfScreen extends StatelessWidget {
  final String path;
  PdfScreen({this.path});

  @override
  Widget build(BuildContext context) {
    print(path);
    return PDFViewerScaffold(path: path);
  }
}
