import 'package:flutter/material.dart';

/// Visual and behavioral configuration for a showcase overlay.
///
/// Every visual property can be overridden at runtime via [copyWith] or by
/// passing a new instance to [FlowShowcaseController].
class FlowShowcaseStyle {
  const FlowShowcaseStyle({
    this.overlayColor = const Color(0x4D000000),
    this.enableBlur = true,
    this.blurSigma = 3.9,
    this.dismissOnBackdropTap = true,
    this.spotlightBorderRadius = 8,
    this.spotlightExpand = 0,
    this.spotlightInsets = EdgeInsets.zero,
    double? spotlightGap,
    @Deprecated('Use spotlightGap instead.')
    double? spotlightPadding,
    this.tooltipBackgroundColor,
    this.tooltipBorderRadius = 8,
    this.tooltipWidth = 400,
    this.tooltipPadding = const EdgeInsets.all(24),
    this.tooltipMargin = const EdgeInsets.symmetric(horizontal: 16),
    this.tooltipBoxShadow,
    this.tooltipSectionSpacing = 16,
    this.tooltipPositionInset = 6,
    this.showTooltipArrow = true,
    this.triangleWidth = 20,
    this.triangleHeight = 10,
    this.tooltipArrowColor,
    this.mobileBreakpoint = 600,
    this.fadeDuration = const Duration(milliseconds: 350),
    this.fadeCurve = Curves.easeOut,
    this.nextButtonLabel = 'Next',
    this.doneButtonLabel = 'Done',
    this.skipButtonLabel = 'Skip All',
    this.defaultTitle = 'Need a hand?',
    this.showStepIndicator = true,
    this.showHeaderIcon = true,
    this.showSkipButton = true,
    this.defaultIcon,
    this.headerIconSize = 30,
    this.headerIconInnerSize = 20,
    this.headerIconBorderRadius = 100,
    this.headerIconBackgroundColor,
    this.headerIconForegroundColor,
    this.titleTextStyle,
    this.contentTextStyle,
    this.stepIndicatorActiveColor,
    this.stepIndicatorInactiveColor,
    this.stepIndicatorDotSize = 12,
    this.stepIndicatorSpacing = 8,
    this.stepIndicatorAnimationDuration = const Duration(milliseconds: 200),
    this.nextButtonStyle,
    this.skipButtonStyle,
  }) : spotlightGap = spotlightGap ?? spotlightPadding ?? 4;

  /// Dimmed backdrop color behind the spotlight cutout.
  final Color overlayColor;

  /// When `false`, the backdrop is a flat color without [BackdropFilter].
  final bool enableBlur;

  /// Gaussian blur strength applied when [enableBlur] is `true`.
  final double blurSigma;

  /// When `true`, tapping the dimmed backdrop advances to the next step.
  final bool dismissOnBackdropTap;

  /// Corner radius of the spotlight hole.
  final double spotlightBorderRadius;

  /// Uniform expansion applied around the target before cutting the hole.
  final double spotlightExpand;

  /// Asymmetric expansion around the spotlight hole.
  final EdgeInsets spotlightInsets;

  /// Gap between the target and the tooltip arrow.
  final double spotlightGap;

  /// Tooltip card background. Falls back to [ColorScheme.surface] when null.
  final Color? tooltipBackgroundColor;

  /// Corner radius of the tooltip card.
  final double tooltipBorderRadius;

  /// Fixed tooltip width on tablet/desktop layouts.
  final double tooltipWidth;

  /// Inner padding of the tooltip card.
  final EdgeInsets tooltipPadding;

  /// Horizontal margin on narrow screens.
  final EdgeInsets tooltipMargin;

  /// Tooltip elevation shadow. Uses a soft default when null.
  final List<BoxShadow>? tooltipBoxShadow;

  /// Vertical spacing between title, body, and actions inside the tooltip.
  final double tooltipSectionSpacing;

  /// Minimum inset from screen edges when positioning the tooltip on desktop.
  final double tooltipPositionInset;

  /// Whether to render the pointer triangle between target and tooltip.
  final bool showTooltipArrow;

