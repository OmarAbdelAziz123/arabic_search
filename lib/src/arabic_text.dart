import 'options.dart';

abstract final class ArabicText {
  static final RegExp _diacritics = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]',
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

  static String toEnglishDigits(String input) {
    var s = input;
    _arabicToEnglishDigits.forEach((k, v) => s = s.replaceAll(k, v));
    return s;
  }

  static String toArabicDigits(String input) {
    var s = input;
    _englishToArabicDigits.forEach((k, v) => s = s.replaceAll(k, v));
    return s;
  }

  static String stripDiacritics(String input) =>
      input.replaceAll(_diacritics, '');
  static String stripTatweel(String input) => input.replaceAll(_tatweel, '');

  static String normalize(
    String input, {
    ArabicNormalizeOptions options = ArabicNormalizeOptions.strict,
  }) {
    var s = input;

    if (options.lowercaseLatin) s = s.toLowerCase();
    if (options.toEnglishDigits) s = toEnglishDigits(s);
    if (options.removeDiacritics) s = stripDiacritics(s);
    if (options.removeTatweel) s = stripTatweel(s);

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

  static String searchKey(String input) {
    return normalize(input, options: ArabicNormalizeOptions.search);
  }

  static bool containsNormalized(String haystack, String needle) {
    return searchKey(haystack).contains(searchKey(needle));
  }
}
