import 'package:meta/meta.dart';

@immutable
class ArabicNormalizeOptions {
  const ArabicNormalizeOptions({
    this.removeDiacritics = true,
    this.removeTatweel = true,
    this.unifyAlef = true,
    this.unifyYeh = true,
    this.unifyTehMarbuta = true,
    this.toEnglishDigits = true,
    this.collapseWhitespace = true,
    this.lowercaseLatin = true,
  });

  final bool removeDiacritics;
  final bool removeTatweel;
  final bool unifyAlef;
  final bool unifyYeh;
  final bool unifyTehMarbuta;
  final bool toEnglishDigits;
  final bool collapseWhitespace;
  final bool lowercaseLatin;

  static const ArabicNormalizeOptions strict = ArabicNormalizeOptions(
    unifyTehMarbuta: false,
  );

  static const ArabicNormalizeOptions search = ArabicNormalizeOptions(
    unifyTehMarbuta: true,
  );
}
