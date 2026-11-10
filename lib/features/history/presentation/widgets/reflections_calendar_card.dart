import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_translations.dart';
import '../../../../core/ui/twilight_scaffold.dart';

/// Scenic twilight mountain, lake reflection, and foliage banner with greeting & date.
class TwilightLakeHeaderBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;

  const TwilightLakeHeaderBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _TwilightLakeBannerPainter()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.warmWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.softLavender.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TwilightLakeBannerPainter extends CustomPainter {
  const _TwilightLakeBannerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    // Sunset-purple-pink sky gradient
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF28204B),
            Color(0xFF6B4984),
            Color(0xFFD27D76),
            Color(0xFF1E1A3A),
          ],
          stops: [0.0, 0.38, 0.68, 1.0],
        ).createShader(rect),
    );

    // Glowing sunset orb
    canvas.drawCircle(
      Offset(w * 0.72, h * 0.42),
      w * 0.08,
      Paint()..color = AppColors.premiumGold.withValues(alpha: 0.85),
    );

    // Mountain silhouettes
    final mtn = Path()
      ..moveTo(0, h * 0.66)
      ..lineTo(w * 0.24, h * 0.36)
      ..lineTo(w * 0.48, h * 0.56)
      ..lineTo(w * 0.76, h * 0.32)
      ..lineTo(w, h * 0.52)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mtn, Paint()..color = const Color(0xFF221C42));

    // Calm lake water & dark foreground vignette
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.64, w, h * 0.36),
      Paint()..color = const Color(0xCC171530),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 7-day horizontal week strip with rounded pill highlight on the active day.
class HorizontalWeekStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final List<DateTime> entryDates;

  const HorizontalWeekStrip({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    this.entryDates = const [],
  });

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekdayLabel(BuildContext context, int weekday) {
    const keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return AppTranslations.tr(context, keys[(weekday - 1) % 7]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayLabelColor = isDark
        ? AppColors.softLavender
        : AppColors.lightMuted;
    final dayNumberColor = isDark ? Colors.white : AppColors.lightText;
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday % 7),
    );
    final days = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isSelected = _sameDay(day, selectedDate);
        final hasEntry = entryDates.any((d) => _sameDay(d, day));
        return GestureDetector(
          onTap: () => onSelectDate(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.lavender.withValues(alpha: 0.28)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.transparent),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? AppColors.brightLavender
                    : (isDark
                          ? AppColors.darkBorder.withValues(alpha: 0.18)
                          : Colors.transparent),
                width: 1.4,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _weekdayLabel(context, day.weekday),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : dayLabelColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : dayNumberColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasEntry
                        ? AppColors.premiumGold
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Interactive monthly reflections calendar with circular active highlight & entry dots.
class ReflectionsMonthlyCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final List<DateTime> entryDates;

  const ReflectionsMonthlyCalendar({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.entryDates,
  });

  @override
  State<ReflectionsMonthlyCalendar> createState() =>
      _ReflectionsMonthlyCalendarState();
}

class _ReflectionsMonthlyCalendarState
    extends State<ReflectionsMonthlyCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday;
    final leadingBlanks = firstWeekday - 1;

    return FrostedGlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  );
                }),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_focusedMonth),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () => setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  );
                }),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingBlanks + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final dayNum = index - leadingBlanks + 1;
              final date = DateTime(
                _focusedMonth.year,
                _focusedMonth.month,
                dayNum,
              );
              final isSelected = _sameDay(date, widget.selectedDate);
              final hasEntry = widget.entryDates.any((d) => _sameDay(d, date));

              return GestureDetector(
                onTap: () => widget.onSelectDate(date),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: AppColors.brightLavender,
                            width: 1.6,
                          )
                        : null,
                    color: isSelected
                        ? AppColors.lavender.withValues(alpha: 0.18)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.lightText,
                        ),
                      ),
                      if (hasEntry)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.premiumGold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
