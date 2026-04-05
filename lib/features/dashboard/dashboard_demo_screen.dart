import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Демонстрационный экран Dashboard с применением темы и анимаций
class DashboardDemoScreen extends StatelessWidget {
  const DashboardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Smart Finance Coach',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Ваш финансовый помощник',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 32),
              
              // Glassmorphism Card с балансом
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Общий баланс',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    const AnimatedNumber(
                      value: 1250000,
                      prefix: '',
                      suffix: ' ₸',
                      decimals: 0,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Доходы',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                              const AnimatedNumber(
                                value: 450000,
                                prefix: '+ ',
                                suffix: ' ₸',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Расходы',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                              const AnimatedNumber(
                                value: 280000,
                                prefix: '- ',
                                suffix: ' ₸',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Financial Health Score
              Text(
                'Финансовое здоровье',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              GlassCard(
                child: Row(
                  children: [
                    // Circular progress имитация
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surfaceLight,
                                width: 8,
                              ),
                            ),
                          ),
                          PulsingWidget(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.successGradient,
                              ),
                              child: const Center(
                                child: Text(
                                  '78',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Хорошее состояние',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Вы откладываете 22% дохода — это выше среднего!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Прогресс цели
              Text(
                'Цель: Накопления',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Новый автомобиль',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text(
                          '6.5M / 10M ₸',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const AnimatedProgressBar(
                      progress: 0.65,
                      color: AppColors.primary,
                      height: 10,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Осталось 3.5M ₸ • 8 месяцев',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Insights с slide анимацией
              Text(
                'Рекомендации',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              SlideInList(
                children: [
                  _buildInsightCard(
                    context,
                    'Перерасход на еду',
                    'Вы тратите на 27% больше на рестораны чем в прошлом месяце',
                    AppColors.warning,
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    context,
                    'Отличная экономия',
                    'Вы превзошли цель по накоплениям на 15%',
                    AppColors.success,
                    Icons.celebration,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    context,
                    'Ночные покупки',
                    'Замечены импульсивные траты после 23:00',
                    AppColors.info,
                    Icons.nights_stay,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Транзакция'),
      ),
    );
  }

  Widget _buildInsightCard(
    BuildContext context,
    String title,
    String message,
    Color color,
    IconData icon,
  ) {
    return GlassCard(
      padding: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
