import '../entities/transaction.dart';
import '../entities/category.dart';

/// Абстрактный репозиторий транзакций
abstract class TransactionRepository {
  /// Поток всех транзакций (для реактивного UI)
  Stream<List<Transaction>> get transactionsStream;

  /// Получить все транзакции (однократно)
  Future<List<Transaction>> getAllTransactions();

  /// Получить транзакции за период
  Future<List<Transaction>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  );

  /// Добавить транзакцию (с автоматической категоризацией)
  Future<void> addTransaction(Transaction transaction);

  /// Обновить транзакцию
  Future<void> updateTransaction(Transaction transaction);

  /// Удалить транзакцию
  Future<void> deleteTransaction(String id);

  /// Получить транзакцию по ID
  Future<Transaction?> getTransactionById(String id);
}

/// Абстрактный репозиторий категорий
abstract class CategoryRepository {
  /// Поток всех категорий
  Stream<List<Category>> get categoriesStream;

  /// Получить все категории
  Future<List<Category>> getAllCategories();

  /// Получить категорию по ID
  Future<Category?> getCategoryById(String id);

  /// Добавить пользовательскую категорию
  Future<void> addCategory(Category category);

  /// Обновить категорию
  Future<void> updateCategory(Category category);

  /// Удалить категорию (только пользовательские)
  Future<void> deleteCategory(String id);

  /// Получить категории по типу
  Future<List<Category>> getCategoriesByType(CategoryType type);
}
