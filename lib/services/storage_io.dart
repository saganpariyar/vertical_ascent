import 'dart:io';

Future<String?> readSaveJson(String filename) async {
  try {
    final file = File('${Directory.systemTemp.path}${Platform.pathSeparator}$filename');
    if (await file.exists()) {
      return await file.readAsString();
    }
  } catch (_) {}
  return null;
}

Future<void> writeSaveJson(String filename, String jsonStr) async {
  try {
    final file = File('${Directory.systemTemp.path}${Platform.pathSeparator}$filename');
    await file.writeAsString(jsonStr, flush: true);
  } catch (_) {}
}
