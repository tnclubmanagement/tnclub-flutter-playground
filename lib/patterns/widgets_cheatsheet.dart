import 'package:flutter/material.dart';

/// Trang tổng hợp (cheat sheet) dạng BẢNG các widget hay dùng nhất, liệt kê
/// nhanh: hình minh hoạ (render thật), constructor mẫu, dùng để làm gì, và
/// đặc điểm riêng (có padding/margin/background sẵn không, có cuộn được
/// không, cần ancestor gì...) - những thứ hay phải tra lại khi mới học.
///
/// Khác với các cheat sheet khác (chỉ có code mẫu dạng text), trang này
/// RENDER THẬT 1 ví dụ nhỏ cho mỗi widget (cột "Minh hoạ") để thấy ngay hình
/// dạng, không chỉ đọc mô tả.
class WidgetsCheatsheet extends StatelessWidget {
  const WidgetsCheatsheet({super.key});

  static final _rows = <_WidgetInfo>[
    // ---- Layout (sắp xếp vị trí/kích thước) ----
    _WidgetInfo(
      name: 'Container',
      category: 'Layout',
      constructor: 'Container(padding, margin, decoration, child)',
      usage: 'Khung đa năng: vừa trang trí (màu/bo góc/border/đổ bóng) vừa '
          'canh khoảng cách, thường dùng khi cần NHIỀU thứ cùng lúc trên '
          '1 widget.',
      special: 'CÓ padding + margin sẵn. CÓ background (qua color HOẶC '
          'decoration, KHÔNG dùng chung được 2 cái).',
      preview: (_) => Container(
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
        ),
        alignment: Alignment.center,
        child: const Text('Box', style: TextStyle(fontSize: 11)),
      ),
    ),
    _WidgetInfo(
      name: 'Padding',
      category: 'Layout',
      constructor: 'Padding(padding: EdgeInsets.all(8), child: ...)',
      usage: 'Thêm khoảng đệm quanh 1 widget KHÔNG có padding riêng (Text, '
          'Icon, ElevatedButton...).',
      special: 'CHỈ có padding. Không màu/border/margin.',
      preview: (_) => Container(
        color: Colors.orange.shade100,
        padding: const EdgeInsets.all(8),
        child: Container(width: 30, height: 20, color: Colors.deepPurple),
      ),
    ),
    _WidgetInfo(
      name: 'SizedBox',
      category: 'Layout',
      constructor: 'SizedBox(width: 100, height: 40, child: ...)',
      usage: 'Ép kích thước cố định cho child, HOẶC tạo khoảng trống rỗng '
          'thay cho Container rỗng.',
      special: 'Không padding/margin/màu. width/height: double.infinity để '
          'lấp đầy theo trục đó.',
      preview: (_) => Container(
        width: 60,
        height: 32,
        color: Colors.teal.shade200,
        alignment: Alignment.center,
        child: const Text('60x32', style: TextStyle(fontSize: 9)),
      ),
    ),
    _WidgetInfo(
      name: 'Center / Align',
      category: 'Layout',
      constructor: 'Align(alignment: Alignment.topRight, child: ...)',
      usage: 'Canh vị trí child trong không gian cha. Center = canh giữa '
          'cả 2 trục. Align = canh theo Alignment tuỳ chỉnh.',
      special: 'Không padding/màu. Cha phải có kích thước xác định.',
      preview: (_) => Container(
        width: 64,
        height: 44,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: const Align(
          alignment: Alignment.topRight,
          child: _Dot(color: Colors.red),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Row / Column',
      category: 'Layout',
      constructor: 'Row(mainAxisAlignment, crossAxisAlignment, children: [...])',
      usage: 'Sắp nhiều widget theo 1 trục: Row = ngang, Column = dọc. '
          'Widget layout CƠ BẢN nhất.',
      special: 'Không padding/margin/màu. Tràn nếu children vượt quá '
          'không gian -> cần Expanded/Flexible hoặc bọc scroll.',
      preview: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final c in [Colors.red, Colors.green, Colors.blue])
            Container(
              width: 14,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: c.shade200,
            ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'Stack + Positioned',
      category: 'Layout',
      constructor: 'Stack(children: [..., Positioned(top: 0, right: 0, child: ...)])',
      usage: 'Chồng nhiều widget LÊN NHAU (layer), Positioned định vị '
          'tuyệt đối theo top/bottom/left/right.',
      special: 'Mặc định CẮT phần tràn ra ngoài - cần Clip.none nếu muốn '
          'Positioned tràn ra ngoài Stack.',
      preview: (_) => SizedBox(
        width: 60,
        height: 40,
        child: Stack(
          children: [
            Container(color: Colors.blueGrey.shade100),
            const Positioned(top: 2, right: 2, child: _Dot(color: Colors.red, size: 10)),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Expanded / Flexible',
      category: 'Layout',
      constructor: 'Expanded(flex: 1, child: ...)',
      usage: 'CHỈ dùng được làm con trực tiếp của Row/Column. Chiếm hết '
          'khoảng còn lại theo tỉ lệ flex.',
      special: 'Expanded = Flexible(fit: FlexFit.tight).',
      preview: (_) => SizedBox(
        width: 70,
        height: 20,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container(color: Colors.indigo.shade200)),
            Expanded(flex: 2, child: Container(color: Colors.indigo.shade400)),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Wrap',
      category: 'Layout',
      constructor: 'Wrap(spacing: 8, runSpacing: 8, children: [...])',
      usage: 'Giống Row nhưng TỰ XUỐNG DÒNG khi hết chỗ ngang, tránh lỗi '
          'overflow.',
      special: 'spacing = khoảng NGANG cùng dòng, runSpacing = khoảng GIỮA '
          'các dòng.',
      preview: (_) => SizedBox(
        width: 60,
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (var i = 0; i < 6; i++)
              Container(width: 14, height: 14, color: Colors.green.shade200),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Spacer',
      category: 'Layout',
      constructor: 'Spacer(flex: 1)',
      usage: 'Chiếm khoảng trống linh hoạt trong Row/Column để đẩy các '
          'widget khác ra 2 đầu.',
      special: 'Tương đương Expanded(child: SizedBox()).',
      preview: (_) => const SizedBox(
        width: 70,
        height: 16,
        child: Row(
          children: [
            _Dot(color: Colors.blue, size: 12),
            Spacer(),
            _Dot(color: Colors.blue, size: 12),
          ],
        ),
      ),
    ),
    // ---- Cuộn (Scroll) ----
    _WidgetInfo(
      name: 'ListView.builder',
      category: 'Cuộn (Scroll)',
      constructor: 'ListView.builder(itemCount: n, itemBuilder: (ctx, i) => ...)',
      usage: 'Danh sách CUỘN được, builder chỉ tạo widget cho item ĐANG '
          'HIỂN THỊ (lazy) - hiệu quả với list dài.',
      special: 'Tự co hết không gian cha cấp (cần Expanded trong Column).',
      preview: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              width: 70,
              height: 10,
              margin: const EdgeInsets.symmetric(vertical: 1.5),
              color: Colors.grey.shade300,
            ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'GridView.builder',
      category: 'Cuộn (Scroll)',
      constructor: 'GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: ...)',
      usage: 'Lưới item cuộn được, nhiều cột/hàng - thường dùng cho grid '
          'sản phẩm/ảnh.',
      special: 'gridDelegate quyết định số cột (fixed) hoặc kích thước tối '
          'đa mỗi ô.',
      preview: (_) => SizedBox(
        width: 44,
        height: 44,
        child: GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            for (final c in [Colors.purple, Colors.pink, Colors.amber, Colors.cyan])
              Container(color: c.shade200),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'SingleChildScrollView',
      category: 'Cuộn (Scroll)',
      constructor: 'SingleChildScrollView(child: Column(children: [...]))',
      usage: 'Cho phép CUỘN khi nội dung vượt quá chiều cao màn hình, tránh '
          '"RenderFlex overflowed".',
      special: 'KHÔNG lazy (build hết toàn bộ child 1 lần) - list rất dài '
          'nên dùng ListView.',
      preview: (_) => const Icon(Icons.swap_vert_circle_outlined, size: 32, color: Colors.grey),
    ),
    // ---- Hiển thị nội dung ----
    _WidgetInfo(
      name: 'Text',
      category: 'Hiển thị nội dung',
      constructor: "Text('Nội dung', style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis)",
      usage: 'Hiển thị chữ. maxLines + overflow: ellipsis để cắt "..." khi '
          'chữ dài tràn dòng.',
      special: 'KHÔNG có màu/padding riêng - màu chữ phải nằm trong '
          '`style: TextStyle(color: ...)`.',
      preview: (_) => const Text('Aa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ),
    _WidgetInfo(
      name: 'Icon',
      category: 'Hiển thị nội dung',
      constructor: 'Icon(Icons.favorite, size: 24, color: Colors.red)',
      usage: 'Hiển thị icon có sẵn trong Material Icons.',
      special: 'size/color set trực tiếp trên Icon, không cần style riêng.',
      preview: (_) => const Icon(Icons.favorite, size: 32, color: Colors.red),
    ),
    _WidgetInfo(
      name: 'Image',
      category: 'Hiển thị nội dung',
      constructor: "Image.network(url, fit: BoxFit.cover)",
      usage: 'Hiển thị ảnh từ network/asset/memory/file. `fit` quyết định '
          'ảnh co/cắt thế nào khi khung khác tỉ lệ ảnh gốc.',
      special: 'Cần set width/height nếu không muốn ảnh tự co theo kích '
          'thước gốc.',
      preview: (_) => Container(
        width: 44,
        height: 44,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, color: Colors.white),
      ),
    ),
    _WidgetInfo(
      name: 'CircleAvatar',
      category: 'Hiển thị nội dung',
      constructor: 'CircleAvatar(radius: 32, backgroundImage: NetworkImage(url))',
      usage: 'Avatar tròn - ảnh đại diện user, hoặc fallback hiển thị chữ '
          '(initials) khi chưa có ảnh.',
      special: 'radius quyết định kích thước (đường kính = radius * 2).',
      preview: (_) => const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.deepPurple,
        child: Text('T', style: TextStyle(color: Colors.white)),
      ),
    ),
    _WidgetInfo(
      name: 'Card',
      category: 'Hiển thị nội dung',
      constructor: 'Card(elevation: 2, margin: EdgeInsets.all(8), child: ...)',
      usage: 'Khung "thẻ" Material: nền trắng, bo góc, đổ bóng sẵn - hay '
          'dùng làm item trong list/grid.',
      special: 'CÓ margin mặc định, nhưng KHÔNG CÓ padding sẵn.',
      preview: (_) => const Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        child: SizedBox(width: 60, height: 34),
      ),
    ),
    _WidgetInfo(
      name: 'Divider',
      category: 'Hiển thị nội dung',
      constructor: 'Divider(height: 1, thickness: 1, color: Colors.grey)',
      usage: 'Đường kẻ ngang phân chia nội dung (VerticalDivider = kẻ '
          'dọc).',
      special: '`height` là khoảng không gian TỔNG, độ dày thật là '
          '`thickness`.',
      preview: (_) => const SizedBox(
        width: 70,
        child: Divider(thickness: 2, color: Colors.deepPurple),
      ),
    ),
    // ---- Trang trí / cắt hình ----
    _WidgetInfo(
      name: 'ClipRRect / ClipOval',
      category: 'Trang trí / Cắt hình',
      constructor: 'ClipRRect(borderRadius: BorderRadius.circular(12), child: ...)',
      usage: 'Cắt child theo hình bo góc hoặc tròn/oval - hay dùng bo góc '
          'cho Image (Image không có borderRadius riêng).',
      special: 'Chỉ cắt HIỂN THỊ, không đổi kích thước/layout thật.',
      preview: (_) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(width: 40, height: 40, color: Colors.amber),
      ),
    ),
    _WidgetInfo(
      name: 'DecoratedBox',
      category: 'Trang trí / Cắt hình',
      constructor: 'DecoratedBox(decoration: BoxDecoration(...), child: ...)',
      usage: 'Giống phần "decoration" của Container nhưng KHÔNG có '
          'padding/margin/constraints.',
      special: 'Không padding/margin - chỉ vẽ decoration quanh child.',
      preview: (_) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink, Colors.orange]),
        ),
        child: const SizedBox(width: 56, height: 32),
      ),
    ),
    // ---- Input & tương tác ----
    _WidgetInfo(
      name: 'ElevatedButton / TextButton / OutlinedButton',
      category: 'Input & tương tác',
      constructor: 'ElevatedButton(onPressed: () {}, child: Text("Xác nhận"))',
      usage: 'Nút bấm Material. Elevated = nổi (hành động chính). Text = '
          'phẳng. Outlined = có viền, không nền.',
      special: 'onPressed: null -> nút tự disabled (mờ, không bấm được).',
      preview: (_) => ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: const Text('OK'),
      ),
    ),
    _WidgetInfo(
      name: 'IconButton',
      category: 'Input & tương tác',
      constructor: 'IconButton(icon: Icon(Icons.close), onPressed: () {})',
      usage: 'Nút chỉ chứa icon - có vùng bấm lớn hơn kích thước icon hiển '
          'thị để dễ bấm trên mobile.',
      special: 'Có padding mặc định quanh icon, không cần tự bọc Padding.',
      preview: (_) => IconButton(
        onPressed: () {},
        icon: const Icon(Icons.close),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    ),
    _WidgetInfo(
      name: 'TextField',
      category: 'Input & tương tác',
      constructor: 'TextField(controller: ..., decoration: InputDecoration(labelText: "Email"))',
      usage: 'Ô nhập liệu text. `controller` đọc/set giá trị từ code, '
          '`decoration` set label/hint/icon/viền.',
      special: 'obscureText: true để ẩn chữ. Cần dispose() controller để '
          'tránh leak.',
      preview: (_) => const SizedBox(
        width: 90,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 12),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Checkbox / Switch / Radio',
      category: 'Input & tương tác',
      constructor: 'Checkbox(value: checked, onChanged: (v) => setState(() => checked = v!))',
      usage: 'Chọn boolean/lựa chọn. Checkbox/Switch = on-off. Radio = '
          'chọn 1 trong nhiều (cùng `groupValue`).',
      special: 'Widget "có điều khiển" - PHẢI tự lưu state và cập nhật '
          'trong onChanged.',
      preview: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: true, onChanged: (_) {}),
          Transform.scale(
            scale: 0.8,
            child: Switch(value: true, onChanged: (_) {}),
          ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'GestureDetector / InkWell',
      category: 'Input & tương tác',
      constructor: 'InkWell(onTap: () {}, child: ...)',
      usage: 'Bắt cử chỉ chạm cho widget KHÔNG có sẵn onTap (Container, '
          'Text, Image...).',
      special: 'InkWell có hiệu ứng "ripple" nhưng CẦN Material ancestor, '
          'nếu không dùng GestureDetector (không hiệu ứng).',
      preview: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 50,
            height: 30,
            alignment: Alignment.center,
            color: Colors.blue.shade100,
            child: const Text('Tap', style: TextStyle(fontSize: 11)),
          ),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'DropdownButton / DropdownMenu',
      category: 'Input & tương tác',
      constructor: "DropdownButton<String>(value: selected, items: [DropdownMenuItem(value: 'a', child: Text('A'))], onChanged: (v) {})",
      usage: 'Chọn 1 giá trị trong danh sách xổ xuống - hay dùng cho lựa '
          'chọn cố định ít mục (tỉnh/thành, loại tài khoản...). '
          '`DropdownMenu` (Material 3, mới hơn) còn hỗ trợ gõ tìm kiếm.',
      special: 'Widget "có điều khiển" như Checkbox - `value` PHẢI khớp '
          '1 trong các `items`, nếu không sẽ lỗi assertion runtime.',
      preview: (_) => SizedBox(
        width: 70,
        child: DropdownButton<String>(
          isDense: true,
          value: 'A',
          items: const [
            DropdownMenuItem(value: 'A', child: Text('A', style: TextStyle(fontSize: 12))),
            DropdownMenuItem(value: 'B', child: Text('B', style: TextStyle(fontSize: 12))),
          ],
          onChanged: (_) {},
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Slider / RangeSlider',
      category: 'Input & tương tác',
      constructor: 'Slider(value: value, min: 0, max: 100, onChanged: (v) => setState(() => value = v))',
      usage: 'Chọn 1 giá trị số (hoặc 1 khoảng với RangeSlider) bằng cách '
          'kéo thanh trượt - hay dùng cho volume, giá tiền, độ tuổi...',
      special: 'Cần bọc trong widget có chiều rộng xác định (Slider tự '
          'giãn hết chiều ngang khả dụng, lỗi "infinite width" nếu đặt '
          'trong Row không có Expanded).',
      preview: (_) => SizedBox(
        width: 70,
        child: SliderTheme(
          data: SliderThemeData(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: SliderComponentShape.noOverlay,
            trackHeight: 2,
          ),
          child: Slider(value: 0.4, onChanged: (_) {}),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Form + TextFormField (validate)',
      category: 'Input & tương tác',
      constructor: "Form(key: formKey, child: TextFormField(validator: (v) => (v?.isEmpty ?? true) ? 'Bắt buộc' : null))",
      usage: 'Gom nhiều TextFormField thành 1 "form" để validate CÙNG LÚC '
          'khi bấm Submit, thay vì tự kiểm tra từng field riêng lẻ.',
      special: 'Gọi `formKey.currentState!.validate()` để chạy hết '
          'validator - trả `false` và tự hiện `errorText` nếu field nào '
          'sai, không cần tự quản lý state lỗi.',
      preview: (_) => SizedBox(
        width: 90,
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tên',
            errorText: 'Bắt buộc',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'RadioListTile / CheckboxListTile / SwitchListTile',
      category: 'Input & tương tác',
      constructor: "CheckboxListTile(title: Text('Đồng ý'), value: checked, onChanged: (v) {})",
      usage: 'Kết hợp ListTile (title/subtitle/leading) với Checkbox/Radio/'
          'Switch trong 1 widget - cả dòng (không chỉ riêng ô vuông) đều '
          'bấm được để toggle, tiện cho danh sách lựa chọn dài.',
      special: 'Mặc định `controlAffinity` để control ở bên TRÁI khác '
          'Checkbox/Switch thường (ở đâu bạn đặt nó) - đổi qua '
          '`ListTileControlAffinity.trailing` nếu cần control bên phải.',
      preview: (_) => const SizedBox(
        width: 100,
        child: CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text('Đồng ý', style: TextStyle(fontSize: 11)),
          value: true,
          onChanged: null,
        ),
      ),
    ),
    _WidgetInfo(
      name: 'SegmentedButton',
      category: 'Input & tương tác',
      constructor: "SegmentedButton<int>(segments: [ButtonSegment(value: 0, label: Text('A'))], selected: {0}, onSelectionChanged: (s) {})",
      usage: '(Material 3) Nhóm nút chọn 1 (hoặc nhiều, `multiSelectionEnabled: true`) '
          'trong 1 cụm liền nhau - thay thế hiện đại cho nhóm RadioButton '
          'cũ khi chỉ có vài lựa chọn ngắn.',
      special: '`selected` là 1 `Set` (dù chỉ chọn 1) - khác Radio dùng '
          '`groupValue` đơn giá trị.',
      preview: (_) => SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 0, label: Text('A', style: TextStyle(fontSize: 10))),
          ButtonSegment(value: 1, label: Text('B', style: TextStyle(fontSize: 10))),
        ],
        selected: const {0},
        onSelectionChanged: (_) {},
        style: const ButtonStyle(
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 4)),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'showDatePicker / showTimePicker',
      category: 'Input & tương tác',
      constructor: 'showDatePicker(context: context, firstDate: ..., lastDate: ...)',
      usage: 'Mở dialog chọn ngày/giờ chuẩn Material (có sẵn lịch/mặt '
          'đồng hồ) - KHÔNG phải widget mà là HÀM `Future`, gọi trong '
          'callback (vd onPressed) và `await` kết quả người dùng chọn.',
      special: 'Trả về `null` nếu người dùng bấm Hủy/đóng dialog - PHẢI '
          'kiểm tra null trước khi dùng kết quả.',
      preview: (_) => OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.calendar_today, size: 14),
        label: const Text('Chọn ngày', style: TextStyle(fontSize: 10)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Autocomplete',
      category: 'Input & tương tác',
      constructor: 'Autocomplete<String>(optionsBuilder: (v) => allOptions.where((o) => o.contains(v.text)), onSelected: (v) {})',
      usage: 'Ô nhập liệu tự gợi ý (dropdown) các lựa chọn khớp với chữ '
          'đang gõ - hay dùng cho tìm kiếm địa chỉ, tên sản phẩm, username...',
      special: '`optionsBuilder` chạy lại MỖI LẦN người dùng gõ - nên lọc '
          'nhanh (hoặc debounce nếu gọi API) để tránh giật/lag.',
      preview: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search, size: 12, color: Colors.grey),
            SizedBox(width: 4),
            Text('Tìm...', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    ),
    // ---- Input chuyên dụng (DIY / package) ----
    _WidgetInfo(
      name: 'Số điện thoại',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: "TextField(keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly])",
      usage: 'Ô nhập số điện thoại. `keyboardType: TextInputType.phone` chỉ '
          'đổi bàn phím ảo hiện ra (mobile), KHÔNG tự chặn/định dạng số.',
      special: 'Flutter KHÔNG có mask "(012) 345-6789" sẵn - phải tự viết '
          '`TextInputFormatter` (override `formatEditUpdate`) hoặc dùng '
          'package như `mask_text_input_formatter`.',
      preview: (_) => SizedBox(
        width: 100,
        child: TextField(
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration(
            isDense: true,
            prefixIcon: Icon(Icons.phone, size: 16),
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: '090 123 4567'),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Thẻ tín dụng (Credit card)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: 'TextField(inputFormatters: [_CardNumberFormatter()], keyboardType: TextInputType.number)',
      usage: 'Ô nhập số thẻ, cần tự nhóm 4 số 1 lần ("1234 5678 9012 3456") '
          'và thường kèm icon nhận diện loại thẻ (Visa/Master) theo số đầu.',
      special: 'KHÔNG có sẵn trong Flutter - phải viết `TextInputFormatter` '
          'tuỳ chỉnh, hoặc dùng package chuyên dụng (`flutter_credit_card`).',
      preview: (_) => SizedBox(
        width: 110,
        child: TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration(
            isDense: true,
            prefixIcon: Icon(Icons.credit_card, size: 16),
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: '•••• •••• •••• 1234'),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'OTP (mã xác thực)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: 'Row(children: List.generate(6, (i) => SizedBox(width: 36, child: TextField(maxLength: 1, textAlign: TextAlign.center))))',
      usage: 'Nhập mã OTP, mỗi ô 1 số, tự focus sang ô kế tiếp khi gõ xong '
          '(và lùi lại khi xoá/bấm Backspace ở ô rỗng).',
      special: 'KHÔNG có widget OTP sẵn - tự ghép nhiều `TextField` + '
          '`FocusNode` để tự chuyển focus, hoặc dùng package (`pinput`, '
          '`otp_text_field`) cho đỡ tự viết logic focus.',
      preview: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final d in ['1', '2', '3', '4'])
            Container(
              width: 20,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(d, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'showDateRangePicker',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: 'showDateRangePicker(context: context, firstDate: ..., lastDate: ...)',
      usage: 'Chọn 1 KHOẢNG ngày [từ - đến] (vd đặt phòng, lọc báo cáo '
          'theo khoảng thời gian) - khác `showDatePicker` (chỉ 1 ngày).',
      special: 'ĐÃ có sẵn trong Flutter (`material.dart`), không cần '
          'package ngoài - trả về `DateTimeRange?` (null nếu người dùng '
          'bấm Hủy).',
      preview: (_) => OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.date_range, size: 14),
        label: const Text('01/01 - 10/01', style: TextStyle(fontSize: 9)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'ChoiceChip / FilterChip (chọn nhiều)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: "FilterChip(label: Text('Đỏ'), selected: selected.contains('Đỏ'), onSelected: (v) {})",
      usage: 'Chọn 1 (ChoiceChip) hoặc NHIỀU (FilterChip) lựa chọn dạng '
          '"viên thuốc" bấm toggle - hay dùng cho filter/tag sản phẩm, sở '
          'thích, size áo...',
      special: 'ĐÃ có sẵn (Material), không cần package. Khác Checkbox về '
          'hình dạng - tự đổi màu nền + hiện icon check khi `selected`.',
      preview: (_) => Wrap(
        spacing: 4,
        children: [
          FilterChip(
            label: const Text('Đỏ', style: TextStyle(fontSize: 10)),
            selected: true,
            onSelected: (_) {},
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          FilterChip(
            label: const Text('Xanh', style: TextStyle(fontSize: 10)),
            selected: false,
            onSelected: (_) {},
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'Tag input (nhập nhiều tag rời)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: 'Wrap(children: [...tags.map((t) => InputChip(label: Text(t), onDeleted: () {})), SizedBox(width: 80, child: TextField(onSubmitted: ...))])',
      usage: 'Nhập nhiều giá trị rời dạng chip (email người nhận, từ khoá '
          'tìm kiếm...) - gõ xong Enter/dấu phẩy để "chốt" thành 1 chip, '
          'bấm x để xoá.',
      special: 'KHÔNG có widget dựng sẵn - tự ghép `Wrap` + `InputChip` + '
          '`TextField` (lắng nghe `onSubmitted` để convert text -> chip), '
          'hoặc dùng package (`flutter_tags_x`).',
      preview: (_) => Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          InputChip(
            label: const Text('flutter', style: TextStyle(fontSize: 10)),
            onDeleted: () {},
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          InputChip(
            label: const Text('dart', style: TextStyle(fontSize: 10)),
            onDeleted: () {},
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'Rich text editor (kiểu TinyMCE)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: "// Không có sẵn -> QuillEditor.basic(controller: quillController)",
      usage: 'Soạn văn bản có định dạng từng đoạn (đậm/nghiêng/list/màu...) '
          'như TinyMCE/Google Docs - khác `TextField` (chỉ nhập text THUẦN, '
          'không style riêng từng đoạn).',
      special: 'Flutter KHÔNG có WYSIWYG editor built-in - cần package '
          'ngoài, phổ biến nhất là `flutter_quill` (hoặc `super_editor`).',
      preview: (_) => Container(
        width: 110,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.format_bold, size: 12),
                Icon(Icons.format_italic, size: 12),
                Icon(Icons.format_list_bulleted, size: 12),
              ],
            ),
            const SizedBox(height: 3),
            Container(width: 90, height: 3, color: Colors.grey.shade300),
            const SizedBox(height: 2),
            Container(width: 60, height: 3, color: Colors.grey.shade300),
          ],
        ),
      ),
    ),
    _WidgetInfo(
      name: 'Markdown (render, không phải nhập)',
      category: 'Input chuyên dụng (DIY / package)',
      constructor: "// Không có sẵn -> Markdown(data: '# Tiêu đề\\n**đậm**')",
      usage: 'Hiển thị (render) văn bản viết theo cú pháp Markdown '
          '(`# `, `**đậm**`, `- list`...) thành UI có định dạng - khác '
          'rich text editor ở trên (cái đó để SOẠN, cái này chỉ để ĐỌC).',
      special: 'Flutter core không tự parse Markdown - cần package chính '
          'thức `flutter_markdown` (do team flutter.dev duy trì, không '
          'phải 3rd-party lạ).',
      preview: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Tiêu đề', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'chữ '),
                TextSpan(text: 'đậm', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    ),
    // ---- Cấu trúc trang ----
    _WidgetInfo(
      name: 'Scaffold',
      category: 'Cấu trúc trang',
      constructor: 'Scaffold(appBar: AppBar(...), body: ..., floatingActionButton: ...)',
      usage: 'Khung trang chuẩn Material: tự xử lý vị trí AppBar/body/FAB/'
          'BottomNavigationBar/Drawer.',
      special: 'body tự tránh vùng bị AppBar che, nhưng KHÔNG tự tránh '
          'notch/status bar - cần SafeArea.',
      preview: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 70, height: 12, color: Colors.deepPurple),
          Container(width: 70, height: 30, color: Colors.grey.shade200),
        ],
      ),
    ),
    _WidgetInfo(
      name: 'AppBar',
      category: 'Cấu trúc trang',
      constructor: 'AppBar(title: Text("Trang chủ"), actions: [IconButton(...)])',
      usage: 'Thanh tiêu đề trên cùng, dùng làm `appBar:` của Scaffold.',
      special: 'Chiều cao cố định (kToolbarHeight), tự thêm padding tránh '
          'status bar.',
      preview: (_) => Container(
        width: 70,
        height: 18,
        color: Colors.deepPurple,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: const Text(
          'AppBar',
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      ),
    ),
    _WidgetInfo(
      name: 'SafeArea',
      category: 'Cấu trúc trang',
      constructor: 'SafeArea(child: ...)',
      usage: 'Tự thêm padding tránh các vùng "không an toàn" của thiết bị '
          '(notch, status bar, home indicator...).',
      special: 'Chỉ cần bọc NGOÀI CÙNG 1 lần gần root, không cần lồng '
          'nhiều lớp.',
      preview: (_) => const Icon(Icons.phone_iphone, size: 32, color: Colors.grey),
    ),
  ];

  static List<String> get _categories =>
      _rows.map((r) => r.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget cheat sheet'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const Tab(text: 'Tất cả'),
              ..._categories.map((c) => Tab(text: c)),
            ],
          ),
        ),
        body: SelectionArea(
          child: TabBarView(
            children: [
              _WidgetTable(rows: _rows),
              ..._categories.map(
                (c) => _WidgetTable(
                  rows: _rows.where((r) => r.category == c).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WidgetInfo {
  final String name;
  final String category;
  final String constructor;
  final String usage;
  final String special;
  final WidgetBuilder preview;

  const _WidgetInfo({
    required this.name,
    required this.category,
    required this.constructor,
    required this.usage,
    required this.special,
    required this.preview,
  });
}

/// Bảng nhiều cột dùng [Table] (tự tính chiều cao mỗi dòng theo nội dung,
/// không cần tự quản chiều cao như Row thường). Bọc 2 lớp scroll: NGANG khi
/// tổng chiều rộng cột vượt màn hình hẹp, DỌC khi danh sách dài hơn chiều
/// cao khả dụng - thiếu 1 trong 2 là nguyên nhân hay gặp gây
/// "RenderFlex overflowed".
class _WidgetTable extends StatelessWidget {
  final List<_WidgetInfo> rows;

  const _WidgetTable({required this.rows});

  static const _colWidths = <int, TableColumnWidth>{
    0: FixedColumnWidth(96), // Minh hoạ
    1: FixedColumnWidth(170), // Widget
    2: FixedColumnWidth(260), // Constructor mẫu
    3: FixedColumnWidth(260), // Dùng để làm gì
    4: FixedColumnWidth(260), // Đặc điểm riêng
  };

  static const _headers = ['Minh hoạ', 'Widget', 'Constructor mẫu', 'Dùng để làm gì', 'Đặc điểm riêng'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalWidth = _colWidths.values
        .map((w) => (w as FixedColumnWidth).value)
        .reduce((a, b) => a + b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      // Cuộn DỌC - thiếu lớp này thì nội dung dài sẽ bị overflow.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Cuộn NGANG khi màn hình hẹp hơn tổng chiều rộng cột.
        child: Container(
          width: totalWidth,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Table(
            columnWidths: _colWidths,
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: BoxDecoration(color: colorScheme.primaryContainer),
                children: [
                  for (final h in _headers) _cell(context, h, isHeader: true),
                ],
              ),
              for (var i = 0; i < rows.length; i++)
                TableRow(
                  decoration: BoxDecoration(
                    color: i.isEven ? colorScheme.surface : colorScheme.surfaceContainerLow,
                    border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
                  ),
                  children: [
                    _previewCell(context, rows[i].preview),
                    _cell(context, rows[i].name, bold: true),
                    _cell(context, rows[i].constructor, monospace: true),
                    _cell(context, rows[i].usage, muted: true),
                    _cell(context, rows[i].special, muted: true),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    String text, {
    bool isHeader = false,
    bool bold = false,
    bool monospace = false,
    bool muted = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    if (monospace) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.5,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: isHeader
            ? TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer)
            : TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.w600 : null,
                color: muted ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
              ),
      ),
    );
  }

  Widget _previewCell(BuildContext context, WidgetBuilder preview) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: SizedBox(
          width: 80,
          height: 56,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Builder(builder: preview),
          ),
        ),
      ),
    );
  }
}

/// Chấm tròn nhỏ dùng làm "đánh dấu vị trí" trong vài hình minh hoạ
/// (Align/Stack/Spacer) cho gọn, khỏi lặp lại Container(decoration: ...).
class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
