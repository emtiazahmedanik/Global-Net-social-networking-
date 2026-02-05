import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/feature/analytics/controller/keymatrix_controller.dart';
// post_views_chart_controller removed in favor of API-driven ChartFunctionController
import 'package:jdadzok/feature/analytics/widgets/key_matrix_card_widget.dart';
import 'package:jdadzok/feature/analytics/widgets/key_matrix_chart_widget.dart';
import 'package:jdadzok/feature/analytics/widgets/key_matrix_widget.dart';



import 'package:jdadzok/feature/analytics/widgets/monetization_widget.dart';


import 'package:jdadzok/feature/account_preferences/common_widget/reward_balance_card.dart';


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(KeymatrixController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: 80),

                      Text(
                        'SpectraSync Analytics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff111827),
                        ),
                      ),
                    ],
                  ),
                ),

                MonetizationWidget(),
                SizedBox(height: 12),
                RewardsBalanceCards(),
                SizedBox(height: 12),
                KeymatrixWidget(),
                SizedBox(height: 12),
                KeymatrixCardWidget(),
                SizedBox(height: 12),
                KeyMatrixChartWidget(),
                // PostViewsWidget(),
                SizedBox(height: 12),
                // Post views chart (temporarily hidden per request)
                // SizedBox(height: 280, child: PostviewsChartWidget()),
                // SizedBox(height: 12),
                // MarketplaceWidget(),
                // SizedBox(height: 12),
                // MarketplaceCardWidget(),
                // SizedBox(height: 12),
                // SalesChartButtonWidget(),

                // SizedBox(height: 280, child: VerticalRectangleChart()),

                // SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
