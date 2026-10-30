import 'package:flutter/material.dart';

/// Example: Dashboard Stats
///
/// Kết hợp Wrap (các thẻ thống kê tự xuống dòng khi hẹp) với 1 ListView
/// ngang (scrollDirection: Axis.horizontal) cho danh sách "hoạt động gần
/// đây", thể hiện cách phối hợp nhiều widget layout trong 1 màn hình thật.
class DashboardStatsExample extends StatelessWidget {
  const DashboardStatsExample({super.key});

  static const _stats = [
    (
      icon: Icons.people_outline,
      label: 'Người dùng',
      value: '1,204',
      color: Colors.deepPurple,
    ),
    (
      icon: Icons.shopping_cart_outlined,
      label: 'Đơn hàng',
      value: '328',
      color: Colors.teal,
    ),
    (
      icon: Icons.attach_money,
      label: 'Doanh thu',
      value: '45.2M',
      color: Colors.orange,
    ),
    (
      icon: Icons.trending_up,
      label: 'Tăng trưởng',
      value: '+12%',
      color: Colors.blue,
    ),
  ];

  static const _activities = [
    'Đơn hàng #1023 đã được tạo',
    'Người dùng mới đăng ký',
    'Thanh toán #998 thành công',
    'Sản phẩm "Tai nghe" hết hàng',
    'Đơn hàng #1021 đã giao',
  ];

  Widget _statCard(
    ({IconData icon, String label, String value, Color color}) s,
  ) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: s.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(s.icon, color: s.color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            s.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            s.label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tổng quan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _stats.map(_statCard).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _activities.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 220,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          Icons.notifications,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _activities[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
