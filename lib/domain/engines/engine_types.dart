import '../entities/transaction.dart';
import '../entities/category.dart';

/// Абстракция для platform-specific парсинга транзакций
/// КРИТИЧНО: Реализация выбирается через DI в зависимости от платформы
abstract class TransactionSourceParser {
  /// Парсинг входных данных в транзакцию
  /// 
  /// Android: парсит уведомления (например, "Kaspi: 3500₸ Magnum")
  /// iOS: парсит быстрый ввод (например, "5000 еда")
  Future<Transaction?> parseInput(dynamic input);

  /// Проверка может ли парсер обработать данный тип ввода
  bool canParse(dynamic input);
}

/// Результат категоризации
class CategorizationResult {
  final String categoryId;
  final String categoryName;
  final double confidence; // 0.0 - 1.0
  final List<String> matchedKeywords;

  const CategorizationResult({
    required this.categoryId,
    required this.categoryName,
    this.confidence = 1.0,
    this.matchedKeywords = const [],
  });
}

/// Флаги поведенческого анализа
class BehavioralFlags {
  final bool isImpulsive;
  final bool isNightTransaction;
  final bool isWeekendTransaction;
  final bool isUnusualAmount;
  final String? reason;

  const BehavioralFlags({
    this.isImpulsive = false,
    this.isNightTransaction = false,
    this.isWeekendTransaction = false,
    this.isUnusualAmount = false,
    this.reason,
  });

  /// Есть ли какие-то флаги
  bool get hasFlags => 
      isImpulsive || 
      isNightTransaction || 
      isWeekendTransaction || 
      isUnusualAmount;
}

/// Инсайт от Decision Engine
class DecisionInsight {
  final String message;
  final InsightType type;
  final InsightSeverity severity;
  final String? actionSuggestion;

  const DecisionInsight({
    required this.message,
    required this.type,
    required this.severity,
    this.actionSuggestion,
  });
}

enum InsightType {
  warning,
  success,
  info,
  suggestion,
}

enum InsightSeverity {
  low,
  medium,
  high,
  critical,
}
