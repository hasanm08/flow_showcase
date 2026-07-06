import 'package:flutter/material.dart';

import 'flow_showcase_style.dart';

/// Describes a single step in a [FlowShowcaseController] walkthrough.
class FlowShowcaseStep {
  /// Creates a showcase step bound to a widget [key].
  const FlowShowcaseStep({
    required this.key,
    required this.content,
    this.title,
    this.icon,
    this.enabled = true,
    this.overlayColor,
    this.spotlightBorderRadius,
    this.spotlightExpand,
    this.spotlightInsets,
    this.spotlightGap,
  });

  /// The [GlobalKey] attached to the target widget via [FlowShowcaseTarget].
  final GlobalKey key;

  /// Optional headline shown above [content].
  final String? title;

  /// Body text explaining the highlighted UI element.
  final String content;

  /// Optional icon shown in the tooltip header.
  ///
  /// Falls back to [FlowShowcaseStyle.defaultIcon] when null.
  final Widget? icon;

  /// When `false`, this step is omitted from walkthroughs.
  final bool enabled;

  /// Per-step backdrop tint. Falls back to [FlowShowcaseStyle.overlayColor].
  final Color? overlayColor;

  /// Per-step spotlight corner radius.
  final double? spotlightBorderRadius;

  /// Per-step uniform spotlight expansion.
  final double? spotlightExpand;

  /// Per-step asymmetric spotlight expansion.
  final EdgeInsets? spotlightInsets;

  /// Per-step gap between target and tooltip arrow.
  final double? spotlightGap;

  double resolveSpotlightBorderRadius(FlowShowcaseStyle style) =>
      spotlightBorderRadius ?? style.spotlightBorderRadius;

  double resolveSpotlightExpand(FlowShowcaseStyle style) =>
      spotlightExpand ?? style.spotlightExpand;

  EdgeInsets resolveSpotlightInsets(FlowShowcaseStyle style) =>
      spotlightInsets ?? style.spotlightInsets;

  double resolveSpotlightGap(FlowShowcaseStyle style) =>
      spotlightGap ?? style.spotlightGap;

  Color resolveOverlayColor(FlowShowcaseStyle style) =>
      overlayColor ?? style.overlayColor;

  Rect resolveSpotlightRect(Rect targetBounds, FlowShowcaseStyle style) {
    final gap = resolveSpotlightExpand(style);
    final insets = resolveSpotlightInsets(style);
    return Rect.fromLTRB(
      targetBounds.left - insets.left - gap,
      targetBounds.top - insets.top - gap,
      targetBounds.right + insets.right + gap,
      targetBounds.bottom + insets.bottom + gap,
    );
  }

  FlowShowcaseStep copyWith({
    GlobalKey? key,
    String? title,
    String? content,
    Widget? icon,
    bool? enabled,
    Color? overlayColor,
    double? spotlightBorderRadius,
    double? spotlightExpand,
    EdgeInsets? spotlightInsets,
    double? spotlightGap,
  }) {
    return FlowShowcaseStep(
      key: key ?? this.key,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
      overlayColor: overlayColor ?? this.overlayColor,
      spotlightBorderRadius:
          spotlightBorderRadius ?? this.spotlightBorderRadius,
      spotlightExpand: spotlightExpand ?? this.spotlightExpand,
      spotlightInsets: spotlightInsets ?? this.spotlightInsets,
      spotlightGap: spotlightGap ?? this.spotlightGap,
    );
  }
}

/// Internal registry record for a registered target.
typedef FlowShowcaseRegistration = ({
  GlobalKey key,
  String? title,
  String content,
  Widget? icon,
  bool enabled,
  Color? overlayColor,
  double? spotlightBorderRadius,
  double? spotlightExpand,
  EdgeInsets? spotlightInsets,
  double? spotlightGap,
});
