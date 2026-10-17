import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/category.dart';

/// The outcome of generating a term: the [term] itself plus whether the
/// generator fell back to a static word (e.g., because the AI was unavailable).
class GeneratedTerm {
  final Term term;
  final bool fromFallback;

  const GeneratedTerm(this.term, {this.fromFallback = false});
}

/// Generates secret words and hints for dynamic categories via the OpenAI API,
/// with a graceful fallback to the category's built-in words.
class TermGenerator {
  TermGenerator({
    required this.apiKey,
    http.Client? client,
    this.model = 'gpt-4o-mini',
    Random? random,
  })  : _client = client ?? http.Client(),
        _random = random ?? Random();

  /// The OpenAI API key, or `null` when not configured.
  final String? apiKey;

  /// The OpenAI chat model used for generation.
  final String model;

  final http.Client _client;
  final Random _random;

  /// Recently generated English words per category id, oldest first.
  final Map<String, List<String>> _recentWords = {};

  static const _endpoint = 'https://api.openai.com/v1/chat/completions';
  static const _timeout = Duration(seconds: 20);
  static const _maxRecentWords = 30;

  bool get isConfigured => apiKey != null && apiKey!.isNotEmpty;

  /// Generates a secret word + hint for [category].
  ///
  /// Returns a fallback word (and sets [GeneratedTerm.fromFallback] to `true`)
  /// when the category is static, no API key is configured, or the request fails.
  Future<GeneratedTerm> generate(Category category) async {
    if (!category.isDynamic || !isConfigured) {
      return GeneratedTerm(_pickFallback(category), fromFallback: true);
    }
    try {
      final term = await _requestTerm(category);
      _remember(category, term);
      return GeneratedTerm(term);
    } catch (_) {
      return GeneratedTerm(_pickFallback(category), fromFallback: true);
    }
  }

  Future<Term> _requestTerm(Category category) async {
    final response = await _client
        .post(
          Uri.parse(_endpoint),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(_buildBody(category)),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw http.ClientException(
        'OpenAI request failed (${response.statusCode})',
      );
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final choices = data['choices'] as List? ?? const [];
    if (choices.isEmpty) {
      throw const FormatException('OpenAI returned no choices');
    }
    final message = (choices.first as Map<String, dynamic>)['message']
        as Map<String, dynamic>;
    return _parseTerm(message['content'] as String);
  }

  void _remember(Category category, Term term) {
    final recent = _recentWords.putIfAbsent(category.id, () => []);
    recent.add(term.en);
    if (recent.length > _maxRecentWords) {
      recent.removeAt(0);
    }
  }

  String _avoidInstruction(Category category) {
    final recent = _recentWords[category.id] ?? const [];
    if (recent.isEmpty) return '';
    return '\nDo not use any of these previously used words or their '
        'translations: ${recent.join(', ')}.';
  }

  Map<String, dynamic> _buildBody(Category category) => {
        'model': model,
        'temperature': 1.0,
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          {
            'role': 'user',
            'content': 'Kategorie (Deutsch): ${category.nameDe} — '
                '${category.promptDe}\n'
                'Category (English): ${category.nameEn} — '
                '${category.promptEn}\n'
                'Generate exactly one secret word and one hint for this category.'
                '${_avoidInstruction(category)}',
          },
        ],
      };

  Term _parseTerm(String content) {
    final map = jsonDecode(_stripCodeFence(content)) as Map<String, dynamic>;
    final wordDe = (map['wordDe'] as String?)?.trim() ?? '';
    final wordEn = (map['wordEn'] as String?)?.trim() ?? '';
    final hintDe = (map['hintDe'] as String?)?.trim() ?? '';
    final hintEn = (map['hintEn'] as String?)?.trim() ?? '';
    if (wordDe.isEmpty || wordEn.isEmpty || hintDe.isEmpty || hintEn.isEmpty) {
      throw const FormatException('OpenAI returned an incomplete term');
    }
    if (_overlaps(wordDe, hintDe) || _overlaps(wordEn, hintEn)) {
      throw const FormatException('OpenAI returned a hint revealing the word');
    }
    return Term(de: wordDe, en: wordEn, hintDe: hintDe, hintEn: hintEn);
  }

  static bool _overlaps(String word, String hint) {
    final w = word.toLowerCase();
    final h = hint.toLowerCase();
    return w.contains(h) || h.contains(w);
  }

  /// Removes a surrounding ```json … ``` code fence if the model added one.
  String _stripCodeFence(String content) {
    var text = content.trim();
    if (text.startsWith('```')) {
      final firstNewline = text.indexOf('\n');
      if (firstNewline != -1) {
        text = text.substring(firstNewline + 1);
      }
      if (text.endsWith('```')) {
        text = text.substring(0, text.length - 3);
      }
    }
    return text.trim();
  }

  Term _pickFallback(Category category) {
    if (category.terms.isEmpty) {
      throw StateError(
        'Dynamic category "${category.id}" has no fallback terms.',
      );
    }
    return category.terms[_random.nextInt(category.terms.length)];
  }
}

const _systemPrompt = '''
You are a secret-word generator for the party game "Imposter".
Given a category, create exactly one secret word and one matching hint.

Rules:
- The secret word must be a common, concrete, guessable noun or concept that clearly fits the category.
- The hint must be a single short word or very short phrase that is strongly associated with the secret word, but must NOT contain the secret word and must NOT reveal it directly.
- Provide German and English versions that are translations of each other.

Respond with only a JSON object (no markdown, no commentary) in exactly this shape:
{"wordDe": "...", "wordEn": "...", "hintDe": "...", "hintEn": "..."}
''';
