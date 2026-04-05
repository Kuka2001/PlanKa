import '../entities/transaction.dart';
import '../entities/category.dart';
import '../engines/engine_types.dart';
import '../engines/engines.dart';

/// Реализация CategorizationEngine на основе keyword matching
class CategorizationEngineImpl implements CategorizationEngine {
  final List<Category> _categories;

  const CategorizationEngineImpl(this._categories);

  @override
  CategorizationResult categorize(String description, double amount) {
    final lowerDescription = description.toLowerCase();
    
    Category? bestMatch;
    int bestScore = 0;
    List<String> matchedKeywords = [];

    for (final category in _categories) {
      int score = 0;
      final keywords = <String>[];

      for (final keyword in category.keywords) {
        if (lowerDescription.contains(keyword.toLowerCase())) {
          score++;
          keywords.add(keyword);
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestMatch = category;
        matchedKeywords = keywords;
      }
    }

    // Если нет совпадений - возвращаем "other" или первую категорию
    if (bestMatch == null) {
      return const CategorizationResult(
        categoryId: 'other',
        categoryName: 'Другое',
        confidence: 0.0,
      );
    }

    return CategorizationResult(
      categoryId: bestMatch.id,
      categoryName: bestMatch.name,
      confidence: bestScore / categoryKeywordsCount(bestMatch),
      matchedKeywords: matchedKeywords,
    );
  }

  @override
  List<CategorizationResult> categorizeMany(List<Transaction> transactions) {
    return transactions
        .where((t) => t.description != null && t.description!.isNotEmpty)
        .map((t) => categorize(t.description!, t.amount))
        .toList();
  }

  @override
  void learnFromCorrection(String description, String correctCategoryId) {
    // TODO: Сохранение в базу для будущего обучения
    // В production здесь будет ML модель
  }

  int categoryKeywordsCount(Category category) => category.keywords.length;
}

/// Реализация BehavioralEngine
class BehavioralEngineImpl implements BehavioralEngine {
  static const int _nightStartHour = 22; // 22:00
  static const int _nightEndHour = 6;    // 06:00

  @override
  BehavioralFlags analyzeTransaction(Transaction transaction) {
    final isNight = isNightTime(transaction.date);
    final isWeekend = this.isWeekend(transaction.date);
    
    // Импульсивная если: ночная ИЛИ (выходной И крупная сумма)
    final isImpulsive = isNight || (isWeekend && transaction.amount > 50000);

    return BehavioralFlags(
      isImpulsive: isImpulsive,
      isNightTransaction: isNight,
      isWeekendTransaction: isWeekend,
      reason: _getReason(isNight, isWeekend, isImpulsive),
    );
  }

  @override
  bool isNightTime(DateTime time) {
    final hour = time.hour;
    return hour >= _nightStartHour || hour < _nightEndHour;
  }

  @override
  bool isWeekend(DateTime date) {
    final weekday = date.weekday;
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  @override
  BehavioralPattern analyzePatterns(
    List<Transaction> transactions,
    DateTime start,
    DateTime end,
  ) {
    final filtered = transactions
        .where((t) => 
            t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();

    if (filtered.isEmpty) {
      return const BehavioralPattern(
        totalTransactions: 0,
        averageAmount: 0,
        nightTransactionRate: 0,
        weekendTransactionRate: 0,
        topCategories: [],
        hourlyDistribution: {},
      );
    }

    final total = filtered.length;
    final avgAmount = filtered.fold<double>(
            0, (sum, t) => sum + t.amount) /
        total;

    final nightCount = filtered.where((t) => isNightTime(t.date)).length;
    final weekendCount = filtered.where((t) => isWeekend(t.date)).length;

    // Распределение по часам
    final hourlyDist = <int, double>{};
    for (var i = 0; i < 24; i++) hourlyDist[i] = 0;
    
    for (final t in filtered) {
      hourlyDist[t.date.hour] = (hourlyDist[t.date.hour] ?? 0) + t.amount;
    }

    // Топ категории
    final categoryCounts = <String, int>{};
    for (final t in filtered) {
      categoryCounts[t.categoryId] = (categoryCounts[t.categoryId] ?? 0) + 1;
    }
    final topCategories = categoryCounts.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

    return BehavioralPattern(
      totalTransactions: total,
      averageAmount: avgAmount,
      nightTransactionRate: nightCount / total,
      weekendTransactionRate: weekendCount / total,
      topCategories: topCategories.take(5).map((e) => e.key).toList(),
      hourlyDistribution: hourlyDist,
    );
  }

  String? _getReason(bool isNight, bool isWeekend, bool isImpulsive) {
    if (!isImpulsive) return null;
    if (isNight) return 'Ночная покупка';
    if (isWeekend) return 'Выходной день';
    return 'Подозрительная активность';
  }
}
