import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadPdf extends StatefulWidget {
  const ReadPdf({Key? key, required this.title,  required this.pdf}) : super(key: key);
  final String pdf;
  final String title;
  @override
  _ReadPdfState createState() => _ReadPdfState();
}

class _ReadPdfState extends State<ReadPdf> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerStateKey.currentState?.openBookmarkView();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.zoom_in,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.zoomLevel = 1.5;
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdf,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        enableDocumentLinkAnnotation: false,
        controller: _pdfViewerController,
        key: _pdfViewerStateKey,
      ),
    );
  }
}

