import 'package:equatable/equatable.dart';

/// Тип категории для группировки
enum CategoryType {
  food,           // Еда (включая Kaspi, Magnum)
  transport,      // Транспорт
  entertainment,  // Развлечения
  shopping,       // Покупки
  bills,          // Счета и коммунальные услуги
  health,         // Здоровье
  education,      // Образование
  salary,         // Зарплата (доход)
  investment,     // Инвестиции (доход)
  other,          // Другое
  cash,           // Наличные (KZ специфика)
  installment,    // Рассрочка (KZ специфика)
}

/// Сущность Категории
class Category extends Equatable {
  final String id;
  final String name;
  final CategoryType type;
  final String icon;
  final List<String> keywords; // Для авто-классификации
  final bool isSystem; // Системная категория (нельзя удалить)

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.keywords,
    this.isSystem = false,
  });

  Category copyWith({
    String? id,
    String? name,
    CategoryType? type,
    String? icon,
    List<String>? keywords,
    bool? isSystem,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      keywords: keywords ?? this.keywords,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  List<Object?> get props => [id, name, type, icon, keywords, isSystem];
}

/// Предустановленные категории для Казахстана
class KZCategories {
  KZCategories._();

  static const List<Category> defaults = [
    Category(
      id: 'food',
      name: 'Еда',
      type: CategoryType.food,
      icon: '🍔',
      keywords: ['magnum', 'kaspi', 'еда', 'продукты', 'ресторан', 'доставка'],
      isSystem: true,
    ),
    Category(
      id: 'transport',
      name: 'Транспорт',
      type: CategoryType.transport,
      icon: '🚗',
      keywords: ['taxi', 'inDrive', 'Яндекс', 'топливо', 'заправка', 'автобус'],
      isSystem: true,
    ),
    Category(
      id: 'cash',
      name: 'Наличные',
      type: CategoryType.cash,
      icon: '💵',
      keywords: ['наличные', 'cash', 'снятие', 'банкомат'],
      isSystem: true,
    ),
    Category(
      id: 'installment',
      name: 'Рассрочка',
      type: CategoryType.installment,
      icon: '📅',
      keywords: ['рассрочка', 'платеж', 'кредит', 'bank'],
      isSystem: true,
    ),
    Category(
      id: 'salary',
      name: 'Зарплата',
      type: CategoryType.salary,
      icon: '💰',
      keywords: ['зарплата', 'salary', 'перевод', 'поступление'],
      isSystem: true,
    ),
    Category(
      id: 'entertainment',
      name: 'Развлечения',
      type: CategoryType.entertainment,
      icon: '🎬',
      keywords: ['кино', 'парк', 'игра', 'подписка', 'Netflix', 'Spotify'],
      isSystem: true,
    ),
    Category(
      id: 'shopping',
      name: 'Покупки',
      type: CategoryType.shopping,
      icon: '🛍️',
      keywords: ['kaspi shop', 'wildberries', 'ozon', 'одежда', 'техника'],
      isSystem: true,
    ),
    Category(
      id: 'bills',
      name: 'Счета',
      type: CategoryType.bills,
      icon: '📄',
      keywords: ['коммуналка', 'свет', 'вода', 'газ', 'интернет', 'телефон'],
      isSystem: true,
    ),
  ];
}