  /// Width of the tooltip pointer triangle.
  final double triangleWidth;

  /// Height of the tooltip pointer triangle.
  final double triangleHeight;

  /// Arrow fill color. Falls back to [tooltipBackgroundColor] or surface.
  final Color? tooltipArrowColor;

  /// Width below which mobile layout rules apply.
  final double mobileBreakpoint;

  /// Fade-in duration for tooltip and arrow.
  final Duration fadeDuration;

  /// Curve for the entry fade animation.
  final Curve fadeCurve;

  /// Label for the primary action button.
  final String nextButtonLabel;

  /// Label for the primary action on the final step.
  final String doneButtonLabel;

  /// Label for skipping a multi-step walkthrough.
  final String skipButtonLabel;

  /// Fallback title when a step has no [FlowShowcaseStep.title].
  final String defaultTitle;

  /// Whether to show dot navigation for multi-step walkthroughs.
  final bool showStepIndicator;

  /// Whether to show the circular icon badge in the tooltip header.
  final bool showHeaderIcon;

  /// Whether to show the skip action on multi-step walkthroughs.
  final bool showSkipButton;

  /// Fallback header icon when a step has no [FlowShowcaseStep.icon].
  final Widget? defaultIcon;

  /// Diameter of the circular header icon container.
  final double headerIconSize;

  /// Size of the default [Icons.touch_app] glyph when no custom icon is set.
  final double headerIconInnerSize;

  /// Corner radius of the header icon container.
  final double headerIconBorderRadius;

  /// Header icon container fill. Falls back to primary at 15% opacity.
  final Color? headerIconBackgroundColor;

  /// Header icon glyph color. Falls back to [ColorScheme.primary].
  final Color? headerIconForegroundColor;

  /// Optional override for the tooltip title style.
  final TextStyle? titleTextStyle;

  /// Optional override for the tooltip body style.
  final TextStyle? contentTextStyle;

  /// Active dot color. Falls back to [ColorScheme.primary].
  final Color? stepIndicatorActiveColor;

  /// Inactive dot border color. Falls back to primary at 30% opacity.
  final Color? stepIndicatorInactiveColor;

  /// Diameter of each step indicator dot.
  final double stepIndicatorDotSize;

  /// Horizontal gap between step indicator dots.
  final double stepIndicatorSpacing;

  /// Animation duration when a step dot becomes active.
  final Duration stepIndicatorAnimationDuration;

  /// Optional style for the next/done [ElevatedButton].
  final ButtonStyle? nextButtonStyle;

  /// Optional style for the skip [TextButton].
  final ButtonStyle? skipButtonStyle;

  /// Backward-compatible alias for [spotlightGap].
  @Deprecated('Use spotlightGap instead. This alias will be removed in 2.0.0.')
  double get spotlightPadding => spotlightGap;

