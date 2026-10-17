import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:imposter_game/data/categories.dart';
import 'package:imposter_game/models/category.dart';
import 'package:imposter_game/services/term_generator.dart';

void main() {
  final dynamicCategory = kCategories.firstWhere((c) => c.isDynamic);

  // A hand-built static category (no AI prompt) to exercise the fallback path.
  const staticCategory = Category(
    id: 'test-static',
    nameDe: 'Test',
    nameEn: 'Test',
    emoji: '❓',
    terms: [
      Term(de: 'Testwort', en: 'Test word', hintDe: 'Hinweis', hintEn: 'Hint'),
    ],
  );

  group('TermGenerator.generate', () {
    test('returns a fallback term when no API key is configured', () async {
      final generator = TermGenerator(apiKey: null, random: Random(1));
      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isTrue);
      expect(dynamicCategory.terms, contains(result.term));
    });

    test('returns a fallback term for a static category', () async {
      final generator = TermGenerator(apiKey: 'sk-test', random: Random(1));
      final result = await generator.generate(staticCategory);

      expect(result.fromFallback, isTrue);
      expect(staticCategory.terms, contains(result.term));
    });

    test('returns a fallback term when the request fails', () async {
      final client = MockClient((_) async => http.Response('error', 500));
      final generator =
          TermGenerator(apiKey: 'sk-test', client: client, random: Random(1));

      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isTrue);
      expect(dynamicCategory.terms, contains(result.term));
    });

    test('parses a successful OpenAI response', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          'https://api.openai.com/v1/chat/completions',
        );
        expect(request.headers.values, contains('Bearer sk-test'));

        final body = jsonEncode({
          'choices': [
            {
              'message': {
                'content': '{"wordDe":"Frühstück","wordEn":"Breakfast",'
                    '"hintDe":"Müsli","hintEn":"Cereal"}',
              },
            },
          ],
        });
        return http.Response.bytes(utf8.encode(body), 200);
      });

      final generator = TermGenerator(apiKey: 'sk-test', client: client);
      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isFalse);
      expect(result.term.de, 'Frühstück');
      expect(result.term.en, 'Breakfast');
      expect(result.term.hintDe, 'Müsli');
      expect(result.term.hintEn, 'Cereal');
    });
  });

  group('category data', () {
    test('every category is dynamic with a prompt and fallback terms', () {
      expect(kCategories, isNotEmpty);
      for (final category in kCategories) {
        expect(category.isDynamic, isTrue);
        expect(category.promptDe, isNotNull);
        expect(category.promptEn, isNotNull);
        expect(category.terms, isNotEmpty);
      }
    });

    test('includes categories for the 2000s and the modern era', () {
      final ids = kCategories.map((c) => c.id).toSet();
      expect(ids, contains('years2000'));
      expect(ids, contains('modern'));
    });
  });
}
