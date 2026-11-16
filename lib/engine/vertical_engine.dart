import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/customization.dart';
import '../models/game_models.dart';
import '../models/levels.dart';
import '../services/storage_service.dart';

enum ActiveCharacter { light, heavy }

class VerticalEngine extends ChangeNotifier {
  static const double gravity = 860.0;
  static const double lightRadius = 15.0;
  static const double heavyRadius = 23.0;

  late List<VerticalLevelDefinition> _levels;
  late VerticalLevelDefinition level;
  int currentLevelIndex = 0;

  Offset lightPos = Offset.zero;
  Offset lightVel = Offset.zero;
  bool lightGrounded = false;
  int lightWallDir = 0; // -1 touching right wall (push left), +1 touching left wall (push right)
  bool lightAnchored = false;
  double lightFacing = 1.0;

  Offset heavyPos = Offset.zero;
  Offset heavyVel = Offset.zero;
  bool heavyGrounded = false;
  double heavyFacing = 1.0;

  double ropeLength = 260.0;
  double currentTension = 0.0;
  double lightBoostFuel = 1.0;

  ActiveCharacter activeChar = ActiveCharacter.light;
  bool twoPlayerMode = StorageService.twoPlayerMode;

  double lightMoveInput = 0.0;
  bool lightBoostHeld = false;
  double heavyMoveInput = 0.0;
  bool heavyHaulUp = false;
  bool heavyLowerDown = false;

  Offset? dragAimStart;
  Offset? dragAimCurrent;

  List<EnergyCore> cores = [];
  List<Particle> particles = [];
  double elapsedSeconds = 0.0;
  double animTime = 0.0;
  double shakeIntensity = 0.0;
  String statusBanner = '';
  double bannerTimer = 4.0;

  bool isLevelComplete = false;
  bool isFailed = false;
  String failReason = '';
  int earnedStars = 0;

  Offset camCenter = const Offset(350, 900);

  VerticalEngine({int initialLevelIndex = 0}) {
    _levels = VerticalLevels.buildAll();
    loadLevel(initialLevelIndex);
  }

  void loadLevel(int index) {
    _levels = VerticalLevels.buildAll();
    currentLevelIndex = index.clamp(0, _levels.length - 1);
    level = _levels[currentLevelIndex];

    lightPos = level.lightSpawn;
    lightVel = Offset.zero;
    lightGrounded = false;
    lightWallDir = 0;
    lightAnchored = false;
    lightFacing = 1.0;
    lightBoostFuel = 1.0;

    heavyPos = level.heavySpawn;
    heavyVel = Offset.zero;
    heavyGrounded = false;
    heavyFacing = 1.0;

    ropeLength = 280.0;
    currentTension = 0.0;
    activeChar = ActiveCharacter.light;

    lightMoveInput = 0.0;
    lightBoostHeld = false;
    heavyMoveInput = 0.0;
    heavyHaulUp = false;
    heavyLowerDown = false;
    dragAimStart = null;
    dragAimCurrent = null;

    cores = level.corePositions.map((p) => EnergyCore(p)).toList();
    particles = [];
    elapsedSeconds = 0.0;
    shakeIntensity = 0.0;
    statusBanner = level.hint;
    bannerTimer = 5.0;

    isLevelComplete = false;
    isFailed = false;
    failReason = '';
    earnedStars = 0;

    camCenter = Offset(
      (lightPos.dx + heavyPos.dx) * 0.5,
      (lightPos.dy + heavyPos.dy) * 0.5 - 80,
    );
    notifyListeners();
  }

  void resetLevel() => loadLevel(currentLevelIndex);

  void toggleControlMode() {
    twoPlayerMode = !twoPlayerMode;
    StorageService.twoPlayerMode = twoPlayerMode;
    StorageService.save();
    notifyListeners();
  }