  /// Default tooltip shadow used when [tooltipBoxShadow] is null.
  List<BoxShadow> resolveTooltipBoxShadow() {
    return tooltipBoxShadow ??
        const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 8),
            color: Color(0x26000000),
          ),
        ];
  }

  FlowShowcaseStyle copyWith({
    Color? overlayColor,
    bool? enableBlur,
    double? blurSigma,
    bool? dismissOnBackdropTap,
    double? spotlightBorderRadius,
    double? spotlightExpand,
    EdgeInsets? spotlightInsets,
    double? spotlightGap,
    Color? tooltipBackgroundColor,
    double? tooltipBorderRadius,
    double? tooltipWidth,
    EdgeInsets? tooltipPadding,
    EdgeInsets? tooltipMargin,
    List<BoxShadow>? tooltipBoxShadow,
    double? tooltipSectionSpacing,
    double? tooltipPositionInset,
    bool? showTooltipArrow,
    double? triangleWidth,
    double? triangleHeight,
    Color? tooltipArrowColor,
    double? mobileBreakpoint,
    Duration? fadeDuration,
    Curve? fadeCurve,
    String? nextButtonLabel,
    String? doneButtonLabel,
    String? skipButtonLabel,
    String? defaultTitle,
    bool? showStepIndicator,
    bool? showHeaderIcon,
    bool? showSkipButton,
    Widget? defaultIcon,
    double? headerIconSize,
    double? headerIconInnerSize,
    double? headerIconBorderRadius,
    Color? headerIconBackgroundColor,
    Color? headerIconForegroundColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    Color? stepIndicatorActiveColor,
    Color? stepIndicatorInactiveColor,
    double? stepIndicatorDotSize,
    double? stepIndicatorSpacing,
    Duration? stepIndicatorAnimationDuration,
    ButtonStyle? nextButtonStyle,
    ButtonStyle? skipButtonStyle,
  }) {
    return FlowShowcaseStyle(
      overlayColor: overlayColor ?? this.overlayColor,
      enableBlur: enableBlur ?? this.enableBlur,
      blurSigma: blurSigma ?? this.blurSigma,
      dismissOnBackdropTap: dismissOnBackdropTap ?? this.dismissOnBackdropTap,
      spotlightBorderRadius:
          spotlightBorderRadius ?? this.spotlightBorderRadius,
      spotlightExpand: spotlightExpand ?? this.spotlightExpand,
      spotlightInsets: spotlightInsets ?? this.spotlightInsets,
      spotlightGap: spotlightGap ?? this.spotlightGap,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      tooltipBorderRadius: tooltipBorderRadius ?? this.tooltipBorderRadius,
      tooltipWidth: tooltipWidth ?? this.tooltipWidth,
      tooltipPadding: tooltipPadding ?? this.tooltipPadding,
      tooltipMargin: tooltipMargin ?? this.tooltipMargin,
      tooltipBoxShadow: tooltipBoxShadow ?? this.tooltipBoxShadow,
      tooltipSectionSpacing:
          tooltipSectionSpacing ?? this.tooltipSectionSpacing,
      tooltipPositionInset:
          tooltipPositionInset ?? this.tooltipPositionInset,
      showTooltipArrow: showTooltipArrow ?? this.showTooltipArrow,
      triangleWidth: triangleWidth ?? this.triangleWidth,
      triangleHeight: triangleHeight ?? this.triangleHeight,
      tooltipArrowColor: tooltipArrowColor ?? this.tooltipArrowColor,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      fadeCurve: fadeCurve ?? this.fadeCurve,
      nextButtonLabel: nextButtonLabel ?? this.nextButtonLabel,
      doneButtonLabel: doneButtonLabel ?? this.doneButtonLabel,
      skipButtonLabel: skipButtonLabel ?? this.skipButtonLabel,
      defaultTitle: defaultTitle ?? this.defaultTitle,
      showStepIndicator: showStepIndicator ?? this.showStepIndicator,
      showHeaderIcon: showHeaderIcon ?? this.showHeaderIcon,
      showSkipButton: showSkipButton ?? this.showSkipButton,
      defaultIcon: defaultIcon ?? this.defaultIcon,
      headerIconSize: headerIconSize ?? this.headerIconSize,
      headerIconInnerSize: headerIconInnerSize ?? this.headerIconInnerSize,
      headerIconBorderRadius:
          headerIconBorderRadius ?? this.headerIconBorderRadius,
      headerIconBackgroundColor:
          headerIconBackgroundColor ?? this.headerIconBackgroundColor,
      headerIconForegroundColor:
          headerIconForegroundColor ?? this.headerIconForegroundColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      stepIndicatorActiveColor:
          stepIndicatorActiveColor ?? this.stepIndicatorActiveColor,
      stepIndicatorInactiveColor:
          stepIndicatorInactiveColor ?? this.stepIndicatorInactiveColor,
      stepIndicatorDotSize: stepIndicatorDotSize ?? this.stepIndicatorDotSize,
      stepIndicatorSpacing:
          stepIndicatorSpacing ?? this.stepIndicatorSpacing,
      stepIndicatorAnimationDuration: stepIndicatorAnimationDuration ??
          this.stepIndicatorAnimationDuration,
      nextButtonStyle: nextButtonStyle ?? this.nextButtonStyle,
      skipButtonStyle: skipButtonStyle ?? this.skipButtonStyle,
    );
  }
}
