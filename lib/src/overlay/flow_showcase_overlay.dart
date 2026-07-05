import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../clippers/inverted_spotlight_clipper.dart';
import '../models/flow_showcase_step.dart';
import '../models/flow_showcase_style.dart';
import '../painters/spotlight_arrow_painter.dart';
import '../widgets/showcase_step_indicator.dart';

/// Full-screen overlay that spotlights a target and shows step content.
class FlowShowcaseOverlay extends StatefulWidget {
  const FlowShowcaseOverlay({
    super.key,
    required this.step,
    required this.onNext,
    required this.onSkip,
    required this.stepCount,
    required this.stepIndex,
    required this.onStepSelected,
    required this.style,
  });

  final FlowShowcaseStep step;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int stepCount;
  final int stepIndex;
  final ValueChanged<int> onStepSelected;
  final FlowShowcaseStyle style;

  @override
  State<FlowShowcaseOverlay> createState() => _FlowShowcaseOverlayState();
}

class _FlowShowcaseOverlayState extends State<FlowShowcaseOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: widget.style.fadeDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetContext = widget.step.key.currentContext;
    if (targetContext == null) {
      return const SizedBox.shrink();
    }

    final renderBox = targetContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return const SizedBox.shrink();
    }

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final style = widget.style;

    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final isMobile = maxWidth < style.mobileBreakpoint;
          final triangleLeft =
              offset.dx + (size.width / 2) - (style.triangleWidth / 2);
          final pointerUp = offset.dy < maxHeight / 2;
          final arrowColor = Theme.of(context).colorScheme.surface;

          return Stack(
            children: [
              _BackdropLayer(
                fadeAnimation: _fadeAnimation,
                style: style,
                spotlightRect: offset & size,
                onTap: widget.onNext,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              _TooltipPointer(
                fadeAnimation: _fadeAnimation,
                style: style,
                triangleLeft: triangleLeft,
                offset: offset,
                size: size,
                maxHeight: maxHeight,
                pointerUp: pointerUp,
                color: arrowColor,
              ),
              _TooltipCard(
                fadeAnimation: _fadeAnimation,
                style: style,
                step: widget.step,
                stepCount: widget.stepCount,
                stepIndex: widget.stepIndex,
                offset: offset,
                size: size,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                isMobile: isMobile,
                onNext: widget.onNext,
                onSkip: widget.onSkip,
                onStepSelected: widget.onStepSelected,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BackdropLayer extends StatelessWidget {
  const _BackdropLayer({
    required this.fadeAnimation,
    required this.style,
    required this.spotlightRect,
    required this.onTap,
    required this.maxWidth,
    required this.maxHeight,
  });

  final Animation<double> fadeAnimation;
  final FlowShowcaseStyle style;
  final Rect spotlightRect;
  final VoidCallback onTap;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: GestureDetector(
          onTap: onTap,
          child: ClipPath(
            clipper: InvertedSpotlightClipper(
              spotlightRect: spotlightRect,
              borderRadius: style.spotlightBorderRadius,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: style.blurSigma,
                sigmaY: style.blurSigma,
              ),
              child: ColoredBox(color: style.overlayColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _TooltipPointer extends StatelessWidget {
  const _TooltipPointer({
    required this.fadeAnimation,
    required this.style,
    required this.triangleLeft,
    required this.offset,
    required this.size,
    required this.maxHeight,
    required this.pointerUp,
    required this.color,
  });

  final Animation<double> fadeAnimation;
  final FlowShowcaseStyle style;
  final double triangleLeft;
  final Offset offset;
  final Size size;
  final double maxHeight;
  final bool pointerUp;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final padding = style.spotlightPadding;

    return Positioned(
      left: triangleLeft,
      top: pointerUp ? offset.dy + size.height + padding : null,
      bottom: pointerUp ? null : maxHeight - offset.dy + padding,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: CustomPaint(
          painter: SpotlightArrowPainter(
            color: color,
            isUpArrow: pointerUp,
          ),
          size: Size(style.triangleWidth, style.triangleHeight),
        ),
      ),
    );
  }
}

class _TooltipCard extends StatelessWidget {
  const _TooltipCard({
    required this.fadeAnimation,
    required this.style,
    required this.step,
    required this.stepCount,
    required this.stepIndex,
    required this.offset,
    required this.size,
    required this.maxWidth,
    required this.maxHeight,
    required this.isMobile,
    required this.onNext,
    required this.onSkip,
    required this.onStepSelected,
  });

  final Animation<double> fadeAnimation;
  final FlowShowcaseStyle style;
  final FlowShowcaseStep step;
  final int stepCount;
  final int stepIndex;
  final Offset offset;
  final Size size;
  final double maxWidth;
  final double maxHeight;
  final bool isMobile;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final padding = style.spotlightPadding;
    final pointerUp = offset.dy < maxHeight / 2;
    final isLastStep = stepIndex >= stepCount - 1;

    return Positioned(
      top: pointerUp
          ? offset.dy + size.height + style.triangleHeight + padding
          : null,
      bottom: pointerUp
          ? null
          : maxHeight - offset.dy + style.triangleHeight + padding,
      left: _left(maxWidth, isMobile),
      right: _right(maxWidth, isMobile),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: isMobile ? style.tooltipMargin : null,
          padding: style.tooltipPadding,
          width: isMobile ? maxWidth - style.tooltipMargin.horizontal : style.tooltipWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.tooltipBorderRadius),
            color: theme.colorScheme.surface,
            boxShadow: const [
              BoxShadow(
                blurRadius: 24,
                offset: Offset(0, 8),
                color: Color(0x26000000),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _HeaderIcon(primary: primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step.title ?? style.defaultTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (stepCount > 1)
                    TextButton(
                      onPressed: onSkip,
                      child: Text(style.skipButtonLabel),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                step.content,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (stepCount > 1)
                    Expanded(
                      child: ShowcaseStepIndicator(
                        count: stepCount,
                        activeIndex: stepIndex,
                        onStepSelected: onStepSelected,
                        activeColor: primary,
                        inactiveColor: primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: onNext,
                    child: Text(
                      isLastStep ? 'Done' : style.nextButtonLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _left(double maxWidth, bool isMobile) {
    if (isMobile) return 0;
    if (offset.dx >= maxWidth / 2) return null;
    return max(6, offset.dx);
  }

  double? _right(double maxWidth, bool isMobile) {
    if (isMobile) return 0;
    if (offset.dx < maxWidth / 2) return null;
    return max(maxWidth - (offset.dx + size.width), 6);
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(Icons.touch_app, size: 20, color: primary),
      ),
    );
  }
}
