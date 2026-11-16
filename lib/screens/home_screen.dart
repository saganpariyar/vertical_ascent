import 'package:flutter/material.dart';
import '../models/customization.dart';
import '../models/levels.dart';
import '../services/storage_service.dart';
import '../widgets/customization_sheet.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _levels = VerticalLevels.buildAll();

  void _openCustomization() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomizationSheet(onChanged: () => setState(() {})),
    );
  }

  void _launchLevel(int index) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => GameScreen(initialLevelIndex: index)))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bg = CustomizationCatalog.backgrounds[StorageService.backgroundIndex];
    final light = CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex];
    final heavy = CustomizationCatalog.heavyProfiles[StorageService.heavyProfileIndex];
    final badge = CustomizationCatalog.pilotBadges[StorageService.pilotBadgeIndex];
    final tether = CustomizationCatalog.tetherStyles[StorageService.tetherStyleIndex];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Image.asset(bg.assetPath, key: ValueKey(bg.assetPath), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xAA020617), Color(0x88020617), Color(0xEE020617)]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/icon/app_icon.png', width: 52, height: 52)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('VERTICAL ASCENT', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Colors.white)),
                            Text('Shaft Launcher & Elevator Hoist Co-op', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 18),
                            const SizedBox(width: 4),
                            Text('${StorageService.totalStars}/18', style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: GestureDetector(
                    onTap: _openCustomization,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.84),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: bg.accentColor.withValues(alpha: 0.45), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _avatarChip(light.assetPath, light.name, light.primaryColor),
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(badge.icon, color: badge.badgeColor, size: 22),
                                    const SizedBox(height: 4),
                                    Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: tether.primaryColor, borderRadius: BorderRadius.circular(2))),
                                    const SizedBox(height: 4),
                                    Text('${badge.callsign} • ${bg.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              _avatarChip(heavy.assetPath, heavy.name, heavy.primaryColor),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.palette_rounded, size: 15, color: bg.accentColor),
                              const SizedBox(width: 6),
                              Text('Tap to Customize Profiles, Shafts & Gear (4 Options Each)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: bg.accentColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: CustomizationCatalog.backgrounds.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final item = CustomizationCatalog.backgrounds[idx];
                      final active = StorageService.backgroundIndex == idx;
                      return ChoiceChip(
                        label: Text(item.name),
                        selected: active,
                        selectedColor: item.accentColor.withValues(alpha: 0.25),
                        backgroundColor: const Color(0xFF0F172A),
                        side: BorderSide(color: active ? item.accentColor : const Color(0xFF334155)),
                        labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? Colors.white : const Color(0xFF94A3B8)),
                        onSelected: (_) {
                          setState(() => StorageService.backgroundIndex = idx);
                          StorageService.save();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 230,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: _levels.length,
                    itemBuilder: (context, idx) {
                      final lvl = _levels[idx];
                      final unlocked = lvl.levelNumber <= StorageService.unlockedLevel;
                      final stars = StorageService.levelStars[lvl.levelNumber] ?? 0;
                      return GestureDetector(
                        onTap: unlocked ? () => _launchLevel(idx) : null,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: unlocked ? const Color(0xFF0F172A).withValues(alpha: 0.88) : const Color(0xFF0F172A).withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: unlocked ? bg.accentColor.withValues(alpha: 0.5) : const Color(0xFF1E293B), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(color: unlocked ? bg.accentColor.withValues(alpha: 0.2) : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
                                    child: Text('LVL ${lvl.levelNumber}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: unlocked ? bg.accentColor : const Color(0xFF64748B))),
                                  ),
                                  Icon(unlocked ? Icons.play_circle_fill_rounded : Icons.lock_rounded, color: unlocked ? const Color(0xFF34D399) : const Color(0xFF475569), size: 22),
                                ],
                              ),
                              const Spacer(),
                              Text(lvl.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: unlocked ? Colors.white : const Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text(lvl.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                              const SizedBox(height: 8),
                              Row(children: List.generate(3, (s) => Icon(Icons.star_rounded, size: 18, color: s < stars ? const Color(0xFFFBBF24) : const Color(0xFF334155)))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: bg.accentColor, foregroundColor: const Color(0xFF020617), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () => _launchLevel((StorageService.unlockedLevel - 1).clamp(0, _levels.length - 1)),
                      icon: const Icon(Icons.vertical_align_top_rounded),
                      label: Text('PLAY LEVEL ${StorageService.unlockedLevel}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarChip(String asset, String label, Color color) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)), child: ClipOval(child: Image.asset(asset, width: 46, height: 46, fit: BoxFit.cover))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }
}
