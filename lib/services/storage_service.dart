import 'dart:convert';
import 'storage_backend.dart';

class StorageService {
  static const String _saveFile = 'tether_vertical_ascent_v1.json';

  static int lightProfileIndex = 0;
  static int heavyProfileIndex = 0;
  static int backgroundIndex = 0;
  static int tetherStyleIndex = 0;
  static int pilotBadgeIndex = 0;
  static bool twoPlayerMode = false;
  static int unlockedLevel = 1;
  static final Map<int, int> levelStars = {};
  static final Map<int, int> bestTimeMs = {};

  static Future<void> init() async {
    final raw = await readSaveJson(_saveFile);
    if (raw == null || raw.isEmpty) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      lightProfileIndex = (data['lightProfileIndex'] as int? ?? 0).clamp(0, 3);
      heavyProfileIndex = (data['heavyProfileIndex'] as int? ?? 0).clamp(0, 3);
      backgroundIndex = (data['backgroundIndex'] as int? ?? 0).clamp(0, 3);
      tetherStyleIndex = (data['tetherStyleIndex'] as int? ?? 0).clamp(0, 3);
      pilotBadgeIndex = (data['pilotBadgeIndex'] as int? ?? 0).clamp(0, 3);
      twoPlayerMode = data['twoPlayerMode'] as bool? ?? false;
      unlockedLevel = (data['unlockedLevel'] as int? ?? 1).clamp(1, 6);
      final stars = data['levelStars'] as Map<String, dynamic>?;
      if (stars != null) {
        for (final entry in stars.entries) {
          final lvl = int.tryParse(entry.key);
          if (lvl != null) levelStars[lvl] = entry.value as int;
        }
      }
      final times = data['bestTimeMs'] as Map<String, dynamic>?;
      if (times != null) {
        for (final entry in times.entries) {
          final lvl = int.tryParse(entry.key);
          if (lvl != null) bestTimeMs[lvl] = entry.value as int;
        }
      }
    } catch (_) {}
  }

  static Future<void> save() async {
    final payload = <String, dynamic>{
      'lightProfileIndex': lightProfileIndex,
      'heavyProfileIndex': heavyProfileIndex,
      'backgroundIndex': backgroundIndex,
      'tetherStyleIndex': tetherStyleIndex,
      'pilotBadgeIndex': pilotBadgeIndex,
      'twoPlayerMode': twoPlayerMode,
      'unlockedLevel': unlockedLevel,
      'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
      'bestTimeMs': bestTimeMs.map((k, v) => MapEntry(k.toString(), v)),
    };
    await writeSaveJson(_saveFile, jsonEncode(payload));
  }

  static int get totalStars =>
      levelStars.values.fold<int>(0, (sum, s) => sum + s);
}
