import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usecases/transaction_usecases.dart';
import '../domain/usecases/financial_score_usecase.dart';

/// Use Case providers
// В будущем будут использовать репозитории из DI

final addTransactionUseCaseProvider = Provider<AddTransactionUseCase>((ref) {
  // TODO: Inject TransactionRepository
  throw UnimplementedError('Repository not implemented yet');
});

final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  // TODO: Inject TransactionRepository
  throw UnimplementedError('Repository not implemented yet');
});

final calculateFinancialScoreUseCaseProvider = Provider<CalculateFinancialScoreUseCase>((ref) {
  return const CalculateFinancialScoreUseCase();
});
