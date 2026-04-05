import 'package:flutter_test/flutter_test.dart';
import '../lib/domain/entities/transaction.dart';
import '../lib/domain/entities/category.dart';
import '../lib/domain/entities/insight.dart';
import '../lib/data/engines/categorization_engine.dart';
import '../lib/data/engines/decision_engine.dart';

void main() {
  group('CategorizationEngine Tests', () {
    late CategorizationEngineImpl engine;

    setUp(() {
      engine = CategorizationEngineImpl(KZCategories.defaults);
    });

    test('должен классифицировать покупку в Магнуме как Еда', () {
      const description = "KASPI KZ MAGNUM 3500";
      final result = engine.categorize(description, 3500);
      
      expect(result.categoryId, equals('food'));
      expect(result.confidence, greaterThan(0));
      expect(result.matchedKeywords, contains('magnum'));
    });

    test('должен классифицировать Kaspi Shop как Покупки', () {
      const description = "Kaspi Shop покупка техники";
      final result = engine.categorize(description, 15000);
      
      expect(result.categoryId, equals('shopping'));
    });

    test('должен классифицировать такси как Транспорт', () {
      const description = "Yandex Taxi поездка";
      final result = engine.categorize(description, 2500);
      
      expect(result.categoryId, equals('transport'));
    });

    test('должен вернуть other для неизвестного описания', () {
      const description = "Неизвестная операция";
      final result = engine.categorize(description, 1000);
      
      expect(result.categoryId, equals('other'));
      expect(result.confidence, equals(0.0));
    });

    test('должен игнорировать регистр при поиске ключевых слов', () {
      const description = "kaspi kz MAGNUM продукты";
      final result = engine.categorize(description, 5000);
      
      expect(result.categoryId, equals('food'));
    });
  });

  group('DecisionEngine Tests', () {
    late DecisionEngineImpl engine;

    setUp(() {
      engine = DecisionEngineImpl();
    });

    test('должен выявить перерасход при сравнении периодов', () {
      final period1 = [
        const Transaction(
          id: '1',
          amount: 100000,
          type: TransactionType.expense,
          date: DateTime(2024, 1, 15),
          categoryId: 'food',
        ),
      ];
      
      final period2 = [
        const Transaction(
          id: '2',
          amount: 50000,
          type: TransactionType.expense,
          date: DateTime(2024, 2, 15),
          categoryId: 'food',
        ),
      ];

      final insights = engine.comparePeriods(period1, period2);
      
      expect(insights.any((i) => i.type == InsightType.warning), true);
    });

    test('должен генерировать инсайт для крупной траты', () {
      final transaction = const Transaction(
        id: '1',
        amount: 150000,
        type: TransactionType.expense,
        date: DateTime(2024, 1, 15),
        categoryId: 'shopping',
      );

      final insights = engine.analyzeTransaction(transaction);
      
      expect(insights.any((i) => i.severity == InsightSeverity.medium), true);
    });

    test('должен выявить перерасход по категории', () {
      final transactions = [
        const Transaction(id: '1', amount: 30000, type: TransactionType.expense, date: DateTime(2024, 1, 1), categoryId: 'food'),
        const Transaction(id: '2', amount: 40000, type: TransactionType.expense, date: DateTime(2024, 1, 2), categoryId: 'food'),
        const Transaction(id: '3', amount: 50000, type: TransactionType.expense, date: DateTime(2024, 1, 3), categoryId: 'food'),
      ];

      final insights = engine.analyzeOverspending(transactions, 'food', 100000);
      
      expect(insights.isNotEmpty, true);
      expect(insights.first.type, InsightType.warning);
    });
  });

  group('BehavioralEngine Tests', () {
    late BehavioralEngineImpl engine;

    setUp(() {
      engine = BehavioralEngineImpl();
    });

    test('должен помечать ночные траты как импульсивные', () {
      final nightTx = const Transaction(
        id: '1',
        amount: 5000,
        type: TransactionType.expense,
        date: DateTime(2024, 1, 15, 23, 30), // 23:30 - ночь
        categoryId: 'food',
      );

      final flags = engine.analyzeTransaction(nightTx);
      
      expect(flags.isNightTransaction, true);
      expect(flags.isImpulsive, true);
    });

    test('не должен помечать дневные траты как ночные', () {
      final dayTx = const Transaction(
        id: '1',
        amount: 5000,
        type: TransactionType.expense,
        date: DateTime(2024, 1, 15, 14, 30), // 14:30 - день
        categoryId: 'food',
      );

      final flags = engine.analyzeTransaction(dayTx);
      
      expect(flags.isNightTransaction, false);
    });

    test('должен помечать выходные дни', () {
      // Суббота
      expect(engine.isWeekend(DateTime(2024, 1, 13)), true);
      // Воскресенье
      expect(engine.isWeekend(DateTime(2024, 1, 14)), true);
      // Понедельник
      expect(engine.isWeekend(DateTime(2024, 1, 15)), false);
    });

    test('должен помечать крупные траты в выходные как импульсивные', () {
      final weekendTx = const Transaction(
        id: '1',
        amount: 60000, // > 50000
        type: TransactionType.expense,
        date: DateTime(2024, 1, 13, 15, 0), // Суббота
        categoryId: 'shopping',
      );

      final flags = engine.analyzeTransaction(weekendTx);
      
      expect(flags.isWeekendTransaction, true);
      expect(flags.isImpulsive, true);
    });
  });

  group('SimulationEngine Tests', () {
    late SimulationEngineImpl engine;

    setUp(() {
      engine = SimulationEngineImpl();
    });

    test('расчет вклада со сложным процентом должен быть корректным', () {
      final result = engine.calculateDeposit(
        initialAmount: 100000,
        annualRate: 0.14, // 14% годовых
        months: 12,
        isCompound: true,
      );

      expect(result.finalAmount, greaterThan(100000));
      expect(result.profit, greaterThan(0));
      // Сложный процент должен дать больше чем простой
      expect(result.finalAmount, greaterThan(114000));
    });

    test('расчет плана накоплений должен вернуть корректные значения', () {
      final deadline = DateTime.now().add(const Duration(days: 365)); // 1 год
      
      final result = engine.calculateSavingsPlan(
        targetAmount: 1200000,
        currentAmount: 0,
        deadline: deadline,
      );

      expect(result.remaining, equals(1200000));
      expect(result.monthsToGoal, greaterThan(0));
      expect(result.requiredMonthlyPayment, greaterThan(0));
      // Примерно 100k в месяц на год
      expect(result.requiredMonthlyPayment, closeTo(100000, 10000));
    });

    test('расчет с досрочным достижением цели', () {
      final result = engine.calculateSavingsPlan(
        targetAmount: 100000,
        currentAmount: 150000, // Уже больше цели
        deadline: DateTime.now().add(const Duration(days: 365)),
      );

      expect(result.remaining, equals(0));
      expect(result.monthsToGoal, equals(0));
      expect(result.isAchievable, true);
    });

    test('расчет с прошедшим дедлайном', () {
      final result = engine.calculateSavingsPlan(
        targetAmount: 100000,
        currentAmount: 50000,
        deadline: DateTime.now().subtract(const Duration(days: 30)), // Прошел
      );

      expect(result.isAchievable, false);
      expect(result.requiredMonthlyPayment, equals(50000));
    });
  });

  group('FinancialHealth Score Tests', () {
    late CalculateFinancialScoreUseCase useCase;

    setUp(() {
      useCase = const CalculateFinancialScoreUseCase();
    });

    test('высокий скор при высоком сбережении и стабильности', () {
      final transactions = List.generate(
        10,
        (i) => Transaction(
          id: '$i',
          amount: 10000,
          type: i.isEven ? TransactionType.income : TransactionType.expense,
          date: DateTime(2024, 1, i + 1),
          categoryId: 'food',
          isImpulsive: false,
        ),
      );

      final health = useCase.execute(
        transactions: transactions,
        totalIncome: 100000,
        totalExpenses: 50000, // 50% savings rate
      );

      expect(health.score, greaterThan(70));
      expect(health.savingsRate, greaterThan(0.4));
    });

    test('низкий скор при высоких импульсивных тратах', () {
      final transactions = List.generate(
        10,
        (i) => Transaction(
          id: '$i',
          amount: 10000,
          type: TransactionType.expense,
          date: DateTime(2024, 1, i + 1, 23, 0), // Ночью
          categoryId: 'food',
          isImpulsive: true, // Все импульсивные
        ),
      );

      final health = useCase.execute(
        transactions: transactions,
        totalIncome: 100000,
        totalExpenses: 90000, // Низкий savings rate
      );

      expect(health.impulsiveSpendingRate, greaterThan(0.8));
      expect(health.score, lessThan(50));
    });

    test('дефолтный скор для пустых данных', () {
      final health = useCase.execute(
        transactions: [],
        totalIncome: 0,
        totalExpenses: 0,
      );

      expect(health.score, equals(50));
      expect(health.assessment, contains('Начните'));
    });
  });
}
