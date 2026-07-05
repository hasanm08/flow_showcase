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
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int> onStepSelected;
  final Color activeColor;
  final Color inactiveColor;

  static const double _dotSize = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Padding(
          padding: EdgeInsets.only(right: index == count - 1 ? 0 : 8),
          child: Semantics(
            button: true,
            selected: isActive,
            label: 'Step ${index + 1} of $count',
            child: GestureDetector(
              onTap: () => onStepSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _dotSize,
                height: _dotSize,
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
