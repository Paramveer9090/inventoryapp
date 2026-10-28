import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:true_leaf_inventory_app/app/widgets/app_button.dart';

void main() {
  testWidgets('provides button semantics, feedback, and a 48px tap target',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                title: 'Continue',
                onTap: () => taps++,
              ),
            ),
          ),
        ),
      ),
    );

    final semanticsHandle = tester.ensureSemantics();
    final buttonSemantics = tester.getSemantics(find.byType(AppButton));
    expect(buttonSemantics.label, 'Continue');
    expect(buttonSemantics.flagsCollection.isButton, isTrue);
    expect(buttonSemantics.flagsCollection.isEnabled, isTrue);
    expect(
      tester
          .getSize(find.descendant(
            of: find.byType(AppButton),
            matching: find.byType(InkWell),
          ))
          .height,
      greaterThanOrEqualTo(48),
    );

    await tester.tap(find.text('Continue'));
    expect(taps, 1);
    semanticsHandle.dispose();
  });
}
