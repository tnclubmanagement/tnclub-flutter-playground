import 'package:flutter/material.dart';
// import 'package:flutter/widget_previews.dart';

// @Preview(name: 'Product Grid Starter', size: Size(400, 600))
// Widget previewProductGridStarter() => const ProductGridStarter();

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
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
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
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: p.color,
                    alignment: Alignment.center,
                    child: const Icon(Icons.shopping_bag, size: 48, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${p.rating}'),
                        ],
                      ),
                      Text(p.price),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
