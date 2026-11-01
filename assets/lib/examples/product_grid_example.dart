import 'package:flutter/material.dart';

/// Example: Product Grid
///
/// Kết hợp GridView.builder (lưới sản phẩm) với mỗi item là 1 Column chứa
/// ảnh (placeholder bằng Container), tên, giá và rating (Row).
class ProductGridExample extends StatelessWidget {
  const ProductGridExample({super.key});

  static const _products = [
    (
      name: 'Tai nghe Bluetooth',
      price: '590.000₫',
      rating: 4.5,
      color: Colors.deepPurple,
    ),
    (
      name: 'Bàn phím cơ',
      price: '1.250.000₫',
      rating: 4.8,
      color: Colors.indigo,
    ),
    (
      name: 'Chuột không dây',
      price: '320.000₫',
      rating: 4.2,
      color: Colors.teal,
    ),
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final p = _products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh placeholder: Expanded để chiếm phần còn lại theo trục
                // chính của Column, tránh phải tính chiều cao cố định.
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: p.color.withValues(alpha: 0.15),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: p.color,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            p.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.price,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
