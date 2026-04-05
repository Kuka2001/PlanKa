import '../entities/insight.dart';

/// Абстрактный репозиторий инсайтов
abstract class InsightRepository {
  /// Поток всех инсайтов
  Stream<List<Insight>> get insightsStream;

  /// Получить все инсайты
  Future<List<Insight>> getAllInsights();

  /// Получить непрочитанные инсайты
  Future<List<Insight>> getUnreadInsights();

  /// Добавить инсайт
  Future<void> addInsight(Insight insight);

  /// Пометить инсайт как прочитанный
  Future<void> markAsRead(String id);

  /// Пометить все инсайты как прочитанные
  Future<void> markAllAsRead();

  /// Удалить инсайт
  Future<void> deleteInsight(String id);

  /// Очистить старые инсайты
  Future<void> clearOldInsights(DateTime before);
}
