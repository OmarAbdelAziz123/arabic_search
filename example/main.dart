import 'package:arabic_search/arabic_search.dart';

/// Example demonstrating how to use `arabic_search`
/// to perform reliable Arabic search and filtering.
///
/// This example covers:
/// - Normalizing Arabic text
/// - Generating search keys
/// - Performing in-memory filtering
void main() {
  // Sample data (e.g. products, companies, or posts)
  final List<String> items = [
    'شركة الإتصالات المصرية',
    'هاتف آيفون',
    'ساعة ذكية',
    'إسلام محمد',
    'مدرسة المستقبل',
  ];

  // User search input (can vary in spelling, digits, or diacritics)
  final String query = 'الاتصالات';

  // Perform Arabic-aware filtering
  final results = items.where(
    (item) => ArabicText.containsNormalized(item, query),
  );

  print('Search query: $query');
  print('Matched results:');

  for (final item in results) {
    print('- $item');
  }

  // --- Additional examples ---

  // Generate a normalized search key
  final searchKey = ArabicText.searchKey('إِسْلَام ١٢٣');
  print('\nSearch key example: $searchKey'); // اسلام 123

  // Digits conversion
  print('\nDigits conversion:');
  print(ArabicText.toEnglishDigits('٢٠٢٦')); // 2026
  print(ArabicText.toArabicDigits('2026')); // ٢٠٢٦
}
