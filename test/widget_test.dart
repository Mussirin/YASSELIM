import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yasselim/core/localization/app_translations.dart';
import 'package:yasselim/core/localization/locale_cubit.dart';
import 'package:yasselim/data/repositories/journal_repository.dart';
import 'package:yasselim/data/security/encryption_service.dart';
import 'package:yasselim/domain/models/journal_entry.dart';
import 'package:yasselim/domain/models/mood_type.dart';
import 'package:yasselim/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  test(
    'EncryptionService encrypts and decrypts UTF-8 Turkish text accurately',
    () {
      final service = EncryptionService();
      const secretText = 'Bazı şeyler yazıya dökülünce hafifler. 🌙✨';
      final encrypted = service.encryptPayload(secretText);

      expect(encrypted.startsWith('v1:'), isTrue);
      expect(encrypted.contains(secretText), isFalse);

      final decrypted = service.decryptPayload(encrypted);
      expect(decrypted, equals(secretText));

      // Tampered payload should fail authentication and return null
      final tampered = '${encrypted}corrupted';
      expect(service.decryptPayload(tampered), isNull);
    },
  );

  test(
    'JournalRepository seeds initial entries, saves, exports, and deletes',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = JournalRepository(prefs: prefs);

      final initial = repo.loadEntries();
      expect(initial.length, greaterThanOrEqualTo(4));

      final newEntry = JournalEntry(
        id: 'test_1',
        title: 'Gece Düşünceleri',
        content: 'Huzurlu bir akşam.',
        createdAt: DateTime(2026, 11, 9, 21, 30),
        updatedAt: DateTime(2026, 11, 9, 21, 30),
        mood: MoodType.calm,
        tags: const ['Huzur'],
      );

      final afterSave = await repo.saveEntry(newEntry);
      expect(afterSave.any((e) => e.id == 'test_1'), isTrue);

      final exported = repo.exportAllAsJson();
      expect(exported.contains('BÖLÜM I: GÜNLÜK YAZILARIM'), isTrue);
      expect(exported.contains('Gece Düşünceleri'), isTrue);
      expect(exported.contains('Huzurlu bir akşam.'), isTrue);
      expect(exported.contains('{'), isFalse);
      expect(exported.contains('}'), isFalse);

      await repo.deleteAllData();
      expect(repo.loadEntries(), isEmpty);
    },
  );

  test(
    'Multi-language localization resolves all 10 global languages & prompts',
    () {
      expect(LocaleCubit.supportedLanguages.length, equals(10));
      const expectedCodes = [
        'tr',
        'en',
        'es',
        'de',
        'fr',
        'pt',
        'ru',
        'zh',
        'ja',
        'ar',
      ];
      for (final code in expectedCodes) {
        expect(AppTranslations.byLocale(code, 'start_writing'), isNotEmpty);
        expect(AppTranslations.byLocale(code, 'nav_settings'), isNotEmpty);
        for (final prompt in AppTranslations.prompts) {
          expect(prompt.textFor(code), isNotEmpty);
          expect(prompt.categoryFor(code), isNotEmpty);
        }
      }
      expect(AppTranslations.byLocale('zh', 'save_btn'), equals('保存'));
      expect(AppTranslations.byLocale('ja', 'save_btn'), equals('保存'));
      expect(AppTranslations.byLocale('ru', 'save_btn'), equals('Сохранить'));
    },
  );

  testWidgets('YasselimApp renders Splash, Onboarding, and MainShell screens', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(YasselimApp(prefs: prefs));
    await tester.pumpAndSettle();

    // Splash Screen is shown initially
    expect(find.text('YASSELIM'), findsWidgets);
    expect(find.text('Başlayalım'), findsOneWidget);

    // Tap Get Started -> Onboarding
    await tester.tap(find.text('Başlayalım'));
    await tester.pumpAndSettle();

    expect(find.text('Kendine ait bir alan'), findsOneWidget);

    // Skip onboarding -> Main Shell (Home Screen)
    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tekrar hoş geldin!'), findsOneWidget);
    expect(find.textContaining('Yazmaya Başla'), findsOneWidget);

    // Tap "Günün İlhamı" card -> opens WritingPromptsScreen without overflow when keyboard opens
    await tester.tap(find.textContaining('Günün İlhamı'));
    await tester.pumpAndSettle();

    expect(find.text('Yazma Soruları'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Bugün çok huzurluyum.');
    await tester.pumpAndSettle();
    expect(find.text('Bugün çok huzurluyum.'), findsOneWidget);
    expect(find.text('Kaydet'), findsOneWidget);
  });
}
