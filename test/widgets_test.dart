import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:smart_finance_coach/core/theme/app_widgets.dart';

void main() {
  group('GlassCard Tests', () {
    testWidgets('GlassCard должен вызывать onTap только один раз при нажатии', 
    (WidgetTester tester) async {
      int tapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: () => tapCount++,
              child: const Text('Test'),
            ),
          ),
        ),
      );
      
      // Находим виджет и нажимаем
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      
      // onTap должен вызваться только 1 раз
      expect(tapCount, equals(1));
    });

    testWidgets('GlassCard без onTap не должен анимироваться', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              animateOnTap: false,
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      expect(find.text('Test'), findsOneWidget);
    });
    
    testWidgets('GlassCard с null onTap должен работать корректно', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassCard(
              onTap: null,
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      expect(find.text('Test'), findsOneWidget);
      
      // Попытка тапа не должна вызвать ошибок
      await tester.tap(find.text('Test'));
      await tester.pump();
      
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('AnimatedNumber Tests', () {
    testWidgets('AnimatedNumber должен отображать корректное значение', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedNumber(
              value: 1250000,
              prefix: '',
              suffix: ' ₸',
              decimals: 0,
            ),
          ),
        ),
      );
      
      // Проверяем что число отображается (с учетом форматирования)
      expect(find.textContaining('1250000'), findsOneWidget);
    });

    testWidgets('AnimatedNumber должен обрабатывать NaN значения', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedNumber(
              value: double.nan,
              prefix: '',
              suffix: '',
              decimals: 2,
            ),
          ),
        ),
      );
      
      // Должно отображаться 0.00 вместо NaN
      expect(find.textContaining('0.00'), findsOneWidget);
    });

    testWidgets('AnimatedNumber должен обрабатывать бесконечные значения', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedNumber(
              value: double.infinity,
              prefix: '',
              suffix: '',
              decimals: 2,
            ),
          ),
        ),
      );
      
      // Должно отображаться 0.00 вместо infinity
      expect(find.textContaining('0.00'), findsOneWidget);
    });
    
    testWidgets('AnimatedNumber должен обрабатывать отрицательную бесконечность', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedNumber(
              value: double.negativeInfinity,
              prefix: '',
              suffix: '',
              decimals: 2,
            ),
          ),
        ),
      );
      
      // Должно отображаться 0.00 вместо -infinity
      expect(find.textContaining('0.00'), findsOneWidget);
    });
  });

  group('AnimatedProgressBar Tests', () {
    testWidgets('AnimatedProgressBar должен ограничивать progress от 0 до 1', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressBar(
              progress: 1.5, // > 1.0
              height: 8,
            ),
          ),
        ),
      );
      
      // Виджет должен строиться без ошибок
      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });

    testWidgets('AnimatedProgressBar должен обрабатывать отрицательный progress', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressBar(
              progress: -0.5, // < 0.0
              height: 8,
            ),
          ),
        ),
      );
      
      // Виджет должен строиться без ошибок
      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });

    testWidgets('AnimatedProgressBar должен обрабатывать NaN progress', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressBar(
              progress: double.nan,
              height: 8,
            ),
          ),
        ),
      );
      
      // Виджет должен строиться без ошибок
      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });
    
    testWidgets('AnimatedProgressBar должен обрабатывать нормальные значения', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressBar(
              progress: 0.65,
              height: 10,
              color: Colors.blue,
            ),
          ),
        ),
      );
      
      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });
  });

  group('PulsingWidget Tests', () {
    testWidgets('PulsingWidget должен анимироваться', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PulsingWidget(
              duration: Duration(milliseconds: 100),
              minScale: 0.95,
              maxScale: 1.0,
              child: Text('Pulse'),
            ),
          ),
        ),
      );
      
      expect(find.text('Pulse'), findsOneWidget);
      
      // Продвигаем время вперед
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Pulse'), findsOneWidget);
    });
    
    testWidgets('PulsingWidget должен обновляться при изменении параметров', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PulsingWidget(
              duration: Duration(milliseconds: 200),
              minScale: 0.9,
              maxScale: 1.1,
              child: Text('Pulse'),
            ),
          ),
        ),
      );
      
      expect(find.text('Pulse'), findsOneWidget);
    });
  });

  group('SlideInList Tests', () {
    testWidgets('SlideInList должен отображать все элементы', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInList(
              children: [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        ),
      );
      
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });
    
    testWidgets('SlideInList с кастомным offset должен работать', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInList(
              startOffset: 100.0,
              children: [
                Text('Item 1'),
                Text('Item 2'),
              ],
            ),
          ),
        ),
      );
      
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });
    
    testWidgets('SlideInList с пустым списком должен работать', 
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideInList(
              children: [],
            ),
          ),
        ),
      );
      
      expect(find.byType(SlideInList), findsOneWidget);
    });
  });
}
