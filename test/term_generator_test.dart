import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:imposter_game/data/categories.dart';
import 'package:imposter_game/services/term_generator.dart';

void main() {
  final dynamicCategory = kCategories.firstWhere((c) => c.isDynamic);
  final staticCategory = kCategories.firstWhere((c) => !c.isDynamic);

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

  group('TermGenerator response validation', () {
    http.Response termResponse(Map<String, String> term) {
      final body = jsonEncode({
        'choices': [
          {
            'message': {'content': jsonEncode(term)},
          },
        ],
      });
      return http.Response.bytes(utf8.encode(body), 200);
    }

    test('falls back when the English hint contains the word', () async {
      final client = MockClient((_) async => termResponse({
            'wordDe': 'Klapphandy',
            'wordEn': 'Flip phone',
            'hintDe': 'Nokia',
            'hintEn': 'Phone',
          }));
      final generator =
          TermGenerator(apiKey: 'sk-test', client: client, random: Random(1));

      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isTrue);
      expect(dynamicCategory.terms, contains(result.term));
    });

    test('falls back when the German hint contains the word', () async {
      final client = MockClient((_) async => termResponse({
            'wordDe': 'Handy',
            'wordEn': 'Cell phone',
            'hintDe': 'Klapphandy',
            'hintEn': 'Nokia',
          }));
      final generator =
          TermGenerator(apiKey: 'sk-test', client: client, random: Random(1));

      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isTrue);
      expect(dynamicCategory.terms, contains(result.term));
    });

    test('accepts a hint that merely contains a short word', () async {
      final client = MockClient((_) async => termResponse({
            'wordDe': 'KI',
            'wordEn': 'AI',
            'hintDe': 'Skizze',
            'hintEn': 'Training',
          }));
      final generator = TermGenerator(apiKey: 'sk-test', client: client);

      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isFalse);
      expect(result.term.en, 'AI');
      expect(result.term.hintEn, 'Training');
    });

    test('falls back when a short word is a whole token of the hint',
        () async {
      final client = MockClient((_) async => termResponse({
            'wordDe': 'KI',
            'wordEn': 'AI',
            'hintDe': 'Roboter',
            'hintEn': 'AI art',
          }));
      final generator =
          TermGenerator(apiKey: 'sk-test', client: client, random: Random(1));

      final result = await generator.generate(dynamicCategory);

      expect(result.fromFallback, isTrue);
      expect(dynamicCategory.terms, contains(result.term));
    });

    test('asks the AI to avoid words it generated before', () async {
      final prompts = <String>[];
      final words = ['Flip phone', 'MP3 player'];
      final client = MockClient((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final messages = body['messages'] as List;
        final userMessage = messages.last as Map<String, dynamic>;
        prompts.add(userMessage['content'] as String);
        final word = words[prompts.length - 1];
        return termResponse({
          'wordDe': word,
          'wordEn': word,
          'hintDe': 'Retro',
          'hintEn': 'Retro',
        });
      });
      final generator = TermGenerator(apiKey: 'sk-test', client: client);

      final first = await generator.generate(dynamicCategory);
      final second = await generator.generate(dynamicCategory);

      expect(first.term.en, 'Flip phone');
      expect(second.term.en, 'MP3 player');
      expect(prompts[0], isNot(contains('Flip phone')));
      expect(prompts[1], contains('Flip phone'));
    });
  });

  group('category data', () {
    test('dynamic categories have prompts and fallback terms', () {
      for (final category in kCategories.where((c) => c.isDynamic)) {
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
