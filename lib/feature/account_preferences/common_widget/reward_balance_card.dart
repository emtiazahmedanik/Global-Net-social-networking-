import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/user_metrics_controller.dart';
import 'package:jdadzok/feature/withdraw/screen/withdraw_request_screen.dart';

class RewardsBalanceCards extends StatelessWidget {
  const RewardsBalanceCards({super.key});

  @override
  Widget build(BuildContext context) {
    // use UserMetricsController to fetch earnings
    final userMetrics = Get.put(UserMetricsController());

    return Obx(
      () => Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _InfoCard(
                height: 150,
                // Estimated rewards: currentMonthEarnings
                title: '\$${userMetrics.currentMonthEarnings.value.toStringAsFixed(2)}',
                subtitle: 'Estimated rewards',
                bottomWidget: Obx(
                  () => PopupMenuButton<String>(
                    onSelected: (value) {
                      // for now keep old behavior or no-op; you can wire it to re-fetch with range
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: '7d', child: Text('7d')),

                      PopupMenuItem(value: '15d', child: Text('15d')),

                      PopupMenuItem(value: '30d', child: Text('30d')),

                      PopupMenuItem(value: '60d', child: Text('60d')),

                      PopupMenuItem(value: '90d', child: Text('90d')),

                      PopupMenuItem(value: '1y', child: Text('1y')),

                      PopupMenuItem(value: 'All', child: Text('All')),
                    ],
                    child: Row(
                      children: [
                        Icon(
                          userMetrics.currentMonthEarnings.value >= 0 ? Icons.trending_up : Icons.trending_down,
                          color: userMetrics.currentMonthEarnings.value >= 0 ? Colors.green : Colors.red,
                          size: 14,
                        ),

                        SizedBox(width: 4),
                        Text(
                          '${userMetrics.currentMonthEarnings.value >= 0 ? '+' : '-'}${(userMetrics.currentMonthEarnings.value).abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: userMetrics.currentMonthEarnings.value >= 0 ? Colors.green : Colors.red,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(width: 5),
                        Text(
                          '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),

                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: _InfoCard(
                height: 150,
                title: '\$${Get.find<UserMetricsController>().totalEarnings.value.toStringAsFixed(2)}',
                subtitle: 'Current balance',
                bottomWidget: OutlinedButton(
                  onPressed: () {
                    // navigate to Withdraw screen
                    // lazy import to avoid cycles
                    Get.to(() => WithdrawRequestScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, 32),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Withdraw',
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget bottomWidget;
  final int height;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.bottomWidget,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey)),
          SizedBox(height: 12),
          bottomWidget,
        ],
      ),
    );
  }
}
