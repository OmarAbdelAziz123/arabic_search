import 'package:test/test.dart';
import 'package:arabic_search/arabic_search.dart';

void main() {
  test('searchKey normalizes alef + digits + diacritics', () {
    final a = ArabicText.searchKey('إِسْلَام ١٢٣');
    final b = ArabicText.searchKey('اسلام 123');
    expect(a, b);
  });

  test('containsNormalized works', () {
    expect(ArabicText.containsNormalized('شركة الإتصالات المصرية', 'الاتصالات'),
        true);
  });

  test('digits conversion', () {
    expect(ArabicText.toEnglishDigits('٢٠٢٦'), '2026');
    expect(ArabicText.toArabicDigits('2026'), '٢٠٢٦');
  });
}
