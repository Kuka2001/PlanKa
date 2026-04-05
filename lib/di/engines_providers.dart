import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/category.dart';
import '../domain/engines/engines.dart';
import '../domain/engines/engine_types.dart';
import '../data/engines/categorization_engine.dart';
import '../data/engines/decision_engine.dart';
import '../di/platform_factory.dart';

/// Provider для списка категорий (в будущем будет загружаться из репозитория)
final categoriesProvider = Provider<List<Category>>((ref) {
  return KZCategories.defaults;
});

/// Provider для CategorizationEngine
final categorizationEngineProvider = Provider<CategorizationEngine>((ref) {
  final categories = ref.watch(categoriesProvider);
  return CategorizationEngineImpl(categories);
});

/// Provider для BehavioralEngine
final behavioralEngineProvider = Provider<BehavioralEngine>((ref) {
  return BehavioralEngineImpl();
});

/// Provider для DecisionEngine
final decisionEngineProvider = Provider<DecisionEngine>((ref) {
  return DecisionEngineImpl();
});

/// Provider для SimulationEngine
final simulationEngineProvider = Provider<SimulationEngine>((ref) {
  return SimulationEngineImpl();
});

/// Provider для platform-specific парсера транзакций
final transactionSourceParserProvider = Provider<TransactionSourceParser>((ref) {
  return createTransactionSourceParser();
});
