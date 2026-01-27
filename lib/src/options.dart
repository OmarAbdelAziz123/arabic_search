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
    this.removePunctuation = false,
  });

  /// إزالة التشكيل (الضمة، الفتحة، الكسرة، إلخ)
  final bool removeDiacritics;

  /// إزالة التطويل (ـ)
  final bool removeTatweel;

  /// توحيد أشكال الألف (أ/إ/آ/ٱ → ا)
  final bool unifyAlef;

  /// توحيد الياء (ى → ي)
  final bool unifyYeh;

  /// توحيد التاء المربوطة للبحث (ة → ه)
  final bool unifyTehMarbuta;

  /// تحويل الأرقام العربية إلى إنجليزية (٠١٢ → 012)
  final bool toEnglishDigits;

  /// دمج المسافات المتكررة لمسافة واحدة + trim
  final bool collapseWhitespace;

  /// جعل الحروف اللاتينية lowercase
  final bool lowercaseLatin;

  /// إزالة علامات الترقيم (، . ! ؟ … إلخ) أثناء الـ normalization
  final bool removePunctuation;

  /// Strict: مناسب للـ display / تخزين normalized
  /// بدون تغيير في التاء المربوطة أو علامات الترقيم.
  static const ArabicNormalizeOptions strict = ArabicNormalizeOptions(
    unifyTehMarbuta: false,
    removePunctuation: false,
  );

  /// Search: إعدادات مناسبة للبحث
  /// تزيل التشكيل، التطويل، الترقيم، توحّد الألف/الياء/التاء المربوطة، إلخ.
  static const ArabicNormalizeOptions search = ArabicNormalizeOptions(
    unifyTehMarbuta: true,
    removePunctuation: true,
  );
}
