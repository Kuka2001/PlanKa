import 'package:flutter/foundation.dart';
import '../domain/engines/engine_types.dart';
import '../data/local/platform_parsers.dart';

/// Factory для создания platform-specific парсера
/// НЕ использует Platform.isAndroid в бизнес-логике - только здесь в DI
TransactionSourceParser createTransactionSourceParser() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    debugPrint('[DI] Using AndroidNotificationParser');
    return AndroidNotificationParser();
  } else {
    debugPrint('[DI] Using IOSQuickInputParser');
    return IOSQuickInputParser();
  }
}
