import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying circular progress indicator for today's energy level
class EnergyProgressWidget extends StatefulWidget {
  final double energyLevel;
  final VoidCallback onTap;

  const EnergyProgressWidget({
    super.key,
    required this.energyLevel,
    required this.onTap,
  });

  @override
  State<EnergyProgressWidget> createState() => _EnergyProgressWidgetState();
}

class _EnergyProgressWidgetState extends State<EnergyProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.energyLevel / 100).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(EnergyProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.energyLevel != widget.energyLevel) {
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.energyLevel / 100,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.light
                  ? theme.shadowColor.withOpacity(0.08)
                  : theme.shadowColor.withOpacity(0.18),
              blurRadius: theme.brightness == Brightness.light ? 4 : 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 55.w,
                  height: 55.w,
                  child: CircularProgressIndicator(
                    value: _progressAnimation.value,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.outline,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getEnergyColor(widget.energyLevel),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.energyLevel.toInt()}%',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Energy Level',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tap to update',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _getEnergyColor(double level) {
    final colorScheme = Theme.of(context).colorScheme;
    if (level >= 80) return colorScheme.secondary;
    if (level >= 60) return colorScheme.primary;
    if (level >= 40) return colorScheme.secondaryContainer;
    return colorScheme.error;
  }
}
