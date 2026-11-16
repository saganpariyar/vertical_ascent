import 'package:flutter/material.dart';

class LightProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const LightProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class HeavyProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const HeavyProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class BackgroundThemeOption {
  final String id;
  final String name;
  final String subtitle;
  final String assetPath;
  final Color skyTint;
  final Color accentColor;
  final Color platformTopColor;
  final Color platformBodyColor;

  const BackgroundThemeOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.assetPath,
    required this.skyTint,
    required this.accentColor,
    required this.platformTopColor,
    required this.platformBodyColor,
  });
}

enum TetherPattern { plasma, steel, magChain, runic }

class TetherStyleOption {
  final String id;
  final String name;
  final String subtitle;
  final Color primaryColor;
  final Color pulseColor;
  final TetherPattern pattern;

  const TetherStyleOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.primaryColor,
    required this.pulseColor,
    required this.pattern,
  });
}

class PilotBadgeOption {
  final String id;
  final String name;
  final String callsign;
  final IconData icon;
  final Color badgeColor;

  const PilotBadgeOption({
    required this.id,
    required this.name,
    required this.callsign,
    required this.icon,
    required this.badgeColor,
  });
}

class CustomizationCatalog {
  static const List<LightProfile> lightProfiles = [
    LightProfile(
      id: 'aero_wisp',
      name: 'Aero-Wisp',
      title: 'Jet-Boot Climber',
      perk: 'Dual Chimney Boosters',
      assetPath: 'assets/images/profiles/light_aero_wisp.png',
      primaryColor: Color(0xFF38BDF8),
      glowColor: Color(0xFF22D3EE),
    ),
    LightProfile(
      id: 'volt_sprite',
      name: 'Volt-Sprite',
      title: 'Emerald Wall-Runner',
      perk: 'Magnetic Wall Grips',
      assetPath: 'assets/images/profiles/light_volt_sprite.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFF6EE7B7),
    ),
    LightProfile(
      id: 'solar_falcon',
      name: 'Solar-Falcon',
      title: 'Phoenix Updraft Ace',
      perk: 'Vertical Flare Burst',
      assetPath: 'assets/images/profiles/light_solar_falcon.png',
      primaryColor: Color(0xFFFBBF24),
      glowColor: Color(0xFFFB7185),
    ),
    LightProfile(
      id: 'nebula_lynx',
      name: 'Nebula-Lynx',
      title: 'Void Shaft Jumper',
      perk: 'Zero-G Shaft Leap',
      assetPath: 'assets/images/profiles/light_nebula_lynx.png',
      primaryColor: Color(0xFFE879F9),
      glowColor: Color(0xFFC084FC),
    ),
  ];

  static const List<HeavyProfile> heavyProfiles = [
    HeavyProfile(
      id: 'titan_core',
      name: 'Titan-Core',
      title: 'Amber Cargo Golem',
      perk: 'Stabilized Hoist Frame',
      assetPath: 'assets/images/profiles/heavy_titan_core.png',
      primaryColor: Color(0xFFFB923C),
      glowColor: Color(0xFFFBBF24),
    ),
    HeavyProfile(
      id: 'bastion_mk4',
      name: 'Bastion-MK4',
      title: 'Cobalt Freight Mech',
      perk: 'Elevator Winch Core',
      assetPath: 'assets/images/profiles/heavy_bastion_mk4.png',
      primaryColor: Color(0xFF60A5FA),
      glowColor: Color(0xFF93C5FD),
    ),
    HeavyProfile(
      id: 'magma_atlas',
      name: 'Magma-Atlas',
      title: 'Forge Payload Unit',
      perk: 'Thermal-Shield Plating',
      assetPath: 'assets/images/profiles/heavy_magma_atlas.png',
      primaryColor: Color(0xFFF43F5E),
      glowColor: Color(0xFFF97316),
    ),
    HeavyProfile(
      id: 'jade_bulwark',
      name: 'Jade-Bulwark',
      title: 'Spire Guardian Rig',
      perk: 'Counterweight Chassis',
      assetPath: 'assets/images/profiles/heavy_jade_bulwark.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFFFBBF24),
    ),
  ];

