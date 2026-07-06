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
      curve: widget.style.fadeCurve,
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
    final step = widget.step;
    final spotlightRect =
        step.resolveSpotlightRect(offset & size, style);
    final spotlightGap = step.resolveSpotlightGap(style);
    final tooltipColor = style.tooltipBackgroundColor ??
        Theme.of(context).colorScheme.surface;
    final arrowColor = style.tooltipArrowColor ?? tooltipColor;

    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final isMobile = maxWidth < style.mobileBreakpoint;
          final triangleLeft = offset.dx +
              (size.width / 2) -
              (style.triangleWidth / 2);
          final pointerUp = offset.dy < maxHeight / 2;

          return Stack(
            children: [
              _BackdropLayer(
                fadeAnimation: _fadeAnimation,
                style: style,
                step: step,
                spotlightRect: spotlightRect,
                onTap: style.dismissOnBackdropTap ? widget.onNext : null,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              if (style.showTooltipArrow)
                _TooltipPointer(
                  fadeAnimation: _fadeAnimation,
                  style: style,
                  triangleLeft: triangleLeft,
                  offset: offset,
                  size: size,
                  maxHeight: maxHeight,
                  pointerUp: pointerUp,
                  gap: spotlightGap,
                  color: arrowColor,
                ),
              _TooltipCard(
                fadeAnimation: _fadeAnimation,
                style: style,
                step: step,
                stepCount: widget.stepCount,
                stepIndex: widget.stepIndex,
                offset: offset,
                size: size,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                isMobile: isMobile,
                gap: spotlightGap,
                tooltipColor: tooltipColor,
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
    required this.step,
    required this.spotlightRect,
    required this.onTap,
    required this.maxWidth,
    required this.maxHeight,
  });

  final Animation<double> fadeAnimation;
  final FlowShowcaseStyle style;
  final FlowShowcaseStep step;
  final Rect spotlightRect;
  final VoidCallback? onTap;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final overlayColor = step.resolveOverlayColor(style);
    final borderRadius = step.resolveSpotlightBorderRadius(style);

    Widget backdrop = ColoredBox(color: overlayColor);
    if (style.enableBlur && style.blurSigma > 0) {
      backdrop = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: style.blurSigma,
          sigmaY: style.blurSigma,
        ),
        child: backdrop,
      );
    }

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
              borderRadius: borderRadius,
            ),
            child: backdrop,
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
    required this.gap,
    required this.color,
  });

  final Animation<double> fadeAnimation;
  final FlowShowcaseStyle style;
  final double triangleLeft;
  final Offset offset;
  final Size size;
  final double maxHeight;
  final bool pointerUp;
  final double gap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: triangleLeft,
      top: pointerUp ? offset.dy + size.height + gap : null,
      bottom: pointerUp ? null : maxHeight - offset.dy + gap,
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
    required this.gap,
    required this.tooltipColor,
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
  final double gap;
  final Color tooltipColor;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final ValueChanged<int> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final pointerUp = offset.dy < maxHeight / 2;
    final isLastStep = stepIndex >= stepCount - 1;
    final showIndicator = stepCount > 1 && style.showStepIndicator;
    final showSkip = stepCount > 1 && style.showSkipButton;
    final headerIcon = step.icon ?? style.defaultIcon;
    final arrowHeight =
        style.showTooltipArrow ? style.triangleHeight : 0.0;
    final sectionSpacing = style.tooltipSectionSpacing;
    final indicatorActiveColor =
        style.stepIndicatorActiveColor ?? primary;
    final indicatorInactiveColor = style.stepIndicatorInactiveColor ??
        primary.withValues(alpha: 0.3);
    final headerForeground =
        style.headerIconForegroundColor ?? primary;
    final headerBackground = style.headerIconBackgroundColor ??
        primary.withValues(alpha: 0.15);

    return Positioned(
      top: pointerUp
          ? offset.dy + size.height + arrowHeight + gap
          : null,
      bottom: pointerUp
          ? null
          : maxHeight - offset.dy + arrowHeight + gap,
      left: _left(maxWidth, isMobile),
      right: _right(maxWidth, isMobile),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: isMobile ? style.tooltipMargin : null,
          padding: style.tooltipPadding,
          width: isMobile
              ? maxWidth - style.tooltipMargin.horizontal
              : style.tooltipWidth,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(style.tooltipBorderRadius),
            color: tooltipColor,
            boxShadow: style.resolveTooltipBoxShadow(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (style.showHeaderIcon) ...[
                    _HeaderIcon(
                      icon: headerIcon,
                      size: style.headerIconSize,
                      innerSize: style.headerIconInnerSize,
                      borderRadius: style.headerIconBorderRadius,
                      backgroundColor: headerBackground,
                      foregroundColor: headerForeground,
                    ),
                    SizedBox(width: sectionSpacing),
                  ],
                  Expanded(
                    child: Text(
                      step.title ?? style.defaultTitle,
                      style: style.titleTextStyle ??
                          theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  if (showSkip)
                    TextButton(
                      style: style.skipButtonStyle,
                      onPressed: onSkip,
                      child: Text(style.skipButtonLabel),
                    ),
                ],
              ),
              SizedBox(height: sectionSpacing),
              Text(
                step.content,
                style: style.contentTextStyle ?? theme.textTheme.bodyMedium,
              ),
              SizedBox(height: sectionSpacing),
              Row(
                children: [
                  if (showIndicator)
                    Expanded(
                      child: ShowcaseStepIndicator(
                        count: stepCount,
                        activeIndex: stepIndex,
                        onStepSelected: onStepSelected,
                        activeColor: indicatorActiveColor,
                        inactiveColor: indicatorInactiveColor,
                        dotSize: style.stepIndicatorDotSize,
                        spacing: style.stepIndicatorSpacing,
                        animationDuration:
                            style.stepIndicatorAnimationDuration,
                      ),
                    ),
                  ElevatedButton(
                    style: style.nextButtonStyle,
                    onPressed: onNext,
                    child: Text(
                      isLastStep
                          ? style.doneButtonLabel
                          : style.nextButtonLabel,
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
    return max(style.tooltipPositionInset, offset.dx);
  }

  double? _right(double maxWidth, bool isMobile) {
    if (isMobile) return 0;
    if (offset.dx < maxWidth / 2) return null;
    return max(
      maxWidth - (offset.dx + size.width),
      style.tooltipPositionInset,
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.size,
    required this.innerSize,
    required this.borderRadius,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
  });

  final Widget? icon;
  final double size;
  final double innerSize;
  final double borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: icon ??
              Icon(
                Icons.touch_app,
                size: innerSize,
                color: foregroundColor,
              ),
        ),
      ),
    );
  }
}
