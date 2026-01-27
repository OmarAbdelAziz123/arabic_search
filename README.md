# arabic_search 🇪🇬🇸🇦
[![pub package](https://img.shields.io/pub/v/arabic_search.svg)](https://pub.dev/packages/arabic_search)

Arabic-first text normalization and search utilities for **Dart & Flutter**.  
Built to solve real-world Arabic search problems in a clean, fast, and reusable way.

> If your app supports Arabic search, filtering, or sorting — **this package is for you**.

---

## 🎥 Live Demo

Real-time Arabic search demo using `arabic_search` in a Flutter app:

![arabic_search Demo] /Volumes/Extreme Pro/packages/arabic_search/arabic_search/assets/demo.gif


> The demo shows how different Arabic spellings and digit formats still return correct results.

---

## ✨ Features

- ✅ Remove Arabic diacritics (التشكيل)
- ✅ Remove tatweel (ـ)
- ✅ Normalize Alef variants: أ / إ / آ / ٱ → ا
- ✅ Normalize Yeh: ى → ي
- ✅ *(Search mode)* Normalize Teh Marbuta: ة → ه
- ✅ Convert Arabic digits ↔ English digits (٠١٢ ↔ 012)
- ✅ Generate robust **search keys** for accurate Arabic search
- ✅ Token-based and ranked search helpers
- ✅ Lightweight & fast (no heavy dependencies)
- ✅ Pure Dart (works with Flutter & backend Dart)

---

## 🧠 Core idea

Arabic text can be written in many valid forms:

إسلام / اسلام
الإتصالات / الاتصالات
١٢٣ / 123
مُحَمَّد / محمد
This package **normalizes all of these into a single consistent form**,  
so search, filtering, and comparisons work correctly — every time.
