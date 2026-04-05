import 'package:flutter/foundation.dart';

/// Platform-specific парсер для Android
/// Парсит уведомления от банков (Kaspi, Halyk и др.)
class AndroidNotificationParser implements TransactionSourceParser {
  // Паттерны для казахстанских банков
  static final _kaspiPattern = RegExp(
    r'Kaspi\.kz.*?(\d[\d\s]*[.,]?\d*)\s*₸?\s*(.+)',
    caseSensitive: false,
  );
  
  static final _halykPattern = RegExp(
    r'Halyk.*?(\d[\d\s]*[.,]?\d*)\s*₸?\s*(.+)',
    caseSensitive: false,
  );

  @override
  bool canParse(dynamic input) {
    if (input is! String) return false;
    final lower = input.toLowerCase();
    return lower.contains('kaspi') || 
           lower.contains('halyk') || 
           lower.contains('уведомление');
  }

  @override
  Future<Transaction?> parseInput(dynamic input) async {
    if (!canParse(input)) return null;

    final text = input.toString();
    
    // Пробуем разные паттерны
    Transaction? result;
    
    result = _parseKaspi(text);
    if (result != null) return result;
    
    result = _parseHalyk(text);
    if (result != null) return result;
    
    // Общий парсинг
    return _parseGeneric(text);
  }

  Transaction? _parseKaspi(String text) {
    final match = _kaspiPattern.firstMatch(text);
    if (match == null) return null;

    final amountStr = match.group(1)?.replaceAll(' ', '').replaceAll(',', '.');
    final description = match.group(2)?.trim();
    
    if (amountStr == null) return null;

    final amount = double.tryParse(amountStr);
    if (amount == null) return null;

    return Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: amount > 0 ? TransactionType.income : TransactionType.expense,
      date: DateTime.now(),
      categoryId: '', // Будет определен CategorizationEngine
      description: description ?? text,
      source: TransactionSource.notification_import,
    );
  }

  Transaction? _parseHalyk(String text) {
    final match = _halykPattern.firstMatch(text);
    if (match == null) return null;

    final amountStr = match.group(1)?.replaceAll(' ', '').replaceAll(',', '.');
    final description = match.group(2)?.trim();
    
    if (amountStr == null) return null;

    final amount = double.tryParse(amountStr);
    if (amount == null) return null;

    return Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: amount > 0 ? TransactionType.income : TransactionType.expense,
      date: DateTime.now(),
      categoryId: '',
      description: description ?? text,
      source: TransactionSource.notification_import,
    );
  }

  Transaction? _parseGeneric(String text) {
    // Ищем сумму в тексте (простой паттерн)
    final amountPattern = RegExp(r'(\d[\d\s]*[.,]?\d*)\s*₸');
    final match = amountPattern.firstMatch(text);
    
    if (match == null) return null;

    final amountStr = match.group(1)?.replaceAll(' ', '').replaceAll(',', '.');
    final amount = double.tryParse(amountStr ?? '');
    
    if (amount == null) return null;

    return Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.abs(),
      type: text.contains('-') || text.contains('расход') 
          ? TransactionType.expense 
          : TransactionType.income,
      date: DateTime.now(),
      categoryId: '',
      description: text,
      source: TransactionSource.notification_import,
    );
  }
}

/// Platform-specific парсер для iOS
/// Парсит быстрый ввод пользователя ("5000 еда", "3500 такси")
class IOSQuickInputParser implements TransactionSourceParser {
  // Словарь для маппинга ключевых слов на категории
  static const _categoryKeywords = {
    'еда': 'food',
    'есть': 'food',
    'magnum': 'food',
    'продукт': 'food',
    'ресторан': 'food',
    'кафе': 'food',
    'транспорт': 'transport',
    'такси': 'transport',
    'inDrive': 'transport',
    'яндекс': 'transport',
    'топливо': 'transport',
    'заправка': 'transport',
    'развлечение': 'entertainment',
    'кино': 'entertainment',
    'парк': 'entertainment',
    'покупк': 'shopping',
    'одежда': 'shopping',
    'техника': 'shopping',
    'kaspi shop': 'shopping',
    'счет': 'bills',
    'коммуналк': 'bills',
    'свет': 'bills',
    'вода': 'bills',
    'интернет': 'bills',
    'наличн': 'cash',
    'банкомат': 'cash',
    'рассрочк': 'installment',
    'кредит': 'installment',
    'зарплат': 'salary',
    'перевод': 'salary',
  };

  @override
  bool canParse(dynamic input) {
    if (input is! String) return false;
    // iOS быстрый ввод: начинается с числа
    final trimmed = input.trim();
    return RegExp(r'^\d').hasMatch(trimmed);
  }

  @override
  Future<Transaction?> parseInput(dynamic input) async {
    if (!canParse(input)) return null;

    final text = input.toString().trim();
    
    // Парсим: "5000 еда" или "5000.50 еда" или "-3500 такси"
    final pattern = RegExp(r'^(-?\d+(?:[.,]\d+)?)\s*(.*)$');
    final match = pattern.firstMatch(text);
    
    if (match == null) return null;

    final amountStr = match.group(1)?.replaceAll(',', '.');
    var description = match.group(2)?.trim() ?? '';
    
    final amount = double.tryParse(amountStr ?? '');
    if (amount == null) return null;

    // Определяем категорию по ключевым словам
    String categoryId = 'other';
    final lowerDesc = description.toLowerCase();
    
    for (final entry in _categoryKeywords.entries) {
      if (lowerDesc.contains(entry.key)) {
        categoryId = entry.value;
        break;
      }
    }

    // Если категория не найдена, пробуем угадать по первым буквам
    if (categoryId == 'other' && description.isNotEmpty) {
      categoryId = _quickGuessCategory(description);
    }

    return Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount.abs(),
      type: amount < 0 ? TransactionType.expense : TransactionType.income,
      date: DateTime.now(),
      categoryId: categoryId,
      description: description.isEmpty ? null : description,
      source: TransactionSource.manual,
    );
  }

  String _quickGuessCategory(String input) {
    final firstWord = input.split(' ').first.toLowerCase();
    
    if (firstWord.length <= 3) {
      // Очень короткое слово - возможно код категории
      switch (firstWord) {
        case 'еда':
        case 'ед':
          return 'food';
        case 'такси':
        case 'тр':
          return 'transport';
        case 'магаз':
        case 'пок':
          return 'shopping';
        default:
          return 'other';
      }
    }
    
    return 'other';
  }
}
