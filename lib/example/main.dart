import 'package:arabic_search/arabic_search.dart';

void main() {
  final items = [
    'شركة الإتصالات المصرية',
    'هاتف آيفون',
    'ساعة ذكية',
  ];

  final query = 'الاتصالات';

  final results = items.where(
    (e) => ArabicText.containsNormalized(e, query),
  );

  print(results);
}
