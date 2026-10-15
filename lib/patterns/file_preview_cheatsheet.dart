import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';
import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) cách XEM/CHỌN file hay gặp: zoom/pan ảnh,
/// xử lý ảnh lỗi/đang tải, xem PDF, và chọn ảnh/file từ máy.
///
/// `InteractiveViewer` là widget BUILT-IN của Flutter nên demo chạy THẬT
/// (tự zoom/pan được). Các phần còn lại (xem PDF, chọn file) cần package
/// ngoài (`pdfx`, `image_picker`...) KHÔNG có trong app demo này - preview
/// chỉ MÔ PHỎNG giao diện/hành vi, code mẫu là code thật cần dùng.
class FilePreviewCheatsheet extends StatelessWidget {
  const FilePreviewCheatsheet({super.key});

  static final _items = <_FileInfo>[
    // ---- Xem ảnh ----
    _FileInfo(
      name: 'InteractiveViewer (zoom/pan ảnh)',
      category: 'Xem ảnh',
      description:
          'Widget BUILT-IN của Flutter cho phép zoom (pinch) + pan (kéo) '
          'BẤT KỲ widget con (thường là `Image`) - KHÔNG cần package '
          'ngoài. `minScale`/`maxScale` giới hạn mức zoom. Demo này zoom '
          'được THẬT - thử kéo chuột/pinch trên vùng xem bên dưới.',
      snippet: '''
InteractiveViewer(
  minScale: 0.5,
  maxScale: 4,
  trackpadScrollCausesScale: true, // cho phép zoom bằng scroll chuột/trackpad
  child: Image.network(url),
)''',
      preview: (_) => const _InteractiveViewerDemo(),
    ),
    _FileInfo(
      name: 'Hero + InteractiveViewer cho xem ảnh full-screen',
      category: 'Xem ảnh',
      description:
          'Pattern phổ biến: bấm vào ảnh nhỏ (thumbnail) trong danh sách '
          '-> mở 1 trang/dialog riêng với ảnh TO + `InteractiveViewer` để '
          'zoom, dùng `Hero` (xem Animation cheat sheet) để ảnh "bay" '
          'mượt từ vị trí thumbnail ra full-screen.',
      snippet: '''
GestureDetector(
  onTap: () => Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'photo-\$id',
          child: InteractiveViewer(child: Image.network(fullSizeUrl)),
        ),
      ),
    ),
  )),
  child: Hero(tag: 'photo-\$id', child: Image.network(thumbnailUrl)),
)''',
      preview: (_) => const _HeroPreviewDemo(),
    ),
    _FileInfo(
      name: 'Image.network: loadingBuilder + errorBuilder',
      category: 'Xem ảnh',
      description:
          '`Image.network` có thể load LỖI (mất mạng, link hỏng, 404) - '
          'dùng `errorBuilder` để hiện icon placeholder "đẹp" thay vì icon '
          'lỗi đỏ xấu mặc định của Flutter. `loadingBuilder` hiện progress '
          'khi ảnh ĐANG tải (dựa vào `progress.cumulativeBytesLoaded`).',
      snippet: '''
Image.network(
  url,
  loadingBuilder: (context, child, progress) =>
      progress == null ? child : const Center(child: CircularProgressIndicator()),
  errorBuilder: (context, error, stackTrace) => const Icon(
    Icons.broken_image,
    color: Colors.grey,
    size: 32,
  ),
)''',
      preview: (_) => const _ImageErrorBuilderDemo(),
    ),
    // ---- Xem tài liệu (PDF) ----
    _FileInfo(
      name: 'Xem PDF (cần package ngoài)',
      category: 'Xem tài liệu (PDF)',
      description:
          'Flutter core KHÔNG tự render được PDF - cần package riêng dùng '
          'bộ render PDF của hệ điều hành, phổ biến nhất là `pdfx` (hoặc '
          '`flutter_pdfview`, `syncfusion_flutter_pdfviewer`). Các package '
          'này đều cho điều hướng trang, zoom, và load từ asset/network/'
          'file local.',
      snippet: '''
final controller = PdfControllerPinch(
  document: PdfDocument.openAsset('assets/sample.pdf'),
);

PdfViewPinch(
  controller: controller,
  onPageChanged: (page) => print('Đang ở trang \$page'),
)''',
      preview: (_) => const _PdfViewerDemo(),
    ),
    // ---- Chọn file từ máy ----
    _FileInfo(
      name: 'Chọn ảnh/file từ máy (image_picker / file_picker)',
      category: 'Chọn file từ máy',
      description:
          'Flutter core KHÔNG có quyền truy cập camera/thư viện ảnh/hệ '
          'thống file trực tiếp - cần `image_picker` (chọn/chụp ảnh) hoặc '
          '`file_picker` (chọn file bất kỳ: PDF, Excel...). Trên mobile '
          'cần khai báo quyền (Info.plist/AndroidManifest), trên web thì '
          'mở dialog chọn file của browser.',
      snippet: '''
final picker = ImagePicker();

Future<void> pickImage() async {
  final file = await picker.pickImage(source: ImageSource.gallery);
  if (file == null) return; // người dùng bấm Hủy
  setState(() => _imagePath = file.path);
}

// Chọn file bất kỳ (PDF, Excel...) bằng file_picker:
final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);''',
      preview: (_) => const _FilePickerDemo(),
    ),
  ];

