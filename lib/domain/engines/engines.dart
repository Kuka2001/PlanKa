import '../entities/transaction.dart';
import '../entities/category.dart';
import 'engine_types.dart';

/// Engine для автоматической категоризации транзакций
/// Использует rule-based систему с keyword matching
abstract class CategorizationEngine {
  /// Категоризация транзакции по описанию и сумме
  CategorizationResult categorize(String description, double amount);

  /// Массовая категоризация списка транзакций
  List<CategorizationResult> categorizeMany(List<Transaction> transactions);

  /// Обучение на основе пользовательских правок (future enhancement)
  void learnFromCorrection(String description, String correctCategoryId);
}

/// Engine для анализа поведения пользователя
abstract class BehavioralEngine {
  /// Анализ отдельной транзакции
  BehavioralFlags analyzeTransaction(Transaction transaction);

  /// Анализ паттернов за период
  BehavioralPattern analyzePatterns(
    List<Transaction> transactions,
    DateTime start,
    DateTime end,
  );

  /// Проверка является ли время ночным (22:00 - 06:00)
  bool isNightTime(DateTime time);

  /// Проверка является ли день выходным
  bool isWeekend(DateTime date);
}

/// Паттерн поведения
class BehavioralPattern {
  final int totalTransactions;
  final double averageAmount;
  final double nightTransactionRate;
  final double weekendTransactionRate;
  final List<String> topCategories;
  final Map<int, double> hourlyDistribution; // hour -> average amount

  const BehavioralPattern({
    required this.totalTransactions,
    required this.averageAmount,
    required this.nightTransactionRate,
    required this.weekendTransactionRate,
    required this.topCategories,
    required this.hourlyDistribution,
  });
}

/// Engine для генерации инсайтов и рекомендаций
abstract class DecisionEngine {
  /// Генерация инсайтов на основе транзакции
  List<DecisionInsight> analyzeTransaction(Transaction transaction);

  /// Сравнение периодов и выявление аномалий
  List<DecisionInsight> comparePeriods(
    List<Transaction> period1,
    List<Transaction> period2,
  );

  /// Анализ перерасхода по категории
  List<DecisionInsight> analyzeOverspending(
    List<Transaction> transactions,
    String categoryId,
    double budgetLimit,
  );

  /// Генерация сводных инсайтов за период
  List<DecisionInsight> generateSummaryInsights(
    List<Transaction> transactions,
    DateTime start,
    DateTime end,
  );
}

/// Engine для симуляций и прогнозов ("что если")
abstract class SimulationEngine {
  /// Расчет роста вклада
  DepositSimulation calculateDeposit({
    required double initialAmount,
    required double annualRate,
    required int months,
    bool isCompound = true,
    double? monthlyContribution,
  });

  /// Расчет плана накоплений
  SavingsPlanSimulation calculateSavingsPlan({
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    double? monthlyContribution,
  });

  /// Прогноз расходов на основе истории
  ForecastSimulation forecastExpenses({
    required List<Transaction> history,
    required int monthsAhead,
    String? categoryId,
  });
}

/// Результат симуляции вклада
class DepositSimulation {
  final double initialAmount;
  final double finalAmount;
  final double profit;
  final double effectiveRate;
  final List<MonthlyBreakdown> breakdown;

  const DepositSimulation({
    required this.initialAmount,
    required this.finalAmount,
    required this.profit,
    required this.effectiveRate,
    required this.breakdown,
  });
}

/// Результат симуляции накоплений
class SavingsPlanSimulation {
  final double targetAmount;
  final double currentAmount;
  final double remaining;
  final int monthsToGoal;
  final double requiredMonthlyPayment;
  final bool isAchievable;

  const SavingsPlanSimulation({
    required this.targetAmount,
    required this.currentAmount,
    required this.remaining,
    required this.monthsToGoal,
    required this.requiredMonthlyPayment,
    required this.isAchievable,
  });
}

/// Результат прогноза
class ForecastSimulation {
  final double predictedAmount;
  final double confidence;
  final String trend; // 'increasing', 'decreasing', 'stable'
  final List<MonthlyForecast> monthlyForecasts;

  const ForecastSimulation({
    required this.predictedAmount,
    required this.confidence,
    required this.trend,
    required this.monthlyForecasts,
  });
}

/// Детализация по месяцам
class MonthlyBreakdown {
  final int month;
  final double amount;
  final double interest;
  final double balance;

  const MonthlyBreakdown({
    required this.month,
    required this.amount,
    required this.interest,
    required this.balance,
  });
}

/// Прогноз по месяцу
class MonthlyForecast {
  final DateTime month;
  final double predictedAmount;
  final double minAmount;
  final double maxAmount;

  const MonthlyForecast({
    required this.month,
    required this.predictedAmount,
    required this.minAmount,
    required this.maxAmount,
  });
}
