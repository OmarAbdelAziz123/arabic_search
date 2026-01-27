import 'package:meta/meta.dart';

import 'options.dart';

/// نتيجة بحث عربية تحتوي على الـ item والـ score وبعض معلومات الماتش.
@immutable
class ArabicSearchHit<T> {
  const ArabicSearchHit({
    required this.item,
    required this.score,
    this.index,
    this.matchedLength,
  });

  /// العنصر الأصلي من الـ collection.
  final T item;

  /// درجة المطابقة بين 0.0 و 1.0 (كل ما زادت كل ما كانت النتيجة أفضل).
  final double score;

  /// بداية الماتش في النص الـ normalized (لو متاحة).
  final int? index;

  /// طول الماتش في النص الـ normalized (لو متاح).
  final int? matchedLength;
}

/// Arabic text normalization and search utilities.
///
/// Use [searchKey] for indexing and search,
/// and [normalize] for display-safe normalization.
abstract final class ArabicText {
  static final RegExp _diacritics = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]',
  );

  static final RegExp _punctuation = RegExp(
    r'[^\p{L}\p{Nd}\s]', // anything not: letter, digit, whitespace
    unicode: true,
  );

  static const String _tatweel = '\u0640';

  static const Map<String, String> _arabicToEnglishDigits = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static const Map<String, String> _englishToArabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  /// تحويل الأرقام العربية إلى إنجليزية داخل النص.
  static String toEnglishDigits(String input) {
    var s = input;
    _arabicToEnglishDigits.forEach((k, v) => s = s.replaceAll(k, v));
    return s;
  }

  /// تحويل الأرقام الإنجليزية إلى عربية داخل النص.
  static String toArabicDigits(String input) {
    var s = input;
    _englishToArabicDigits.forEach((k, v) => s = s.replaceAll(k, v));
    return s;
  }

  /// إزالة التشكيل من النص.
  static String stripDiacritics(String input) =>
      input.replaceAll(_diacritics, '');

  /// إزالة التطويل من النص.
  static String stripTatweel(String input) => input.replaceAll(_tatweel, '');

  /// Normalize Arabic (and mixed) text according to [options].
  static String normalize(
    String input, {
    ArabicNormalizeOptions options = ArabicNormalizeOptions.strict,
  }) {
    var s = input;

    if (options.lowercaseLatin) s = s.toLowerCase();
    if (options.toEnglishDigits) s = toEnglishDigits(s);
    if (options.removeDiacritics) s = stripDiacritics(s);
    if (options.removeTatweel) s = stripTatweel(s);

    if (options.removePunctuation) {
      s = s.replaceAll(_punctuation, ' ');
    }

    if (options.unifyAlef) {
      s = s
          .replaceAll('\u0623', '\u0627') // أ
          .replaceAll('\u0625', '\u0627') // إ
          .replaceAll('\u0622', '\u0627') // آ
          .replaceAll('\u0671', '\u0627'); // ٱ
    }

    if (options.unifyYeh) {
      s = s.replaceAll('\u0649', '\u064A'); // ى -> ي
    }

    if (options.unifyTehMarbuta) {
      s = s.replaceAll('\u0629', '\u0647'); // ة -> ه (للsearch)
    }

    if (options.collapseWhitespace) {
      s = s.trim().replaceAll(RegExp(r'\s+'), ' ');
    }

    return s;
  }

  /// Generate a normalized key suitable for indexing / searching.
  static String searchKey(String input) {
    return normalize(input, options: ArabicNormalizeOptions.search);
  }

  /// Simple contains-based normalized search.
  static bool containsNormalized(String haystack, String needle) {
    return searchKey(haystack).contains(searchKey(needle));
  }

  /// Split normalized Arabic text into tokens (words).
  ///
  /// Example:
  ///   "   محمد   أحمد، جرب  " -> ["محمد", "احمد", "جرب"]
  static List<String> tokenize(
    String input, {
    ArabicNormalizeOptions options = ArabicNormalizeOptions.search,
  }) {
    final normalized = normalize(input, options: options);
    if (normalized.isEmpty) return const [];
    return normalized.split(' ').where((t) => t.isNotEmpty).toList();
  }

  /// Returns true if *all* tokens from [query] exist in [text] after normalization.
  ///
  /// Example:
  ///   text:  "محمد احمد علي"
  ///   query: "محمد احمد"  -> true
  ///   query: "محمد حسن"   -> false
  static bool containsAllTokens(
    String text,
    String query, {
    ArabicNormalizeOptions options = ArabicNormalizeOptions.search,
  }) {
    final textTokens = tokenize(text, options: options).toSet();
    final queryTokens = tokenize(query, options: options);
    if (queryTokens.isEmpty) return true;
    return queryTokens.every(textTokens.contains);
  }

  /// Returns true if *any* token from [query] exists in [text] after normalization.
  ///
  /// Example:
  ///   text:  "محمد احمد علي"
  ///   query: "محمد حسن" -> true (محمد موجود)
  static bool containsAnyToken(
    String text,
    String query, {
    ArabicNormalizeOptions options = ArabicNormalizeOptions.search,
  }) {
    final textTokens = tokenize(text, options: options).toSet();
    final queryTokens = tokenize(query, options: options);
    if (queryTokens.isEmpty) return true;
    return queryTokens.any(textTokens.contains);
  }

  /// Low-level scoring for normalized strings.
  ///
  /// - Exact match -> 1.0
  /// - Prefix match -> ~0.7 - 1.0 (depending on length)
  /// - Contains -> lower score
  static double _scoreNormalized(
      String normalizedText, String normalizedQuery) {
    if (normalizedQuery.isEmpty) return 0.0;
    if (normalizedText.isEmpty) return 0.0;

    if (normalizedText == normalizedQuery) {
      return 1.0;
    }

    final index = normalizedText.indexOf(normalizedQuery);
    if (index == -1) return 0.0;

    // Base score for any match.
    var score = 0.3;

    // Bonus if match is at the beginning.
    if (index == 0) {
      score += 0.4;
    }

    // Bonus for longer query vs text length.
    final lengthRatio = normalizedQuery.length / normalizedText.length;
    score += (lengthRatio * 0.3);

    if (score > 1.0) score = 1.0;
    if (score < 0.0) score = 0.0;

    return score;
  }

  /// Search in a collection of items, returning ranked results.
  ///
  /// Example:
  ///   final results = ArabicText.searchInList<User>(
  ///     users,
  ///     query: 'محمد احمد',
  ///     textSelector: (u) => '${u.firstName} ${u.lastName}',
  ///   );
  ///
  ///   // results[0].item -> أفضل ماتش
  static List<ArabicSearchHit<T>> searchInList<T>(
    Iterable<T> items, {
    required String query,
    required String Function(T item) textSelector,
    ArabicNormalizeOptions options = ArabicNormalizeOptions.search,
  }) {
    final normalizedQuery = normalize(query, options: options);
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final List<ArabicSearchHit<T>> hits = [];

    for (final item in items) {
      final rawText = textSelector(item);
      final normalizedText = normalize(rawText, options: options);

      final index = normalizedText.indexOf(normalizedQuery);
      if (index == -1) continue;

      final score = _scoreNormalized(normalizedText, normalizedQuery);
      if (score <= 0.0) continue;

      hits.add(
        ArabicSearchHit<T>(
          item: item,
          score: score,
          index: index,
          matchedLength: normalizedQuery.length,
        ),
      );
    }

    hits.sort((a, b) => b.score.compareTo(a.score));
    return hits;
  }
}

/// Extensions مريحة للاستخدام السريع.
extension ArabicSearchStringX on String {
  /// key جاهز للبحث / الفلترة.
  String get arabicSearchKey => ArabicText.searchKey(this);

  /// توكنز النص بعد الـ normalization.
  List<String> get arabicTokens => ArabicText.tokenize(this);
}

extension ArabicSearchIterableX<T> on Iterable<T> {
  /// Search مباشر على collection بإرجاع أفضل النتائج مرتبة.
  List<ArabicSearchHit<T>> arabicSearch(
    String query, {
    required String Function(T item) textSelector,
    ArabicNormalizeOptions options = ArabicNormalizeOptions.search,
  }) {
    return ArabicText.searchInList<T>(
      this,
      query: query,
      textSelector: textSelector,
      options: options,
    );
  }
}
