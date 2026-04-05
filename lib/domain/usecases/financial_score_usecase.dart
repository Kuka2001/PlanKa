import '../entities/insight.dart';
import '../entities/transaction.dart';

/// Use Case: Расчет Financial Health Score (0-100)
class CalculateFinancialScoreUseCase {
  const CalculateFinancialScoreUseCase();

  FinancialHealth execute({
    required List<Transaction> transactions,
    required double totalIncome,
    required double totalExpenses,
  }) {
    if (transactions.isEmpty && totalIncome == 0 && totalExpenses == 0) {
      return const FinancialHealth(
        score: 50, // Default для новых пользователей
        savingsRate: 0,
        stabilityScore: 0.5,
        impulsiveSpendingRate: 0,
        assessment: 'Начните добавлять транзакции',
      );
    }

    // 1. Расчет savings rate (процент сбережений)
    final savingsRate = totalIncome > 0 
        ? ((totalIncome - totalExpenses) / totalIncome).clamp(0.0, 1.0)
        : 0.0;

    // 2. Расчет стабильности доходов (упрощенно: по регулярности)
    final stabilityScore = _calculateStability(transactions);

    // 3. Расчет импульсивных трат
    final impulsiveCount = transactions.where((t) => t.isImpulsive).length;
    final impulsiveSpendingRate = transactions.isNotEmpty
        ? impulsiveCount / transactions.length
        : 0.0;

    // 4. Расчет общего score (взвешенная сумма)
    // savingsRate: 40%, stability: 30%, low impulsive: 30%
    final score = (
      savingsRate * 40 +
      stabilityScore * 30 +
      (1 - impulsiveSpendingRate) * 30
    ).round().clamp(0, 100);

    // 5. Текстовая оценка
    final assessment = _getAssessment(score);

    return FinancialHealth(
      score: score,
      savingsRate: savingsRate,
      stabilityScore: stabilityScore,
      impulsiveSpendingRate: impulsiveSpendingRate,
      assessment: assessment,
    );
  }

  double _calculateStability(List<Transaction> transactions) {
    // Упрощенная логика: считаем количество транзакций по дням недели
    // Если есть активность в разные дни - стабильность выше
    if (transactions.length < 5) return 0.5;

    final daysWithActivity = transactions
        .map((t) => t.date.weekday)
        .toSet()
        .length;

    return (daysWithActivity / 7).clamp(0.3, 1.0);
  }

  String _getAssessment(int score) {
    if (score >= 80) return 'Отличное финансовое здоровье!';
    if (score >= 60) return 'Хорошее состояние';
    if (score >= 40) return 'Требуется внимание';
    if (score >= 20) return 'Плохое состояние';
    return 'Критическое состояние';
  }
}

/// Use Case: Получение инсайтов
class GetInsightsUseCase {
  // Будет реализован после создания InsightRepository
  const GetInsightsUseCase();

  // Placeholder для будущей реализации
  Future<List<Insight>> execute() async {
    return [];
  }
}