  static const List<BackgroundThemeOption> backgrounds = [
    BackgroundThemeOption(
      id: 'geothermal_shaft',
      name: 'Geothermal Mine',
      subtitle: 'Volcanic Steel Shaft',
      assetPath: 'assets/images/backgrounds/bg_1.png',
      skyTint: Color(0xFF451A03),
      accentColor: Color(0xFFFB923C),
      platformTopColor: Color(0xFFD97706),
      platformBodyColor: Color(0xFF292524),
    ),
    BackgroundThemeOption(
      id: 'cyber_reactor',
      name: 'Cyber Reactor',
      subtitle: 'Neon Core Conduit',
      assetPath: 'assets/images/backgrounds/bg_2.png',
      skyTint: Color(0xFF082F49),
      accentColor: Color(0xFF38BDF8),
      platformTopColor: Color(0xFF0284C7),
      platformBodyColor: Color(0xFF0F172A),
    ),
    BackgroundThemeOption(
      id: 'bamboo_spire',
      name: 'Pagoda Spire',
      subtitle: 'Misty Jade Chimney',
      assetPath: 'assets/images/backgrounds/bg_3.png',
      skyTint: Color(0xFF14532D),
      accentColor: Color(0xFF4ADE80),
      platformTopColor: Color(0xFF16A34A),
      platformBodyColor: Color(0xFF052E16),
    ),
    BackgroundThemeOption(
      id: 'orbital_elevator',
      name: 'Orbital Elevator',
      subtitle: 'Starlight Space Spine',
      assetPath: 'assets/images/backgrounds/bg_4.png',
      skyTint: Color(0xFF1E1B4B),
      accentColor: Color(0xFFA78BFA),
      platformTopColor: Color(0xFF6366F1),
      platformBodyColor: Color(0xFF090D1A),
    ),
  ];

  static const List<TetherStyleOption> tetherStyles = [
    TetherStyleOption(
      id: 'plasma_hoist',
      name: 'Plasma Hoist',
      subtitle: 'High-Torque Light Beam',
      primaryColor: Color(0xFF38BDF8),
      pulseColor: Color(0xFFFFFFFF),
      pattern: TetherPattern.plasma,
    ),
    TetherStyleOption(
      id: 'steel_winch',
      name: 'Steel Winch',
      subtitle: 'Heavy Elevator Cable',
      primaryColor: Color(0xFF94A3B8),
      pulseColor: Color(0xFFFB923C),
      pattern: TetherPattern.steel,
    ),
    TetherStyleOption(
      id: 'mag_lift',
      name: 'Mag-Lift Chain',
      subtitle: 'Vertical Force Nodes',
      primaryColor: Color(0xFFA78BFA),
      pulseColor: Color(0xFF38BDF8),
      pattern: TetherPattern.magChain,
    ),
    TetherStyleOption(
      id: 'runic_rope',
      name: 'Runic Tether',
      subtitle: 'Golden Lift Filament',
      primaryColor: Color(0xFFFBBF24),
      pulseColor: Color(0xFFFEF08A),
      pattern: TetherPattern.runic,
    ),
  ];

  static const List<PilotBadgeOption> pilotBadges = [
    PilotBadgeOption(
      id: 'hoist_vanguard',
      name: 'Hoist Crest',
      callsign: 'SHAFT-1',
      icon: Icons.elevator_rounded,
      badgeColor: Color(0xFF38BDF8),
    ),
    PilotBadgeOption(
      id: 'spire_bolt',
      name: 'Spire Bolt',
      callsign: 'CLIMB-9',
      icon: Icons.vertical_align_top_rounded,
      badgeColor: Color(0xFFFB923C),
    ),
    PilotBadgeOption(
      id: 'nova_core',
      name: 'Reactor Halo',
      callsign: 'CORE-X',
      icon: Icons.auto_awesome_rounded,
      badgeColor: Color(0xFF4ADE80),
    ),
    PilotBadgeOption(
      id: 'orbital_anchor',
      name: 'Sky Anchor',
      callsign: 'APEX-7',
      icon: Icons.anchor_rounded,
      badgeColor: Color(0xFFA78BFA),
    ),
  ];
}
