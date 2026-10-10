import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Dashboard Stats Starter', size: Size(400, 600))
Widget previewDashboardStatsStarter() => const DashboardStatsStarter();

/// 🎯 CODE MỒI: Dashboard Stats
///
/// Dữ liệu mẫu (_stats, _activities) đã có sẵn. Code phần UI để ra kết quả
/// giống "Kết quả mẫu": khu vực "Tổng quan" gồm các thẻ thống kê tự xuống
/// dòng khi hẹp (Wrap), và khu vực "Hoạt động gần đây" là 1 danh sách cuộn
/// ngang các thẻ nhỏ (ListView ngang).
class DashboardStatsStarter extends StatelessWidget {
  const DashboardStatsStarter({super.key});

  static const _stats = [
    (icon: Icons.people_outline, label: 'Người dùng', value: '1,204', color: Colors.deepPurple),
    (icon: Icons.shopping_cart_outlined, label: 'Đơn hàng', value: '328', color: Colors.teal),
    (icon: Icons.attach_money, label: 'Doanh thu', value: '45.2M', color: Colors.orange),
    (icon: Icons.trending_up, label: 'Tăng trưởng', value: '+12%', color: Colors.blue),
  ];

  static const _activities = [
    'Đơn hàng #1023 đã được tạo',
    'Người dùng mới đăng ký',
    'Thanh toán #998 thành công',
    'Sản phẩm "Tai nghe" hết hàng',
    'Đơn hàng #1021 đã giao',
  ];

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
          // TODO 1: Wrap(spacing, runSpacing) render các thẻ thống kê từ
          // _stats (icon trong box màu nhạt, value to đậm, label xám nhỏ).
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _stats.map((stat) => 
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 120,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: stat.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(stat.icon, color: stat.color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(stat.value, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                      Text(stat.label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                      const SizedBox(height: 8),
                    ],
                  )
                )
              )
            ).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // TODO 2: SizedBox(height: 90) + ListView.separated ngang render
          // từng hoạt động trong _activities (CircleAvatar + Expanded(Text)).
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _activities.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return SizedBox(
                  width: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.yellow,
                        child: Icon(Icons.notifications, color: Colors.black, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          activity,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Text('TODO: ${_activities.length} hoạt động gần đây ở đây'),
        ],
      ),
    );
  }
}
