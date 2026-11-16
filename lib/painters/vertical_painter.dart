import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../engine/vertical_engine.dart';
import '../models/customization.dart';
import '../services/storage_service.dart';

class VerticalCameraTransform {
  final double scale;
  final Offset translation;
  const VerticalCameraTransform(this.scale, this.translation);

  Offset screenToWorld(Offset screen) => (screen - translation) / scale;
}

VerticalCameraTransform computeVerticalCamera(VerticalEngine engine, Size viewport) {
  final spanX = (engine.lightPos.dx - engine.heavyPos.dx).abs() + 420.0;
  final spanY = (engine.lightPos.dy - engine.heavyPos.dy).abs() + 420.0;
  final fitX = viewport.width / math.max(spanX, 560.0);
  final fitY = viewport.height / math.max(spanY, 640.0);
  final scale = math.min(fitX, fitY).clamp(0.42, 1.35);

  final worldW = engine.level.worldSize.width;
  final worldH = engine.level.worldSize.height;
  double cx = engine.camCenter.dx;
  double cy = engine.camCenter.dy;

  final halfW = (viewport.width * 0.5) / scale;
  final halfH = (viewport.height * 0.5) / scale;
  cx = worldW > halfW * 2 ? cx.clamp(halfW, worldW - halfW) : worldW * 0.5;
  cy = worldH > halfH * 2 ? cy.clamp(halfH, worldH - halfH) : worldH * 0.5;

  return VerticalCameraTransform(
    scale,
    Offset(viewport.width * 0.5 - cx * scale, viewport.height * 0.5 - cy * scale),
  );
}

