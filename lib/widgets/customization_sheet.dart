import 'package:flutter/material.dart';
import '../models/customization.dart';
import '../services/storage_service.dart';

class CustomizationSheet extends StatefulWidget {
  final VoidCallback onChanged;
  const CustomizationSheet({super.key, required this.onChanged});

  @override
  State<CustomizationSheet> createState() => _CustomizationSheetState();
}

class _CustomizationSheetState extends State<CustomizationSheet> {
  void _selectLight(int idx) {
    setState(() => StorageService.lightProfileIndex = idx);
    StorageService.save();
    widget.onChanged();
  }

  void _selectHeavy(int idx) {
    setState(() => StorageService.heavyProfileIndex = idx);
    StorageService.save();
    widget.onChanged();
  }

  void _selectBackground(int idx) {
    setState(() => StorageService.backgroundIndex = idx);
    StorageService.save();
    widget.onChanged();
  }

  void _selectTether(int idx) {
    setState(() => StorageService.tetherStyleIndex = idx);
    StorageService.save();
    widget.onChanged();
  }

  void _selectBadge(int idx) {
    setState(() => StorageService.pilotBadgeIndex = idx);
    StorageService.save();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0xFF334155), width: 1.5)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(color: const Color(0xFF475569), borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, color: Color(0xFF38BDF8)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Customize Climber, Hoist & Shaft World',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E293B), height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                _sectionTitle('Light Climber Profile (4 Options)'),
                const SizedBox(height: 8),
                _buildLightProfiles(),
                const SizedBox(height: 18),
                _sectionTitle('Heavy Payload Profile (4 Options)'),
                const SizedBox(height: 8),
                _buildHeavyProfiles(),
                const SizedBox(height: 18),
                _sectionTitle('Shaft World Background (4 Options)'),
                const SizedBox(height: 8),
                _buildBackgrounds(),
                const SizedBox(height: 18),
                _sectionTitle('Hoist Cable Style (4 Options)'),
                const SizedBox(height: 8),
                _buildTethers(),
                const SizedBox(height: 18),
                _sectionTitle('Pilot Emblem Badge (4 Options)'),
                const SizedBox(height: 8),
                _buildBadges(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)),
    );
  }

  Widget _buildLightProfiles() {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CustomizationCatalog.lightProfiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final p = CustomizationCatalog.lightProfiles[idx];
          final selected = StorageService.lightProfileIndex == idx;
          return GestureDetector(
            onTap: () => _selectLight(idx),
            child: Container(
              width: 112,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? p.primaryColor.withValues(alpha: 0.16) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? p.primaryColor : const Color(0xFF334155), width: selected ? 2.2 : 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(child: Image.asset(p.assetPath, width: 58, height: 58, fit: BoxFit.cover)),
                  const SizedBox(height: 6),
                  Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: p.glowColor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeavyProfiles() {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CustomizationCatalog.heavyProfiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final p = CustomizationCatalog.heavyProfiles[idx];
          final selected = StorageService.heavyProfileIndex == idx;
          return GestureDetector(
            onTap: () => _selectHeavy(idx),
            child: Container(
              width: 112,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? p.primaryColor.withValues(alpha: 0.16) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? p.primaryColor : const Color(0xFF334155), width: selected ? 2.2 : 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(child: Image.asset(p.assetPath, width: 58, height: 58, fit: BoxFit.cover)),
                  const SizedBox(height: 6),
                  Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: p.glowColor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgrounds() {
    return SizedBox(
      height: 126,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CustomizationCatalog.backgrounds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final bg = CustomizationCatalog.backgrounds[idx];
          final selected = StorageService.backgroundIndex == idx;
          return GestureDetector(
            onTap: () => _selectBackground(idx),
            child: Container(
              width: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? bg.accentColor : const Color(0xFF334155), width: selected ? 2.4 : 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(bg.assetPath, fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xDD020617)]),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bg.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text(bg.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: bg.accentColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTethers() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(CustomizationCatalog.tetherStyles.length, (idx) {
        final t = CustomizationCatalog.tetherStyles[idx];
        final selected = StorageService.tetherStyleIndex == idx;
        return GestureDetector(
          onTap: () => _selectTether(idx),
          child: Container(
            width: 155,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? t.primaryColor.withValues(alpha: 0.16) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? t.primaryColor : const Color(0xFF334155), width: selected ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(width: 24, height: 6, decoration: BoxDecoration(color: t.primaryColor, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text(t.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(CustomizationCatalog.pilotBadges.length, (idx) {
        final b = CustomizationCatalog.pilotBadges[idx];
        final selected = StorageService.pilotBadgeIndex == idx;
        return GestureDetector(
          onTap: () => _selectBadge(idx),
          child: Container(
            width: 155,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? b.badgeColor.withValues(alpha: 0.16) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? b.badgeColor : const Color(0xFF334155), width: selected ? 2 : 1),
            ),
            child: Row(
              children: [
                Icon(b.icon, color: b.badgeColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text(b.callsign, style: TextStyle(fontSize: 10, color: b.badgeColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
