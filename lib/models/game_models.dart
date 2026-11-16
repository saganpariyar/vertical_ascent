import 'package:flutter/material.dart';

class ShaftBlock {
  final Rect rect;
  final bool isHazard;
  const ShaftBlock(this.rect, {this.isHazard = false});
}

class SteamJetHazard {
  final Rect zone;
  final double periodSeconds;
  final double activeDuration;
  final double phaseOffset;

  const SteamJetHazard({
    required this.zone,
    this.periodSeconds = 3.6,
    this.activeDuration = 1.3,
    this.phaseOffset = 0.0,
  });

  bool isActiveAt(double t) {
    final cycle = (t + phaseOffset) % periodSeconds;
    return cycle < activeDuration;
  }

  bool isWarningAt(double t) {
    final cycle = (t + phaseOffset) % periodSeconds;
    return cycle >= periodSeconds - 0.65;
  }
}

class HoistAnchorPoint {
  final Offset position;
  final String label;
  const HoistAnchorPoint(this.position, {this.label = 'HOIST RING'});
}

class WeightSwitchGate {
  final Rect switchPlate;
  final Rect gateRect;
  bool isOpen;

  WeightSwitchGate({
    required this.switchPlate,
    required this.gateRect,
    this.isOpen = false,
  });
}

class EnergyCore {
  final Offset position;
  bool collected;
  EnergyCore(this.position, {this.collected = false});
}

class Particle {
  Offset pos;
  Offset vel;
  Color color;
  double radius;
  double life;
  double maxLife;

  Particle({
    required this.pos,
    required this.vel,
    required this.color,
    required this.radius,
    required this.maxLife,
  }) : life = maxLife;
}

class VerticalLevelDefinition {
  final int levelNumber;
  final String title;
  final String subtitle;
  final String hint;
  final Size worldSize;
  final Offset lightSpawn;
  final Offset heavySpawn;
  final Rect goalZone;
  final double parSeconds;
  final List<ShaftBlock> blocks;
  final List<SteamJetHazard> steamJets;
  final List<HoistAnchorPoint> anchors;
  final List<WeightSwitchGate> gates;
  final List<Offset> corePositions;

  const VerticalLevelDefinition({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.worldSize,
    required this.lightSpawn,
    required this.heavySpawn,
    required this.goalZone,
    required this.parSeconds,
    required this.blocks,
    required this.steamJets,
    required this.anchors,
    required this.gates,
    required this.corePositions,
  });
}
