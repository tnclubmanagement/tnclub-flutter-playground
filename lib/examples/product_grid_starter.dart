import 'package:flutter/material.dart';

/// 🎯 CODE MỒI: Product Grid
///
/// Danh sách sản phẩm mẫu đã có sẵn bên dưới. Việc của bạn là code
/// `itemBuilder` để ra lưới 2 cột giống "Kết quả mẫu": mỗi item gồm ảnh
/// (placeholder màu), tên sản phẩm (1 dòng, ellipsis), rating (sao + số),
/// và giá.
class ProductGridStarter extends StatelessWidget {
  const ProductGridStarter({super.key});

  static const _products = [
    (name: 'Tai nghe Bluetooth', price: '590.000₫', rating: 4.5, color: Colors.deepPurple),
    (name: 'Bàn phím cơ', price: '1.250.000₫', rating: 4.8, color: Colors.indigo),
    (name: 'Chuột không dây', price: '320.000₫', rating: 4.2, color: Colors.teal),
    (name: 'Loa mini', price: '450.000₫', rating: 4.0, color: Colors.orange),
    (name: 'Webcam HD', price: '690.000₫', rating: 4.6, color: Colors.pink),
    (name: 'Sạc dự phòng', price: '399.000₫', rating: 4.3, color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _products.length,
        // TODO 1: Khai báo gridDelegate (SliverGridDelegateWithFixedCrossAxisCount,
        // crossAxisCount: 2, mainAxisSpacing/crossAxisSpacing, childAspectRatio).
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final p = _products[index];
          // TODO 2: Dựng card cho từng sản phẩm:
          // - Container bo góc, nền trắng, đổ bóng nhẹ.
          // - Phần ảnh placeholder (Expanded + Container màu p.color).
          // - Tên p.name (maxLines: 1, overflow: ellipsis).
          // - Rating: Icon(Icons.star) + Text(p.rating).
          // - Giá p.price.
          return Container(
            color: p.color.withValues(alpha: 0.15),
            alignment: Alignment.center,
            child: const Text('TODO'),
          );
        },
      ),
    );
  }
}