  static List<String> get _categories =>
      _items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return CategoryFilterScaffold(
      title: 'File preview cheat sheet',
      categories: _categories,
      bodyBuilder: (category) => _FileList(
        items: category == null
            ? _items
            : _items.where((i) => i.category == category).toList(),
      ),
    );
  }
}

class _FileList extends StatelessWidget {
  final List<_FileInfo> items;

  const _FileList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'InteractiveViewer là built-in nên demo zoom/pan chạy THẬT. '
              'Phần xem PDF/chọn file cần package ngoài (không có trong '
              'app demo này) nên preview chỉ mô phỏng giao diện. Lọc theo '
              'nhóm bằng tab ở trên, hoặc xem "Tất cả".',
            ),
          );
        }
        return _FileCard(info: items[index - 1]);
      },
    );
  }
}

class _FileInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;
  final WidgetBuilder preview;

  const _FileInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
    required this.preview,
  });
}

class _FileCard extends StatelessWidget {
  final _FileInfo info;

  const _FileCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(info.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(label: Text(info.category, style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 8),
            Text(info.description, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Text(
              '▶ Xem trực tiếp (bấm/kéo vào demo bên dưới):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(builder: info.preview),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CodePanel(source: info.snippet, error: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Khối "ảnh" giả (gradient + icon) dùng chung cho các demo dưới đây, thay
/// cho Image.network thật để demo chạy được offline.
class _FakePhoto extends StatelessWidget {
  final double size;

  const _FakePhoto({this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.75,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.pink]),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.landscape, color: Colors.white, size: size * 0.3),
    );
  }
}

/// "InteractiveViewer": zoom/pan THẬT trên 1 "ảnh" giả.
class _InteractiveViewerDemo extends StatelessWidget {
  const _InteractiveViewerDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 160,
          height: 110,
          child: ClipRect(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              trackpadScrollCausesScale: true,
              child: const Center(child: _FakePhoto()),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Kéo/pinch (hoặc lăn chuột) để zoom & pan', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

/// "Hero + InteractiveViewer full-screen": bấm thumbnail -> Dialog to hơn,
/// có InteractiveViewer để zoom.
class _HeroPreviewDemo extends StatelessWidget {
  const _HeroPreviewDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => Dialog(
              backgroundColor: Colors.black,
              child: SizedBox(
                width: 260,
                height: 200,
                child: Stack(
                  children: [
                    InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4,
                      child: const Center(child: _FakePhoto(size: 220)),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: const _FakePhoto(size: 70),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Bấm thumbnail để mở full-screen + zoom', style: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

/// "loadingBuilder/errorBuilder": toggle để thấy nhánh lỗi vs nhánh thành
/// công, có trạng thái "đang tải" ở giữa.
class _ImageErrorBuilderDemo extends StatefulWidget {
  const _ImageErrorBuilderDemo();

  @override
  State<_ImageErrorBuilderDemo> createState() => _ImageErrorBuilderDemoState();
}

class _ImageErrorBuilderDemoState extends State<_ImageErrorBuilderDemo> {
  bool _broken = false;
  bool _loading = false;

  Future<void> _reload() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_loading) {
      content = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (_broken) {
      content = Icon(Icons.broken_image, color: Colors.grey.shade500, size: 36);
    } else {
      content = const _FakePhoto(size: 100);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 60, child: Center(child: content)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('URL hỏng:', style: TextStyle(fontSize: 11)),
            Switch(value: _broken, onChanged: (v) => setState(() => _broken = v)),
            OutlinedButton(
              onPressed: _reload,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Tải lại', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }
}

/// "Xem PDF": mô phỏng giao diện xem PDF (trang + điều hướng), không phải
/// PDF thật.
class _PdfViewerDemo extends StatefulWidget {
  const _PdfViewerDemo();

  @override
  State<_PdfViewerDemo> createState() => _PdfViewerDemoState();
}

class _PdfViewerDemoState extends State<_PdfViewerDemo> {
  static const _totalPages = 5;
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 110,
          height: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(height: 4, color: Colors.grey.shade300),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 16,
              onPressed: _page > 1 ? () => setState(() => _page--) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('Trang $_page/$_totalPages', style: const TextStyle(fontSize: 11)),
            IconButton(
              iconSize: 16,
              onPressed: _page < _totalPages ? () => setState(() => _page++) : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}

/// "Chọn ảnh/file từ máy": mô phỏng kết quả sau khi "chọn" xong.
class _FilePickerDemo extends StatefulWidget {
  const _FilePickerDemo();

  @override
  State<_FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<_FilePickerDemo> {
  String? _pickedName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_pickedName != null) ...[
          const _FakePhoto(size: 70),
          const SizedBox(height: 4),
          Text(_pickedName!, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 8),
        ] else
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Chưa chọn ảnh nào', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() => _pickedName = 'anh_${DateTime.now().millisecond}.jpg'),
          icon: const Icon(Icons.photo_library, size: 16),
          label: const Text('Chọn ảnh (giả lập)', style: TextStyle(fontSize: 11)),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
        ),
      ],
    );
  }
}
