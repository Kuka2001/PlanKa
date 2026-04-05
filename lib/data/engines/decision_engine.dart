import '../entities/transaction.dart';
import '../engines/engine_types.dart';
import '../engines/engines.dart';

/// Реализация DecisionEngine для генерации инсайтов
class DecisionEngineImpl implements DecisionEngine {
  static const double _overspendingThreshold = 0.2; // 20% перерасход

  @override
  List<DecisionInsight> analyzeTransaction(Transaction transaction) {
    final insights = <DecisionInsight>[];

    // Проверка на импульсивную трату
    if (transaction.isImpulsive && transaction.type == TransactionType.expense) {
      insights.add(const DecisionInsight(
        message: 'Это может быть импульсивной покупкой',
        type: InsightType.info,
        severity: InsightSeverity.low,
        actionSuggestion: 'Подумайте, действительно ли это необходимо',
      ));
    }

    // Крупная трата (>100k ₸)
    if (transaction.amount > 100000 && transaction.type == TransactionType.expense) {
      insights.add(DecisionInsight(
        message: 'Крупная трата: ${_formatAmount(transaction.amount)} ₸',
        type: InsightType.warning,
        severity: InsightSeverity.medium,
        actionSuggestion: 'Убедитесь, что это вписывается в бюджет',
      ));
    }

    return insights;
  }

  @override
  List<DecisionInsight> comparePeriods(
    List<Transaction> period1,
    List<Transaction> period2,
  ) {
    final insights = <DecisionInsight>[];

    final total1 = period1.fold<double>(
        0, (sum, t) => t.type == TransactionType.expense ? sum + t.amount : sum);
    final total2 = period2.fold<double>(
        0, (sum, t) => t.type == TransactionType.expense ? sum + t.amount : sum);

    if (total1 > 0 && total2 > 0) {
      final change = (total1 - total2) / total2;

      if (change > _overspendingThreshold) {
        final percent = (change * 100).round();
        insights.add(DecisionInsight(
          message:
              'Вы тратите на $percent% больше чем в прошлом периоде',
          type: InsightType.warning,
          severity: InsightSeverity.high,
          actionSuggestion: 'Проверьте категории с наибольшим ростом',
        ));
      } else if (change < -_overspendingThreshold) {
        final percent = ((-change) * 100).round();
        insights.add(DecisionInsight(
          message: 'Отлично! Вы тратите на $percent% меньше',
          type: InsightType.success,
          severity: InsightSeverity.low,
          actionSuggestion: 'Продолжайте в том же духе',
        ));
      }
    }

    return insights;
  }

  @override
  List<DecisionInsight> analyzeOverspending(
    List<Transaction> transactions,
    String categoryId,
    double budgetLimit,
  ) {
    final insights = <DecisionInsight>[];

    final categoryTotal = transactions
        .where((t) =>
            t.categoryId == categoryId && t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    if (categoryTotal > budgetLimit) {
      final overspent = categoryTotal - budgetLimit;
      final percent = ((overspent / budgetLimit) * 100).round();

      insights.add(DecisionInsight(
        message: 'Перерасход по категории на $percent% (${_formatAmount(overspent)} ₸)',
        type: InsightType.warning,
        severity: percent > 50 ? InsightSeverity.high : InsightSeverity.medium,
        actionSuggestion: 'Сократите траты в этой категории',
      ));
    }

    return insights;
  }

  @override
  List<DecisionInsight> generateSummaryInsights(
    List<Transaction> transactions,
    DateTime start,
    DateTime end,
  ) {
    final insights = <DecisionInsight>[];
    final filtered = transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();

    // Анализ ночных трат
    final nightTransactions = filtered
        .where((t) =>
            t.type == TransactionType.expense &&
            (t.date.hour >= 22 || t.date.hour < 6))
        .toList();

    if (nightTransactions.length > 3) {
      insights.add(DecisionInsight(
        message:
            'Замечено ${nightTransactions.length} ночных покупок за период',
        type: InsightType.info,
        severity: InsightSeverity.medium,
        actionSuggestion: 'Ночные покупки часто бывают импульсивными',
      ));
    }

    // Общая статистика
    final expenses = filtered
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final income = filtered
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);

    if (income > 0 && expenses > income) {
      insights.add(DecisionInsight(
        message: 'Расходы превысили доходы на ${_formatAmount(expenses - income)} ₸',
        type: InsightType.warning,
        severity: InsightSeverity.high,
        actionSuggestion: 'Пересмотрите бюджет',
      ));
    }

    return insights;
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0);
  }
}

