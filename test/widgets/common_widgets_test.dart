import 'package:erpeace_app/core/widgets/stat_card.dart';
import 'package:erpeace_app/core/widgets/status_chip.dart';
import 'package:erpeace_app/core/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('StatusChip renders its label', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const StatusChip(
          label: 'Disetujui',
          color: Colors.blue,
          icon: Icons.check_rounded,
        ),
      ),
    );

    expect(find.text('Disetujui'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('UserAvatar shows the initials of the name', (tester) async {
    await tester.pumpWidget(_wrap(const UserAvatar(name: 'Andi Budi')));

    expect(find.text('AB'), findsOneWidget);
  });

  testWidgets('UserAvatar handles a single word name', (tester) async {
    await tester.pumpWidget(_wrap(const UserAvatar(name: 'Budi')));

    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('StatCard renders the metric and reacts to taps', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 200,
          child: StatCard(
            label: 'Nilai stok',
            value: 'Rp 1.000.000',
            caption: '10 produk',
            icon: Icons.warehouse_outlined,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Nilai stok'), findsOneWidget);
    expect(find.text('Rp 1.000.000'), findsOneWidget);
    expect(find.text('10 produk'), findsOneWidget);

    await tester.tap(find.byType(StatCard));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
