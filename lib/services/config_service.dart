import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads runtime configuration (e.g., the OpenAI API key) from a bundled JSON
/// file that is intentionally kept out of version control.
class ConfigService {
  const ConfigService();

  /// Returns the OpenAI API key, or `null` when it is not configured.
  ///
  /// The key is read from `assets/config.json` — copy `assets/config.example.json`
  /// to `assets/config.json` and fill in your key. If the file is missing or the
  /// key is empty, this returns `null` so callers can fall back to static words.
  Future<String?> loadOpenAiApiKey() async {
    try {
      final raw = await rootBundle.loadString('assets/config.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final key = (map['openai_api_key'] as String?)?.trim() ?? '';
      return key.isEmpty ? null : key;
    } catch (_) {
      // Missing file, malformed JSON, or an absent key: treat as unconfigured.
      return null;
    }
  }
}
