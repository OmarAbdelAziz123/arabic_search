# arabic_search 🇸🇦🇪🇬

Arabic-first text normalization and search utilities for Dart & Flutter.  
Designed to fix common Arabic search issues like different Alef forms (أ/إ/آ),
diacritics (tashkeel), tatweel (ـ), Arabic digits (٠١٢), and more.

> If your app supports Arabic search, filtering, or sorting — this package is for you.

---

## ✨ Features

- ✅ Remove Arabic diacritics (التشكيل)
- ✅ Remove tatweel (ـ)
- ✅ Normalize Alef variants: أ / إ / آ / ٱ → ا
- ✅ Normalize Yeh: ى → ي
- ✅ (Search mode) Normalize Teh Marbuta: ة → ه
- ✅ Convert Arabic digits ↔ English digits (٠١٢ ↔ 012)
- ✅ Generate robust **search keys** for accurate Arabic search
- ✅ Lightweight, fast, and dependency-free (except `meta`)
- ✅ Pure Dart (works with Flutter & backend Dart)

---

## 🚀 Getting started

Add the package to your project:

```bash
dart pub add arabic_search
