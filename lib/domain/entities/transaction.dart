import 'package:equatable/equatable.dart';

/// Источник транзакции - критично для platform-specific логики
enum TransactionSource {
  manual,           // Ручной ввод (iOS/Android)
  notification_import, // Android: парсинг уведомлений
  csv_import,       // Импорт из CSV
}

/// Тип транзакции
enum TransactionType {
  income,
  expense,
  transfer,
}

/// Сущность Транзакции - ядро домена
class Transaction extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String categoryId;
  final String? description;
  final TransactionSource source;
  final bool isImpulsive;
  final String? notes;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.categoryId,
    this.description,
    this.source = TransactionSource.manual,
    this.isImpulsive = false,
    this.notes,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? categoryId,
    String? description,
    TransactionSource? source,
    bool? isImpulsive,
    String? notes,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      source: source ?? this.source,
      isImpulsive: isImpulsive ?? this.isImpulsive,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        type,
        date,
        categoryId,
        description,
        source,
        isImpulsive,
        notes,
      ];
}
