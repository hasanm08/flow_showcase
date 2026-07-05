import 'package:flutter/material.dart';

/// Visual and behavioral configuration for a showcase overlay.
class FlowShowcaseStyle {
  const FlowShowcaseStyle({
    this.overlayColor = const Color(0x4D000000),
    this.blurSigma = 3.9,
    this.spotlightBorderRadius = 8,
    this.tooltipBorderRadius = 8,
    this.tooltipWidth = 400,
    this.tooltipPadding = const EdgeInsets.all(24),
    this.tooltipMargin = const EdgeInsets.symmetric(horizontal: 16),
    this.mobileBreakpoint = 600,
    this.fadeDuration = const Duration(milliseconds: 350),
    this.nextButtonLabel = 'Next',
    this.skipButtonLabel = 'Skip All',
    this.defaultTitle = 'Need a hand?',
    this.triangleWidth = 20,
    this.triangleHeight = 10,
    this.spotlightPadding = 4,
  });

  /// Dimmed backdrop color behind the spotlight cutout.
  final Color overlayColor;

  /// Gaussian blur strength applied to the backdrop.
  final double blurSigma;

  /// Corner radius of the spotlight hole.
  final double spotlightBorderRadius;

  /// Corner radius of the tooltip card.
  final double tooltipBorderRadius;

  /// Fixed tooltip width on tablet/desktop layouts.
  final double tooltipWidth;

  /// Inner padding of the tooltip card.
  final EdgeInsets tooltipPadding;

  /// Horizontal margin on narrow screens.
  final EdgeInsets tooltipMargin;

  /// Width below which mobile layout rules apply.
  final double mobileBreakpoint;

  /// Fade-in duration for tooltip and arrow.
  final Duration fadeDuration;

  /// Label for the primary action button.
  final String nextButtonLabel;

  /// Label for skipping a multi-step walkthrough.
  final String skipButtonLabel;

  /// Fallback title when a step has no [FlowShowcaseStep.title].
  final String defaultTitle;

  /// Width of the tooltip pointer triangle.
  final double triangleWidth;

  /// Height of the tooltip pointer triangle.
  final double triangleHeight;

  /// Extra spacing around the spotlight and tooltip.
  final double spotlightPadding;
}
