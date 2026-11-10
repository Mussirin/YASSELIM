import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/localization/app_translations.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/mood_type.dart';
import '../../domain/models/unsent_letter.dart';
import '../security/encryption_service.dart';

/// Manages local encrypted persistence for journal entries and unsent letters.
class JournalRepository {
  static const String entriesKey = 'yasselim_entries_enc_v1';
  static const String lettersKey = 'yasselim_letters_enc_v1';
  static const String seededKey = 'yasselim_seeded_v1';

  final SharedPreferences? prefs;
  final EncryptionService _encryption;
  List<JournalEntry> _memoryEntries = [];
  List<UnsentLetter> _memoryLetters = [];
  bool _memorySeeded = false;

  JournalRepository({this.prefs, EncryptionService? encryption})
    : _encryption = encryption ?? EncryptionService() {
    _ensureSeeded();
  }

  void _ensureSeeded() {
    final isSeeded = prefs?.getBool(seededKey) ?? _memorySeeded;
    if (isSeeded) return;

    final now = DateTime.now();
    final initialEntries = [
      JournalEntry(
        id: 'seed_1',
        title: 'Küçük mutluluklar hayatı güzelleştiriyor.',
        content: 'Bugün sabah kahvemi içerken pencereden süzülen güneş ışığını fark ettim. Küçük mutluluklar hayatı güzelleştiriyor ve ruhumu dinlendiriyor.',
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        mood: MoodType.happy,
        tags: const ['şükür', 'huzur'],
        scenicVariant: 0,
      ),
      JournalEntry(
        id: 'seed_2',
        title: 'Yeni bir başlangıç her zaman mümkün.',
        content: 'Geçmişin yüklerini geride bırakıp yeni bir sayfa açmak insana nefes aldırıyor. Yeni bir başlangıç her zaman mümkün.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 2)),
        mood: MoodType.hopeful,
        tags: const ['umut', 'başlangıç'],
        scenicVariant: 1,
      ),
      JournalEntry(
        id: 'seed_3',
        title: 'Kendime vakit ayırmak iyi hissettiriyor.',
        content: 'Sessiz bir akşamda sadece kendi düşüncelerimle baş başa kalmak ve iç sesimi dinlemek bana çok iyi geldi.',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
        updatedAt: now.subtract(const Duration(days: 2, hours: 4)),
        mood: MoodType.calm,
        tags: const ['farkındalık'],
        scenicVariant: 2,
      ),
      JournalEntry(
        id: 'seed_4',
        title: 'Hayallerim... Daha güçlü bir ben.',
        content: 'Her geçen gün kendimi daha iyi tanıyor, adımlarımı daha kararlı atıyorum. Hayallerim... Daha güçlü bir ben.',
        createdAt: now.subtract(const Duration(days: 3, hours: 5)),
        updatedAt: now.subtract(const Duration(days: 3, hours: 5)),
        mood: MoodType.grateful,
        tags: const ['hayaller', 'güç'],
        scenicVariant: 3,
      ),
    ];

    final initialLetters = [
      UnsentLetter(
        id: 'letter_seed_1',
        recipient: 'Gelecekteki Kendime',
        title: 'Sabırlı olduğun için teşekkürler',
        content: 'Zor zamanlardan geçerken bile kalbini karartmadığın ve umudunu koruduğun için sana minnettarım.',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    _memoryEntries = initialEntries;
    _memoryLetters = initialLetters;
    _memorySeeded = true;

    if (prefs != null) {
      prefs?.setString(entriesKey, _encodeEntries(initialEntries));
      prefs?.setString(lettersKey, _encodeLetters(initialLetters));
      prefs?.setBool(seededKey, true);
    }
  }

  List<JournalEntry> loadEntries() {
    if (prefs == null) return _sortEntries(_memoryEntries);
    final raw = prefs?.getString(entriesKey);
    if (raw == null || raw.isEmpty) return [];
    final decrypted = _encryption.decryptPayload(raw);
    if (decrypted == null) return [];
    final list = (jsonDecode(decrypted) as List<dynamic>)
        .map((e) => JournalEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return _sortEntries(list);
  }

  Future<List<JournalEntry>> saveEntry(JournalEntry entry) async {
    final current = loadEntries();
    final idx = current.indexWhere((e) => e.id == entry.id);
    if (idx >= 0) {
      current[idx] = entry;
    } else {
      current.add(entry);
    }
    final sorted = _sortEntries(current);
    _memoryEntries = sorted;
    await prefs?.setString(entriesKey, _encodeEntries(sorted));
    return sorted;
  }

  Future<List<JournalEntry>> deleteEntry(String id) async {
    final updated = loadEntries()..removeWhere((e) => e.id == id);
    _memoryEntries = updated;
    await prefs?.setString(entriesKey, _encodeEntries(updated));
    return updated;
  }

  List<UnsentLetter> loadLetters() {
    if (prefs == null) return _sortLetters(_memoryLetters);
    final raw = prefs?.getString(lettersKey);
    if (raw == null || raw.isEmpty) return [];
    final decrypted = _encryption.decryptPayload(raw);
    if (decrypted == null) return [];
    final list = (jsonDecode(decrypted) as List<dynamic>)
        .map((e) => UnsentLetter.fromJson(e as Map<String, dynamic>))
        .toList();
    return _sortLetters(list);
  }

  Future<List<UnsentLetter>> saveLetter(UnsentLetter letter) async {
    final current = loadLetters();
    final idx = current.indexWhere((l) => l.id == letter.id);
    if (idx >= 0) {
      current[idx] = letter;
    } else {
      current.add(letter);
    }
    final sorted = _sortLetters(current);
    _memoryLetters = sorted;
    await prefs?.setString(lettersKey, _encodeLetters(sorted));
    return sorted;
  }

  Future<List<UnsentLetter>> deleteLetter(String id) async {
    final updated = loadLetters()..removeWhere((l) => l.id == id);
    _memoryLetters = updated;
    await prefs?.setString(lettersKey, _encodeLetters(updated));
    return updated;
  }

  String exportAsBookText({String lang = 'tr'}) {
    final isTr = lang == 'tr';
    final dateFmt = DateFormat('dd.MM.yyyy • HH:mm');
    final entries = loadEntries();
    final letters = loadLetters();
    final buf = StringBuffer();

    buf.writeln(
      isTr
          ? 'YASSELIM — KENDİNE AİT BİR ALAN'
          : 'YASSELIM — YOUR PRIVATE SPACE',
    );
    buf.writeln(
      '${isTr ? 'Dışa Aktarma Tarihi' : 'Exported On'}: ${dateFmt.format(DateTime.now())}',
    );
    buf.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buf.writeln();

    buf.writeln(isTr ? 'BÖLÜM I: GÜNLÜK YAZILARIM' : 'PART I: JOURNAL ENTRIES');
    buf.writeln();

    if (entries.isEmpty) {
      buf.writeln(
        isTr ? 'Henüz günlük yazısı bulunmuyor.' : 'No journal entries yet.',
      );
      buf.writeln();
    } else {
      for (int i = 0; i < entries.length; i++) {
        final e = entries[i];
        buf.writeln('${i + 1}. ${e.title}');
        buf.writeln(
          '${isTr ? 'Tarih' : 'Date'}: ${dateFmt.format(e.createdAt)}',
        );
        if (e.mood != null) {
          final moodLabel = AppTranslations.byLocale(
            lang,
            e.mood!.translationKey,
          );
          buf.writeln('${isTr ? 'Ruh Hali' : 'Mood'}: $moodLabel');
        }
        if (e.tags.isNotEmpty) {
          buf.writeln('${isTr ? 'Etiketler' : 'Tags'}: ${e.tags.join(', ')}');
        }
        buf.writeln();
        buf.writeln(e.content);
        buf.writeln();
        buf.writeln('────────────────────────────────────────');
        buf.writeln();
      }
    }

    buf.writeln(
      isTr ? 'BÖLÜM II: GÖNDERİLMEYECEK MEKTUPLAR' : 'PART II: UNSENT LETTERS',
    );
    buf.writeln();

    if (letters.isEmpty) {
      buf.writeln(
        isTr
            ? 'Henüz yazılmış mektup bulunmuyor.'
            : 'No unsent letters written yet.',
      );
    } else {
      for (int i = 0; i < letters.length; i++) {
        final l = letters[i];
        buf.writeln('${i + 1}. ${l.title}');
        if (l.recipient.isNotEmpty) {
          buf.writeln('${isTr ? 'Kime' : 'To'}: ${l.recipient}');
        }
        buf.writeln(
          '${isTr ? 'Tarih' : 'Date'}: ${dateFmt.format(l.createdAt)}',
        );
        buf.writeln();
        buf.writeln(l.content);
        buf.writeln();
        if (i < letters.length - 1) {
          buf.writeln('────────────────────────────────────────');
          buf.writeln();
        }
      }
    }

    return buf.toString().trimRight();
  }

  String exportAllAsJson({String lang = 'tr'}) => exportAsBookText(lang: lang);

  Future<void> deleteAllData() async {
    _memoryEntries = [];
    _memoryLetters = [];
    _memorySeeded = true;
    await prefs?.remove(entriesKey);
    await prefs?.remove(lettersKey);
    await prefs?.setBool(seededKey, true);
  }

  String _encodeEntries(List<JournalEntry> items) => _encryption.encryptPayload(
    jsonEncode(items.map((e) => e.toJson()).toList()),
  );

  String _encodeLetters(List<UnsentLetter> items) => _encryption.encryptPayload(
    jsonEncode(items.map((l) => l.toJson()).toList()),
  );

  List<JournalEntry> _sortEntries(List<JournalEntry> list) =>
      List<JournalEntry>.from(list)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<UnsentLetter> _sortLetters(List<UnsentLetter> list) =>
      List<UnsentLetter>.from(list)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
