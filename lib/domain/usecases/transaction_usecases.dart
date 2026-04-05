import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use Case: Добавление транзакции
/// Orchestrates: categorization -> behavior analysis -> decision engine -> save
class AddTransactionUseCase {
  final TransactionRepository _repository;

  const AddTransactionUseCase(this._repository);

  Future<void> execute(Transaction transaction) async {
    // Валидация
    if (transaction.amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }

    // Сохранение через репозиторий (который вызывает engines)
    await _repository.addTransaction(transaction);
  }
}

/// Use Case: Получение списка транзакций
class GetTransactionsUseCase {
  final TransactionRepository _repository;

  const GetTransactionsUseCase(this._repository);

  Stream<List<Transaction>> execute() {
    return _repository.transactionsStream;
  }

  Future<List<Transaction>> executeOnce() {
    return _repository.getAllTransactions();
  }
}

/// Use Case: Получение транзакций за период
class GetTransactionsByPeriodUseCase {
  final TransactionRepository _repository;

  const GetTransactionsByPeriodUseCase(this._repository);

  Future<List<Transaction>> execute(DateTime start, DateTime end) {
    return _repository.getTransactionsByPeriod(start, end);
  }
}

/// Use Case: Удаление транзакции
class DeleteTransactionUseCase {
  final TransactionRepository _repository;

  const DeleteTransactionUseCase(this._repository);

  Future<void> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }
    await _repository.deleteTransaction(id);
  }
}

/// Use Case: Обновление транзакции
class UpdateTransactionUseCase {
  final TransactionRepository _repository;

  const UpdateTransactionUseCase(this._repository);

  Future<void> execute(Transaction transaction) async {
    await _repository.updateTransaction(transaction);
  }
}
