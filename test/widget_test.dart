import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vertical_ascent/engine/vertical_engine.dart';
import 'package:vertical_ascent/main.dart';
import 'package:vertical_ascent/models/customization.dart';
import 'package:vertical_ascent/models/levels.dart';

void main() {
  test('Customization catalog provides 4 options per selection', () {
    expect(CustomizationCatalog.lightProfiles.length, 4);
    expect(CustomizationCatalog.heavyProfiles.length, 4);
    expect(CustomizationCatalog.backgrounds.length, 4);
    expect(CustomizationCatalog.tetherStyles.length, 4);
    expect(CustomizationCatalog.pilotBadges.length, 4);
  });

  test('Vertical Ascent launches Light up shaft, anchors high, and hauls Heavy upward', () {
    final levels = VerticalLevels.buildAll();
    expect(levels.length, 6);
    final engine = VerticalEngine(initialLevelIndex: 0);

    final startHeavyY = engine.heavyPos.dy;
    final startLightY = engine.lightPos.dy;
    engine.launchLight();
    for (int i = 0; i < 40; i++) {
      engine.step(0.016);
    }
    expect(engine.lightPos.dy, lessThan(startLightY - 120));

    // Anchor at overhead hoist ring and haul Heavy upward like an elevator
    engine.lightPos = engine.level.anchors.first.position;
    engine.toggleLightAnchor();
    expect(engine.lightAnchored, isTrue);

    engine.heavyHaulUp = true;
    for (int i = 0; i < 120; i++) {
      engine.step(0.016);
    }
    expect(engine.heavyPos.dy, lessThan(startHeavyY - 80));
    expect(engine.isFailed, isFalse);
  });

  testWidgets('Vertical Ascent HomeScreen renders title, customization, and levels', (tester) async {
    await tester.pumpWidget(const VerticalAscentApp());
    await tester.pumpAndSettle();

    expect(find.text('VERTICAL ASCENT'), findsOneWidget);
    expect(find.text('Starter Chimney'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(4));
  });
}
