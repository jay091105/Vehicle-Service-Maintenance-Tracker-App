import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vehicle_service_tracker/app/app.dart';

void main() {
  testWidgets('App shows service tracker title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: VehicleServiceTrackerApp()),
    );

    expect(find.text('Vehicle Service Tracker'), findsOneWidget);
    expect(find.text('Add Service'), findsOneWidget);
  });
}
