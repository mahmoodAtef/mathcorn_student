import 'package:flutter/material.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OnlinePdfViewerWidget extends StatefulWidget {
  final String pdfUrl;
  final String lectureName;

  const OnlinePdfViewerWidget({
    super.key,
    required this.pdfUrl,
    required this.lectureName,
  });

  @override
  State<OnlinePdfViewerWidget> createState() => _OnlinePdfViewerWidgetState();
}

class _OnlinePdfViewerWidgetState extends State<OnlinePdfViewerWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int currentPage = 1;
  int totalPages = 0;

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenOnlinePdfViewer(
          pdfUrl: widget.pdfUrl,
          lectureName: widget.lectureName,
          initialPage: currentPage - 1,
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    if (hasError) {
      return _buildErrorWidget();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // PDF Header with controls
          _buildPdfHeader(),

          // PDF Viewer
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: SfPdfViewer.network(
                widget.pdfUrl,
                controller: _pdfViewerController,
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                  setState(() {
                    totalPages = details.document.pages.count;
                    isLoading = false;
                  });
                },
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  setState(() {
                    hasError = true;
                    isLoading = false;
                    errorMessage = 'خطأ في تحميل PDF: ${details.error}';
                  });
                },
                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    currentPage = details.newPageNumber;
                  });
                },
                // تخصيص شريط التمرير
                scrollDirection: PdfScrollDirection.vertical,
                pageSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملف PDF',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalPages > 0)
                  Text(
                    'الصفحة $currentPage من $totalPages',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ),
          // Loading indicator
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          // Full Screen Button
          if (!isLoading)
            IconButton(
              onPressed: _openFullScreen,
              icon: Icon(
                Icons.fullscreen,
                color: Theme.of(context).colorScheme.primary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(0.7),
              ),
              tooltip: 'عرض في شاشة كاملة',
            ),
          if (!isLoading) const SizedBox(width: 8),
          if (!isLoading) _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: currentPage > 1 ? _goToPreviousPage : null,
          icon: Icon(
            Icons.keyboard_arrow_right,
            color: currentPage > 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: currentPage < totalPages ? _goToNextPage : null,
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: currentPage < totalPages
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  void _goToNextPage() {
    if (currentPage < totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  Widget _buildErrorWidget({String? customMessage}) {
    return Container(
      height: 40.h,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل ملف PDF',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            customMessage ?? errorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'إعادة المحاولة',
                  icon: Icons.refresh,
                  onPressed: () {
                    setState(() {
                      hasError = false;
                      isLoading = true;
                      errorMessage = '';
                    });
                  },
                  type: ButtonType.outlined,
                  height: 4.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60.h, child: _buildPdfViewer());
  }
}

// Full Screen Online PDF Viewer Widget
class FullScreenOnlinePdfViewer extends StatefulWidget {
  final String pdfUrl;
  final String lectureName;
  final int initialPage;

  const FullScreenOnlinePdfViewer({
    super.key,
    required this.pdfUrl,
    required this.lectureName,
    this.initialPage = 0,
  });

  @override
  State<FullScreenOnlinePdfViewer> createState() =>
      _FullScreenOnlinePdfViewerState();
}

class _FullScreenOnlinePdfViewerState extends State<FullScreenOnlinePdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int currentPage = 1;
  int totalPages = 0;
  bool isControlsVisible = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage + 1;

    // إخفاء الضوابط تلقائياً بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isControlsVisible = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      isControlsVisible = !isControlsVisible;
    });

    // إخفاء الضوابط تلقائياً بعد 3 ثواني
    if (isControlsVisible) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && isControlsVisible) {
          setState(() {
            isControlsVisible = false;
          });
        }
      });
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  void _goToNextPage() {
    if (currentPage < totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: isControlsVisible
          ? AppBar(
              backgroundColor: Colors.black87,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.lectureName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (totalPages > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Text(
                        '$currentPage / $totalPages',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : null,
      body: Stack(
        children: [
          // PDF Viewer
          GestureDetector(
            onTap: _toggleControls,
            child: SfPdfViewer.network(
              widget.pdfUrl,
              controller: _pdfViewerController,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              initialPageNumber: widget.initialPage + 1,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  totalPages = details.document.pages.count;
                  isLoading = false;
                });
              },
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  currentPage = details.newPageNumber;
                });
              },
              scrollDirection: PdfScrollDirection.vertical,
              pageSpacing: 4,
            ),
          ),

          // Loading Indicator
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'جاري تحميل الملف...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Navigation Controls
          if (isControlsVisible && totalPages > 1 && !isLoading)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: currentPage > 1 ? _goToPreviousPage : null,
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: currentPage > 1 ? Colors.white : Colors.grey,
                        size: 30,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'الصفحة $currentPage من $totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages
                          ? _goToNextPage
                          : null,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: currentPage < totalPages
                            ? Colors.white
                            : Colors.grey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