class VerticalPainter extends CustomPainter {
  final VerticalEngine engine;
  VerticalPainter(this.engine) : super(repaint: engine);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = CustomizationCatalog.backgrounds[StorageService.backgroundIndex];
    final lightSkin = CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex];
    final heavySkin = CustomizationCatalog.heavyProfiles[StorageService.heavyProfileIndex];
    final tetherSkin = CustomizationCatalog.tetherStyles[StorageService.tetherStyleIndex];
    final cam = computeVerticalCamera(engine, size);

    // Rising ambient shaft motes
    final motePaint = Paint()..color = bg.accentColor.withValues(alpha: 0.25);
    for (int i = 0; i < 16; i++) {
      final x = (i * 83.7) % size.width;
      final y = size.height - ((engine.animTime * (40 + (i % 4) * 18) + i * 71) % size.height);
      canvas.drawCircle(Offset(x, y), 1.6 + (i % 3), motePaint);
    }

    canvas.save();
    if (engine.shakeIntensity > 0.1) {
      canvas.translate(
        math.sin(engine.animTime * 60) * engine.shakeIntensity,
        math.cos(engine.animTime * 53) * engine.shakeIntensity,
      );
    }
    canvas.translate(cam.translation.dx, cam.translation.dy);
    canvas.scale(cam.scale);

    // 1. Shaft walls & ledges
    for (final b in engine.level.blocks) {
      final rr = RRect.fromRectAndRadius(b.rect, const Radius.circular(8));
      canvas.drawRRect(rr, Paint()..color = bg.platformBodyColor);
      canvas.drawRRect(
        rr,
        Paint()
          ..color = bg.platformTopColor.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // 2. Weight Switch Plates & Hatch Gates
    for (final gate in engine.level.gates) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(gate.switchPlate, const Radius.circular(4)),
        Paint()..color = gate.isOpen ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
      );
      if (!gate.isOpen) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(gate.gateRect, const Radius.circular(6)),
          Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.78),
        );
        canvas.drawLine(
          gate.gateRect.centerLeft,
          gate.gateRect.centerRight,
          Paint()..color = Colors.white..strokeWidth = 2,
        );
      }
    }

    // 3. Steam Jets
    for (final jet in engine.level.steamJets) {
      final active = jet.isActiveAt(engine.elapsedSeconds);
      final warning = jet.isWarningAt(engine.elapsedSeconds);
      if (active) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(jet.zone, const Radius.circular(12)),
          Paint()..color = const Color(0xFFFB7185).withValues(alpha: 0.7),
        );
        for (int i = 0; i < 6; i++) {
          final px = jet.zone.left + ((engine.animTime * 220 + i * 34) % jet.zone.width);
          canvas.drawCircle(Offset(px, jet.zone.center.dy), 7, Paint()..color = Colors.white70);
        }
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(jet.zone, const Radius.circular(12)),
          Paint()
            ..color = (warning ? const Color(0xFFFBBF24) : const Color(0xFF64748B)).withValues(alpha: 0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }

    // 4. Overhead Hoist Anchors
    for (final anchor in engine.level.anchors) {
      final p = anchor.position;
      canvas.drawCircle(p, 26, Paint()..color = lightSkin.glowColor.withValues(alpha: 0.16));
      canvas.drawCircle(
        p,
        14,
        Paint()
          ..color = lightSkin.glowColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      canvas.drawCircle(p, 5, Paint()..color = Colors.white);
    }

    // 5. Exit Portal
    final gc = engine.level.goalZone.center;
    final gr = engine.level.goalZone.width * 0.42 * (1 + 0.08 * math.sin(engine.animTime * 5));
    canvas.drawCircle(gc, gr + 8, Paint()..color = const Color(0xFF34D399).withValues(alpha: 0.25));
    canvas.drawCircle(
      gc,
      gr,
      Paint()
        ..color = const Color(0xFF34D399)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // 6. Energy Cores
    for (final core in engine.cores) {
      if (!core.collected) {
        final bob = math.sin(engine.animTime * 4 + core.position.dy * 0.02) * 4;
        final p = core.position + Offset(0, bob);
        canvas.drawCircle(p, 15, Paint()..color = const Color(0xFFFBBF24).withValues(alpha: 0.25));
        canvas.drawCircle(p, 8, Paint()..color = const Color(0xFFFBBF24));
        canvas.drawCircle(p, 8, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.6);
      }
    }

    // 7. Hoist Cable
    _drawTether(canvas, engine.lightPos, engine.heavyPos, tetherSkin, engine.currentTension, engine.lightAnchored);

    // 8. Aiming Drag Preview
    if (engine.dragAimStart != null && engine.dragAimCurrent != null) {
      final d = engine.dragAimStart! - engine.dragAimCurrent!;
      if (d.distance > 12) {
        final dir = d / d.distance;
        final spd = (d.distance * 5.2).clamp(320.0, 720.0);
        final v0 = Offset(dir.dx * spd, dir.dy * spd);
        for (int i = 1; i <= 8; i++) {
          final t = i * 0.06;
          final pt = engine.lightPos + v0 * t + Offset(0, 0.5 * VerticalEngine.gravity * t * t);
          canvas.drawCircle(pt, 3.5, Paint()..color = lightSkin.glowColor.withValues(alpha: 0.8));
        }
      }
    }

    // 9. Characters
    _drawHeavy(canvas, engine.heavyPos, heavySkin, engine.heavyFacing, engine.activeChar == ActiveCharacter.heavy && !engine.twoPlayerMode);
    _drawLight(canvas, engine.lightPos, lightSkin, engine.lightFacing, engine.lightBoostHeld, engine.lightAnchored, engine.activeChar == ActiveCharacter.light && !engine.twoPlayerMode);

    for (final p in engine.particles) {
      final a = (p.life / p.maxLife).clamp(0.0, 1.0);
      canvas.drawCircle(p.pos, p.radius * a, Paint()..color = p.color.withValues(alpha: a));
    }

    canvas.restore();
  }

  void _drawTether(Canvas canvas, Offset a, Offset b, TetherStyleOption style, double tension, bool anchored) {
    final c = tension > 0.9 ? const Color(0xFFFB7185) : style.primaryColor;
    canvas.drawLine(a, b, Paint()..color = c.withValues(alpha: anchored ? 0.36 : 0.18)..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawLine(a, b, Paint()..color = c..strokeWidth = 3.2..strokeCap = StrokeCap.round);
    final dist = (b - a).distance;
    final steps = math.max(3, (dist / 26).floor());
    for (int i = 1; i < steps; i++) {
      final t = ((i / steps) - (anchored ? engine.animTime * 0.7 : 0)) % 1.0;
      final pt = Offset.lerp(a, b, t < 0 ? t + 1 : t)!;
      canvas.drawCircle(pt, 2.8, Paint()..color = style.pulseColor);
    }
  }

  void _drawLight(Canvas canvas, Offset pos, LightProfile skin, double facing, bool boosting, bool anchored, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (selected) {
      canvas.drawCircle(Offset.zero, 23, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    if (boosting && !anchored) {
      canvas.drawCircle(const Offset(0, 14), 7, Paint()..color = skin.glowColor.withValues(alpha: 0.8));
    }
    if (anchored) {
      final p = Paint()..color = skin.glowColor..strokeWidth = 3;
      canvas.drawLine(const Offset(-14, -8), Offset.zero, p);
      canvas.drawLine(const Offset(14, -8), Offset.zero, p);
    }
    canvas.drawCircle(Offset.zero, VerticalEngine.lightRadius, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset.zero, VerticalEngine.lightRadius, Paint()..color = skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(facing * 4, -2), width: 13, height: 7), const Radius.circular(3)), Paint()..color = skin.glowColor);
    canvas.restore();
  }

  void _drawHeavy(Canvas canvas, Offset pos, HeavyProfile skin, double facing, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (selected) {
      canvas.drawCircle(Offset.zero, 30, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    canvas.drawCircle(Offset.zero, VerticalEngine.heavyRadius, Paint()..color = const Color(0xFF1E293B));
    canvas.drawCircle(Offset.zero, VerticalEngine.heavyRadius, Paint()..color = skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 4);
    canvas.drawCircle(const Offset(-17, -4), 7, Paint()..color = skin.primaryColor);
    canvas.drawCircle(const Offset(17, -4), 7, Paint()..color = skin.primaryColor);
    canvas.drawCircle(Offset(facing * 3 - 4, -5), 2.5, Paint()..color = skin.glowColor);
    canvas.drawCircle(Offset(facing * 3 + 4, -5), 2.5, Paint()..color = skin.glowColor);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant VerticalPainter oldDelegate) => true;
}