/// Реализация SimulationEngine для расчетов
class SimulationEngineImpl implements SimulationEngine {
  @override
  DepositSimulation calculateDeposit({
    required double initialAmount,
    required double annualRate,
    required int months,
    bool isCompound = true,
    double? monthlyContribution,
  }) {
    final breakdown = <MonthlyBreakdown>[];
    var balance = initialAmount;
    final monthlyRate = annualRate / 12;

    for (var month = 1; month <= months; month++) {
      final interest = isCompound ? balance * monthlyRate : initialAmount * monthlyRate;
      balance += interest;
      
      if (monthlyContribution != null && monthlyContribution > 0) {
        balance += monthlyContribution;
      }

      breakdown.add(MonthlyBreakdown(
        month: month,
        amount: monthlyContribution ?? 0,
        interest: interest,
        balance: balance,
      ));
    }

    return DepositSimulation(
      initialAmount: initialAmount,
      finalAmount: balance,
      profit: balance - initialAmount - ((monthlyContribution ?? 0) * months),
      effectiveRate: annualRate,
      breakdown: breakdown,
    );
  }

  @override
  SavingsPlanSimulation calculateSavingsPlan({
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    double? monthlyContribution,
  }) {
    final remaining = targetAmount - currentAmount;
    
    if (remaining <= 0) {
      return SavingsPlanSimulation(
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        remaining: 0,
        monthsToGoal: 0,
        requiredMonthlyPayment: 0,
        isAchievable: true,
      );
    }

    final now = DateTime.now();
    if (deadline.isBefore(now)) {
      return SavingsPlanSimulation(
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        remaining: remaining,
        monthsToGoal: 0,
        requiredMonthlyPayment: remaining,
        isAchievable: false,
      );
    }

    final monthsLeft = deadline.difference(now).inDays ~/ 30;
    final requiredPayment = monthsLeft > 0 ? remaining / monthsLeft : remaining;

    return SavingsPlanSimulation(
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      remaining: remaining,
      monthsToGoal: monthsLeft,
      requiredMonthlyPayment: requiredPayment,
      isAchievable: monthlyContribution == null || monthlyContribution >= requiredPayment,
    );
  }

  @override
  ForecastSimulation forecastExpenses({
    required List<Transaction> history,
    required int monthsAhead,
    String? categoryId,
  }) {
    if (history.isEmpty) {
      return ForecastSimulation(
        predictedAmount: 0,
        confidence: 0,
        trend: 'stable',
        monthlyForecasts: [],
      );
    }

    final filtered = categoryId != null
        ? history.where((t) => t.categoryId == categoryId).toList()
        : history;

    // Простой прогноз: среднее за последние месяцы
    final avgMonthly = filtered.fold<double>(
            0, (sum, t) => t.type == TransactionType.expense ? sum + t.amount : sum) /
        (filtered.length > 0 ? filtered.length : 1);

    final forecasts = <MonthlyForecast>[];
    for (var i = 1; i <= monthsAhead; i++) {
      final month = DateTime.now().add(Duration(days: 30 * i));
      // Добавляем небольшую вариативность
      final variance = avgMonthly * 0.1;
      forecasts.add(MonthlyForecast(
        month: month,
        predictedAmount: avgMonthly,
        minAmount: avgMonthly - variance,
        maxAmount: avgMonthly + variance,
      ));
    }

    // Определение тренда (упрощенно)
    final trend = 'stable';

    return ForecastSimulation(
      predictedAmount: avgMonthly * monthsAhead,
      confidence: 0.7,
      trend: trend,
      monthlyForecasts: forecasts,
    );
  }
}
