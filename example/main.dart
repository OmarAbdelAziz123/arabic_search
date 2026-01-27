import 'package:arabic_search/arabic_search.dart';

/// Example demonstrating how to use `arabic_search`
/// to perform reliable Arabic search and filtering.
///
/// This example covers:
/// - Normalizing Arabic text
/// - Generating search keys
/// - Simple contains-based search
/// - Token-based search (all tokens / any token)
/// - Ranked search over a list of objects using `searchInList`
/// - Ranked search using precomputed normalized keys (`searchInListNormalized`)
/// - Convenience extensions on String & Iterable

// ---------------------------------------------------------------------------
// Product model (declared OUTSIDE main)
// ---------------------------------------------------------------------------
class Product {
  final String name;
  final String category;

  /// Precomputed normalized key for faster search.
  final String searchKey;

  Product(this.name, this.category)
      : searchKey = ArabicText.searchKey(name);

  @override
  String toString() => '$name ($category)';
}

void main() {
  // ---------------------------------------------------------------------------
  // 1) Basic usage with plain strings
  // ---------------------------------------------------------------------------

  final List<String> items = [
    'شركة الإتصالات المصرية',
    'هاتف آيفون ١٥ برو',
    'ساعة ذكية',
    'إسلام محمد',
    'مدرسة المستقبل الدولية',
  ];

  final String query = 'الاتصالات';

  final containsResults = items.where(
    (item) => ArabicText.containsNormalized(item, query),
  );

  print('=== Simple normalized contains ===');
  print('Search query: $query');
  print('Matched results:');
  for (final item in containsResults) {
    print('- $item');
  }

  // Generate normalized search key
  final searchKey = ArabicText.searchKey('إِسْلَام ١٢٣');
  print('\n=== Search key example ===');
  print('Original:  "إِسْلَام ١٢٣"');
  print('SearchKey: "$searchKey"');

  // Digits conversion
  print('\n=== Digits conversion ===');
  print('toEnglishDigits("٢٠٢٦") -> ${ArabicText.toEnglishDigits('٢٠٢٦')}');
  print('toArabicDigits("2026")  -> ${ArabicText.toArabicDigits('2026')}');

  // ---------------------------------------------------------------------------
  // 2) Token-based search
  // ---------------------------------------------------------------------------

  final text = 'شركة الاتصالات المصرية للاتصالات والانترنت';
  final tokenQueryAll = 'الاتصالات المصرية';
  final tokenQueryAny = 'المصرية الانترنت';

  print('\n=== Token-based search ===');
  print(
    'ALL tokens match: '
    '${ArabicText.containsAllTokens(text, tokenQueryAll)}',
  );
  print(
    'ANY token match:  '
    '${ArabicText.containsAnyToken(text, tokenQueryAny)}',
  );

  // ---------------------------------------------------------------------------
  // 3) Ranked search over list of Products (on raw text)
  // ---------------------------------------------------------------------------

  final products = <Product>[
    Product('موبايل سامسونج جالاكسي', 'هواتف'),
    Product('هاتف آيفون ١٥ برو ماكس', 'هواتف'),
    Product('جراب موبايل سامسونج', 'اكسسوارات'),
    Product('سماعة بلوتوث', 'اكسسوارات'),
    Product('شاحن سريع للهواتف', 'اكسسوارات'),
  ];

  final productQuery = 'ايفون 15';

  final rankedResults = ArabicText.searchInList<Product>(
    products,
    query: productQuery,
    textSelector: (p) => p.name,
  );

  print('\n=== Ranked search in product list (searchInList) ===');
  print('Query: "$productQuery"');
  for (final hit in rankedResults) {
    print('- ${hit.item} (score: ${hit.score.toStringAsFixed(2)})');
  }

  // ---------------------------------------------------------------------------
  // 4) Ranked search using precomputed normalized keys
  // ---------------------------------------------------------------------------

  final normalizedQuery = ArabicText.searchKey(productQuery);

  final rankedWithKeys = ArabicText.searchInListNormalized<Product>(
    products,
    normalizedQuery: normalizedQuery,
    normalizedTextSelector: (p) => p.searchKey,
  );

  print('\n=== Ranked search using precomputed keys (searchInListNormalized) ===');
  print('Normalized query: "$normalizedQuery"');
  for (final hit in rankedWithKeys) {
    print('- ${hit.item} (score: ${hit.score.toStringAsFixed(2)})');
  }

  // ---------------------------------------------------------------------------
  // 5) Using extensions
  // ---------------------------------------------------------------------------

  final extQuery = 'مدرسة المستقبل';
  final extResults = items.arabicSearch(
    extQuery,
    textSelector: (s) => s,
  );

  print('\n=== Using Iterable extension `.arabicSearch` ===');
  print('Query: "$extQuery"');
  for (final hit in extResults) {
    print('- ${hit.item} (score: ${hit.score.toStringAsFixed(2)})');
  }

  final raw = '   مُحَمَّد   أحمَد، القاهرة   ';
  print('\n=== String extensions ===');
  print('raw:            "$raw"');
  print('arabicSearchKey: "${raw.arabicSearchKey}"');
  print('arabicTokens:    ${raw.arabicTokens}');
}