  void swapActiveCharacter() {
    activeChar = activeChar == ActiveCharacter.light
        ? ActiveCharacter.heavy
        : ActiveCharacter.light;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void launchLight() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) {
      lightAnchored = false;
      _showBanner('Hoist Anchor released!');
    }
    if (lightGrounded) {
      lightVel = Offset(lightVel.dx, -640.0);
      lightGrounded = false;
      _spawnBurst(lightPos + const Offset(0, 14), lightColor, 12);
      HapticFeedback.lightImpact();
    } else if (lightWallDir != 0) {
      // Wall-kick inside narrow shaft!
      lightVel = Offset(lightWallDir * 285.0, -585.0);
      lightFacing = lightWallDir.toDouble();
      _spawnBurst(lightPos, lightColor, 10);
      HapticFeedback.lightImpact();
    } else if (lightBoostFuel >= 0.35) {
      // Pneumatic shaft booster burst
      lightBoostFuel = math.max(0.0, lightBoostFuel - 0.35);
      lightVel = Offset(lightVel.dx, math.min(lightVel.dy, -540.0));
      _spawnBurst(lightPos + const Offset(0, 14), lightColor, 10);
      HapticFeedback.lightImpact();
    }
    lightBoostHeld = true;
    notifyListeners();
  }

  void jumpHeavy() {
    if (isLevelComplete || isFailed) return;
    if (heavyGrounded) {
      heavyVel = Offset(heavyVel.dx, -195.0);
      heavyGrounded = false;
      HapticFeedback.lightImpact();
    }
    notifyListeners();
  }

  void toggleLightAnchor() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) {
      lightAnchored = false;
      _showBanner('Elevator Hoist unlocked');
      notifyListeners();
      return;
    }

    HoistAnchorPoint? nearest;
    double bestDist = 66.0;
    for (final anchor in level.anchors) {
      final d = (anchor.position - lightPos).distance;
      if (d < bestDist) {
        bestDist = d;
        nearest = anchor;
      }
    }

    if (nearest != null) {
      lightPos = nearest.position;
      lightVel = Offset.zero;
      lightAnchored = true;
      ropeLength = math.max(90.0, (heavyPos - lightPos).distance);
      _spawnBurst(lightPos, const Color(0xFF38BDF8), 20);
      shakeIntensity = 4.5;
      _showBanner('Locked on ${nearest.label}! Hold HAUL UP to elevate Heavy!');
      if (!twoPlayerMode) activeChar = ActiveCharacter.heavy;
      HapticFeedback.mediumImpact();
    } else if (lightGrounded || lightWallDir != 0) {
      lightVel = Offset.zero;
      lightAnchored = true;
      ropeLength = math.max(90.0, (heavyPos - lightPos).distance);
      _spawnBurst(lightPos, const Color(0xFF38BDF8), 14);
      _showBanner('Shaft clamp locked! Hold HAUL UP to raise Heavy!');
      if (!twoPlayerMode) activeChar = ActiveCharacter.heavy;
      HapticFeedback.mediumImpact();
    } else {
      _showBanner('Launch near a Hoist Ring or shaft wall to anchor!');
    }
    notifyListeners();
  }

  void launchLightFromDrag(Offset worldStart, Offset worldEnd) {
    if (isLevelComplete || isFailed) return;
    final delta = worldStart - worldEnd;
    if (delta.distance < 12) return;
    if (lightAnchored) lightAnchored = false;
    final dir = delta / delta.distance;
    final power = (delta.distance * 5.2).clamp(320.0, 720.0);
    lightVel = Offset(dir.dx * power, dir.dy * power);
    lightGrounded = false;
    lightFacing = lightVel.dx >= 0 ? 1.0 : -1.0;
    _spawnBurst(lightPos, lightColor, 14);
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  Color get lightColor =>
      CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex].primaryColor;

  void _showBanner(String text) {
    statusBanner = text;
    bannerTimer = 3.2;
  }

  void step(double dt) {
    final clampedDt = dt.clamp(0.0, 0.033);
    animTime += clampedDt;
    if (bannerTimer > 0) bannerTimer = math.max(0.0, bannerTimer - clampedDt);
    if (shakeIntensity > 0) shakeIntensity = math.max(0.0, shakeIntensity - clampedDt * 18.0);
    _updateParticles(clampedDt);

    if (isLevelComplete || isFailed) {
      notifyListeners();
      return;
    }
    elapsedSeconds += clampedDt;

    // 1. Update Light Player
    if (!lightAnchored) {
      if (lightGrounded || lightWallDir != 0) {
        lightBoostFuel = math.min(1.0, lightBoostFuel + clampedDt * 1.4);
      }
      final targetVx = lightMoveInput * 255.0;
      if (lightMoveInput.abs() > 0.05) lightFacing = lightMoveInput.sign;
      final accel = lightGrounded ? 15.0 : 8.5;
      double vx = lightVel.dx + (targetVx - lightVel.dx) * math.min(1.0, accel * clampedDt);
      double vy = lightVel.dy + gravity * clampedDt;

      // Active jet-boot boost while climbing shafts
      if (lightBoostHeld && lightBoostFuel > 0.02) {
        vy -= 620.0 * clampedDt;
        vy = math.max(vy, -580.0);
        lightBoostFuel = math.max(0.0, lightBoostFuel - clampedDt * 0.72);
        if ((animTime * 40).floor() % 2 == 0) {
          _spawnParticle(lightPos + const Offset(0, 14), lightColor, 2.8, 0.3);
        }
      }

      // Gentle wall-slide friction inside narrow shafts
      if (lightWallDir != 0 && vy > 90) {
        vy = 90;
      }

      lightVel = Offset(vx, vy);
      lightPos += lightVel * clampedDt;
      _resolveLightCollisions();
    } else {
      lightVel = Offset.zero;
    }

    // 2. Update Heavy Player (Elevator Payload)
    final targetHeavyVx = heavyMoveInput * (heavyGrounded ? 165.0 : 195.0);
    if (heavyMoveInput.abs() > 0.05) heavyFacing = heavyMoveInput.sign;

    heavyVel = Offset(
      heavyVel.dx + (targetHeavyVx - heavyVel.dx) * math.min(1.0, (heavyGrounded ? 12.0 : 5.5) * clampedDt),
      heavyVel.dy + gravity * clampedDt,
    );

    if (lightAnchored && heavyHaulUp) {
      ropeLength = math.max(64.0, ropeLength - 225.0 * clampedDt);
      if ((animTime * 25).floor() % 2 == 0) {
        _spawnParticle(heavyPos - const Offset(0, 18), const Color(0xFF38BDF8), 2.2, 0.25);
      }
    }
    if (lightAnchored && heavyLowerDown) {
      ropeLength = math.min(1150.0, ropeLength + 200.0 * clampedDt);
    }

    heavyPos += heavyVel * clampedDt;
    heavyGrounded = _resolveHeavyCollisions();

    // 3. Elevator Tether Constraint
    final diff = heavyPos - lightPos;
    final dist = diff.distance;
    if (lightAnchored) {
      currentTension = (dist / math.max(1.0, ropeLength)).clamp(0.0, 1.0);
      if (dist > ropeLength && dist > 0.001) {
        final dir = diff / dist;
        heavyPos = lightPos + dir * ropeLength;
        final radialVel = heavyVel.dx * dir.dx + heavyVel.dy * dir.dy;
        if (radialVel > 0) {
          heavyVel = Offset(
            heavyVel.dx - dir.dx * radialVel,
            heavyVel.dy - dir.dy * radialVel,
          );
        }
        if (_resolveHeavyCollisions()) heavyGrounded = true;
      }
    } else {
      // Unanchored long shaft cable so Light can rocket high up the chimney
      const maxUnanchored = 1050.0;
      currentTension = (dist / maxUnanchored).clamp(0.0, 1.0);
      if (dist > maxUnanchored && dist > 0.001) {
        final dir = diff / dist;
        final excess = dist - maxUnanchored;
        lightPos += dir * (excess * 0.75);
      }
    }

    // 4. Weight Switch Gates check (Heavy stepping on switch plate opens hatch)
    for (final gate in level.gates) {
      final plateHit = gate.switchPlate.inflate(16).contains(heavyPos + const Offset(0, heavyRadius * 0.6));
      if (plateHit && !gate.isOpen) {
        gate.isOpen = true;
        shakeIntensity = 5.0;
        _spawnBurst(gate.gateRect.center, const Color(0xFF34D399), 22);
        _showBanner('Upper Shaft Hatch Unlocked!');
        HapticFeedback.mediumImpact();
      }
    }

    // 5. Steam Jet Hazards
    for (final jet in level.steamJets) {
      if (jet.isActiveAt(elapsedSeconds)) {
        if (jet.zone.inflate(lightRadius * 0.7).contains(lightPos)) {
          _triggerFail('Light was hit by a superheated steam burst!');
          return;
        }
        if (jet.zone.inflate(heavyRadius * 0.7).contains(heavyPos)) {
          _triggerFail('Heavy was blasted by a shaft steam jet!');
          return;
        }
      }
    }

    // 6. Energy Cores
    for (final core in cores) {
      if (!core.collected &&
          ((core.position - lightPos).distance < lightRadius + 18 ||
              (core.position - heavyPos).distance < heavyRadius + 18)) {
        core.collected = true;
        _spawnBurst(core.position, const Color(0xFFFBBF24), 16);
        HapticFeedback.lightImpact();
      }
    }

    // 7. Win Condition
    final lightInGoal = level.goalZone.inflate(18).contains(lightPos);
    final heavyInGoal = level.goalZone.inflate(24).contains(heavyPos);
    if (lightInGoal && heavyInGoal) {
      isLevelComplete = true;
      final collectedCount = cores.where((c) => c.collected).length;
      earnedStars = math.max(1, collectedCount);
      if (collectedCount == 3 && elapsedSeconds <= level.parSeconds) earnedStars = 3;
      _spawnBurst(level.goalZone.center, const Color(0xFF34D399), 34);
      shakeIntensity = 6.0;
      _persistWin();
    }

    // 8. Smooth vertical follow camera
    final midX = (lightPos.dx + heavyPos.dx) * 0.5;
    final midY = (lightPos.dy + heavyPos.dy) * 0.5;
    camCenter = Offset(
      camCenter.dx + (midX - camCenter.dx) * math.min(1.0, 5.5 * clampedDt),
      camCenter.dy + (midY - camCenter.dy) * math.min(1.0, 5.5 * clampedDt),
    );
    notifyListeners();
  }

  void _persistWin() {
    final lvl = level.levelNumber;
    final prevStars = StorageService.levelStars[lvl] ?? 0;
    if (earnedStars > prevStars) StorageService.levelStars[lvl] = earnedStars;
    final ms = (elapsedSeconds * 1000).round();
    final prevMs = StorageService.bestTimeMs[lvl];
    if (prevMs == null || ms < prevMs) StorageService.bestTimeMs[lvl] = ms;
    if (lvl >= StorageService.unlockedLevel && lvl < _levels.length) {
      StorageService.unlockedLevel = lvl + 1;
    }
    StorageService.save();
  }

  void _triggerFail(String reason) {
    isFailed = true;
    failReason = reason;
    shakeIntensity = 9.0;
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  void _resolveLightCollisions() {
    var pos = lightPos;
    var vel = lightVel;
    const r = lightRadius;
    bool grounded = false;
    int wallDir = 0;

    final solidRects = <Rect>[
      ...level.blocks.map((b) => b.rect),
      ...level.gates.where((g) => !g.isOpen).map((g) => g.gateRect),
    ];

    for (final rect in solidRects) {
      final closestX = pos.dx.clamp(rect.left, rect.right);
      final closestY = pos.dy.clamp(rect.top, rect.bottom);
      final dx = pos.dx - closestX;
      final dy = pos.dy - closestY;
      final distSq = dx * dx + dy * dy;

      if (distSq < r * r) {
        final dist = math.sqrt(distSq);
        if (dist > 0.0001) {
          final nx = dx / dist;
          final ny = dy / dist;
          pos += Offset(nx * (r - dist), ny * (r - dist));
          final vn = vel.dx * nx + vel.dy * ny;
          if (vn < 0) vel -= Offset(nx * vn, ny * vn);
          if (ny < -0.65) grounded = true;
          if (nx.abs() > 0.7) wallDir = nx > 0 ? 1 : -1;
        } else {
          pos = Offset(pos.dx, rect.top - r);
          if (vel.dy > 0) vel = Offset(vel.dx, 0);
          grounded = true;
        }
      }
    }

    pos = Offset(
      pos.dx.clamp(r, level.worldSize.width - r),
      pos.dy.clamp(r, level.worldSize.height - r),
    );
    lightPos = pos;
    lightVel = vel;
    lightGrounded = grounded;
    lightWallDir = wallDir;
  }

  bool _resolveHeavyCollisions() {
    var pos = heavyPos;
    var vel = heavyVel;
    const r = heavyRadius;
    bool grounded = false;

    final solidRects = <Rect>[
      ...level.blocks.map((b) => b.rect),
      ...level.gates.where((g) => !g.isOpen).map((g) => g.gateRect),
    ];

    for (final rect in solidRects) {
      final closestX = pos.dx.clamp(rect.left, rect.right);
      final closestY = pos.dy.clamp(rect.top, rect.bottom);
      final dx = pos.dx - closestX;
      final dy = pos.dy - closestY;
      final distSq = dx * dx + dy * dy;

      if (distSq < r * r) {
        final dist = math.sqrt(distSq);
        if (dist > 0.0001) {
          final nx = dx / dist;
          final ny = dy / dist;
          pos += Offset(nx * (r - dist), ny * (r - dist));
          final vn = vel.dx * nx + vel.dy * ny;
          if (vn < 0) vel -= Offset(nx * vn, ny * vn);
          if (ny < -0.65) grounded = true;
        } else {
          pos = Offset(pos.dx, rect.top - r);
          if (vel.dy > 0) vel = Offset(vel.dx, 0);
          grounded = true;
        }
      }
    }

    pos = Offset(
      pos.dx.clamp(r, level.worldSize.width - r),
      pos.dy.clamp(r, level.worldSize.height - r),
    );
    heavyPos = pos;
    heavyVel = vel;
    return grounded;
  }

  void _spawnParticle(Offset pos, Color color, double radius, double life) {
    final rng = math.Random();
    particles.add(Particle(
      pos: pos,
      vel: Offset((rng.nextDouble() - 0.5) * 60, 40 + rng.nextDouble() * 50),
      color: color,
      radius: radius,
      maxLife: life,
    ));
  }

  void _spawnBurst(Offset pos, Color color, int count) {
    final rng = math.Random();
    for (int i = 0; i < count; i++) {
      final ang = (i / count) * math.pi * 2 + rng.nextDouble() * 0.4;
      final spd = 65 + rng.nextDouble() * 130;
      particles.add(Particle(
        pos: pos,
        vel: Offset(math.cos(ang) * spd, math.sin(ang) * spd),
        color: color,
        radius: 2.5 + rng.nextDouble() * 3.5,
        maxLife: 0.4 + rng.nextDouble() * 0.35,
      ));
    }
  }

  void _updateParticles(double dt) {
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.life -= dt;
      if (p.life <= 0) {
        particles.removeAt(i);
      } else {
        p.pos += p.vel * dt;
      }
    }
  }
}
