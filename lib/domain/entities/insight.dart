import 'package:equatable/equatable.dart';

/// Тип инсайта
enum InsightType {
  warning,     // Предупреждение (перерасход)
  success,     // Успех (превышение цели)
  info,        // Информация (паттерн поведения)
  suggestion,  // Рекомендация
}

/// Уровень важности
enum InsightSeverity {
  low,
  medium,
  high,
  critical,
}

/// Сущность Инсайта (рекомендации/аналитика)
class Insight extends Equatable {
  final String id;
  final InsightType type;
  final String message;
  final InsightSeverity severity;
  final DateTime createdAt;
  final String? relatedTransactionId;
  final String? categoryId;
  final bool isRead;

  const Insight({
    required this.id,
    required this.type,
    required this.message,
    required this.severity,
    required this.createdAt,
    this.relatedTransactionId,
    this.categoryId,
    this.isRead = false,
  });

  Insight copyWith({
    String? id,
    InsightType? type,
    String? message,
    InsightSeverity? severity,
    DateTime? createdAt,
    String? relatedTransactionId,
    String? categoryId,
    bool? isRead,
  }) {
    return Insight(
      id: id ?? this.id,
      type: type ?? this.type,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      categoryId: categoryId ?? this.categoryId,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        message,
        severity,
        createdAt,
        relatedTransactionId,
        categoryId,
        isRead,
      ];
}

/// Финансовое здоровье (0-100 score)
class FinancialHealth extends Equatable {
  final int score; // 0-100
  final double savingsRate; // Процент сбережений
  final double stabilityScore; // Стабильность доходов
  final double impulsiveSpendingRate; // Процент импульсивных трат
  final String assessment; // Текстовая оценка

  const FinancialHealth({
    required this.score,
    required this.savingsRate,
    required this.stabilityScore,
    required this.impulsiveSpendingRate,
    required this.assessment,
  });

  /// Получение цвета для score
  String get scoreColor {
    if (score >= 80) return 'success';
    if (score >= 60) return 'warning';
    return 'error';
  }

  @override
  List<Object?> get props => [
        score,
        savingsRate,
        stabilityScore,
        impulsiveSpendingRate,
        assessment,
      ];
}

/// Цель накоплений
class SavingsGoal extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final String? icon;
  final bool isCompleted;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    this.icon,
    this.isCompleted = false,
  });

  /// Расчет прогресса (0.0 - 1.0)
  double get progress {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  /// Остаток до цели
  double get remaining => targetAmount - currentAmount;

  /// Расчет требуемого ежемесячного платежа
  double get requiredMonthlyPayment {
    if (deadline == null || deadline!.isBefore(DateTime.now())) {
      return remaining;
    }
    final monthsLeft = deadline!.difference(DateTime.now()).inDays ~/ 30;
    if (monthsLeft <= 0) return remaining;
    return remaining / monthsLeft;
  }

  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? icon,
    bool? isCompleted,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        currentAmount,
        deadline,
        icon,
        isCompleted,
      ];
}

/// Вклад (депозит)
class Deposit extends Equatable {
  final String id;
  final String name;
  final double initialAmount;
  final double annualRate; // Годовая ставка (например, 0.14 = 14%)
  final int termMonths; // Срок в месяцах
  final bool isCompound; // Сложный процент или нет
  final DateTime startDate;

  const Deposit({
    required this.id,
    required this.name,
    required this.initialAmount,
    required this.annualRate,
    required this.termMonths,
    this.isCompound = true,
    required this.startDate,
  });

  /// Расчет итоговой суммы
  double get finalAmount {
    if (isCompound) {
      // Сложный процент: A = P * (1 + r/n)^(n*t)
      // n = 12 (ежемесячная капитализация)
      final monthlyRate = annualRate / 12;
      return initialAmount * 
          _pow(1 + monthlyRate, termMonths);
    } else {
      // Простой процент
      return initialAmount * (1 + annualRate * (termMonths / 12));
    }
  }

  /// Доход по вкладу
  double get profit => finalAmount - initialAmount;

  /// Helper для степени (т.к. dart:math может быть недоступен в некоторых контекстах)
  double _pow(double base, int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  Deposit copyWith({
    String? id,
    String? name,
    double? initialAmount,
    double? annualRate,
    int? termMonths,
    bool? isCompound,
    DateTime? startDate,
  }) {
    return Deposit(
      id: id ?? this.id,
      name: name ?? this.name,
      initialAmount: initialAmount ?? this.initialAmount,
      annualRate: annualRate ?? this.annualRate,
      termMonths: termMonths ?? this.termMonths,
      isCompound: isCompound ?? this.isCompound,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        initialAmount,
        annualRate,
        termMonths,
        isCompound,
        startDate,
      ];
}
