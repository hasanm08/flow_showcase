import 'package:flutter/material.dart';

/// Lightweight step dots without third-party dependencies.
class ShowcaseStepIndicator extends StatelessWidget {
  const ShowcaseStepIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    required this.onStepSelected,
    required this.activeColor,
    required this.inactiveColor,
    this.dotSize = 12,
    this.spacing = 8,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int> onStepSelected;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: index == count - 1 ? 0 : spacing),
          child: Semantics(
            button: true,
            selected: isActive,
            label: 'Step ${index + 1} of $count',
            child: GestureDetector(
              onTap: () => onStepSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: animationDuration,
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? activeColor : Colors.transparent,
                  border: Border.all(
                    color: isActive ? activeColor : inactiveColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
