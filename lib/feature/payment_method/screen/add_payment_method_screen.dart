// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdadzok/core/const/icons_path.dart';
import 'package:jdadzok/core/style/global_text_style.dart';
import 'package:jdadzok/feature/payment_method/controller/add_payment_method_screen_controller.dart';
import 'package:jdadzok/theme/app_colors.dart';

// ignore: must_be_immutable
class AddPaymentMethodScreen extends StatelessWidget {
  AddPaymentMethodScreenController addpaymentMethodScreenController = Get.put(
    AddPaymentMethodScreenController(),
  );
  AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(0XFFEFEFEF),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Payment Method",
                    style: globalTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 24),

              // Content Area
              Expanded(
                child: Obx(() {
                  if (addpaymentMethodScreenController
                      .stripeAccountData
                      .value == null) {
                    // No payment methods - show empty state
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Payment Found",
                          style: globalTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "You can add and edit payments during checkout",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFF717171),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 55),
                        GestureDetector(
                          onTap: () {
                            // addpaymentMethodScreenController.addPaymentMethod();
                            addpaymentMethodScreenController
                                .createStripeAccount();
                          },
                          child: Container(
                            height: 184,
                            width: 325,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () =>
                                      addpaymentMethodScreenController
                                          .isLoading
                                          .value
                                      ? CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        )
                                      : Image.asset(
                                          IconsPath.paymentAddIcon,
                                          height: 70,
                                          width: 70,
                                        ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  addpaymentMethodScreenController
                                          .isLoading
                                          .value
                                      ? "Setting up..."
                                      : "Add Payment Method",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Show Stripe account details
                    final accountData = addpaymentMethodScreenController.stripeAccountData.value!;
                    final chargesEnabled = accountData['charges_enabled'] ?? false;
                    final payoutsEnabled = accountData['payouts_enabled'] ?? false;
                    final detailsSubmitted = accountData['details_submitted'] ?? false;
                    final accountType = accountData['type'] ?? 'unknown';
                    final businessType = accountData['business_type'] ?? 'unknown';
                    final capabilities = accountData['capabilities'] ?? {};
                    final balance = accountData['balance'] ?? {};
                    
                    final availableBalance = balance['available'] != null && (balance['available'] as List).isNotEmpty 
                        ? (balance['available'] as List).first['amount'] ?? 0 
                        : 0;
                    final pendingBalance = balance['pending'] != null && (balance['pending'] as List).isNotEmpty 
                        ? (balance['pending'] as List).first['amount'] ?? 0 
                        : 0;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account ID Card
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryColor, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account ID",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SelectableText(
                                  accountData['id'] ?? '',
                                  style: globalTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Account Type & Business Type Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  title: "Account Type",
                                  value: accountType.toUpperCase(),
                                  icon: Icons.business,
                                  bgColor: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  title: "Business Type",
                                  value: businessType.toUpperCase(),
                                  icon: Icons.person,
                                  bgColor: Colors.purple,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Status Cards
                          Text(
                            "Account Status",
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 12),

                          _buildStatusCard(
                            title: "Charges Enabled",
                            isEnabled: chargesEnabled,
                            icon: Icons.credit_card,
                          ),

                          SizedBox(height: 10),

                          _buildStatusCard(
                            title: "Payouts Enabled",
                            isEnabled: payoutsEnabled,
                            icon: Icons.account_balance,
                          ),

                          SizedBox(height: 10),

                          _buildStatusCard(
                            title: "Details Submitted",
                            isEnabled: detailsSubmitted,
                            icon: Icons.description,
                          ),

                          SizedBox(height: 20),

                          // Capabilities
                          Text(
                            "Capabilities",
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _buildCapabilityCard(
                                  title: "Card Payments",
                                  status: capabilities['card_payments'] ?? 'inactive',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildCapabilityCard(
                                  title: "Transfers",
                                  status: capabilities['transfers'] ?? 'inactive',
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Balance Information
                          Text(
                            "Balance",
                            style: globalTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _buildBalanceCard(
                                  title: "Available",
                                  amount: availableBalance,
                                  bgColor: Colors.green,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildBalanceCard(
                                  title: "Pending",
                                  amount: pendingBalance,
                                  bgColor: Colors.orange,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30),
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> paymentMethod) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: paymentMethod['isDefault'] == true
              ? AppColors.primaryColor
              : Colors.grey.shade300,
          width: paymentMethod['isDefault'] == true ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Card Icon
          Container(
            width: 50,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.credit_card,
              color: Colors.blue.shade700,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          // Card Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addpaymentMethodScreenController.getCardInfo(paymentMethod),
                  style: globalTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Expires ${paymentMethod['expMonth']}/${paymentMethod['expYear']}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                if (paymentMethod['isDefault'] == true)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Default",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Actions
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
            itemBuilder: (context) => [
              if (paymentMethod['isDefault'] != true)
                PopupMenuItem(
                  value: 'default',
                  child: Row(
                    children: [
                      Icon(Icons.star_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Set as Default'),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remove', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'default') {
                addpaymentMethodScreenController.setDefaultPaymentMethod(
                  paymentMethod['id'],
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(paymentMethod['id']);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String paymentMethodId) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove this payment method?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              addpaymentMethodScreenController.removePaymentMethod(
                paymentMethodId,
              );
            },
            child: Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Build info card widget
  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: bgColor, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: globalTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: bgColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Build status card widget
  Widget _buildStatusCard({
    required String title,
    required bool isEnabled,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEnabled 
            ? Colors.green.withValues(alpha: 0.1) 
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isEnabled ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: globalTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isEnabled 
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEnabled ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: isEnabled ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build capability card widget
  Widget _buildCapabilityCard({
    required String title,
    required String status,
  }) {
    final isActive = status == 'active';
    final isPending = status == 'pending';
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.green.withValues(alpha: 0.1)
            : isPending
                ? Colors.orange.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive 
              ? Colors.green
              : isPending
                  ? Colors.orange
                  : Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.green.withValues(alpha: 0.2)
                  : isPending
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: isActive 
                    ? Colors.green
                    : isPending
                        ? Colors.orange
                        : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build balance card widget
  Widget _buildBalanceCard({
    required String title,
    required int amount,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: bgColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$${(amount / 100).toStringAsFixed(2)}',
            style: globalTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: bgColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'USD',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

