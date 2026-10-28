import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:true_leaf_inventory_app/app/models/report_model.dart';
import 'package:true_leaf_inventory_app/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:true_leaf_inventory_app/app/modules/dashboard/widgets/recent_orders_card.dart';

void main() {
  testWidgets('handles missing and malformed due dates and missing payment',
      (tester) async {
    final controller = DashboardController()
      ..myOrderList = [
        Orders(dueDate: null),
        Orders(dueDate: 'not-a-date'),
        Orders(dueDate: DateTime.now().toIso8601String()),
        Orders(
          dueDate: 'not-a-date',
          payment: Payment(paymentStatus: '1'),
        ),
      ];

    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [RecentOrdersCard(controller: controller)],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Due date unavailable'), findsNWidgets(2));
    expect(find.text('0 days left'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
  });
}
