import 'package:flutter/widgets.dart';

import '../models/flow_showcase_step.dart';

/// Wraps a widget and registers it as a showcase target by [id].
///
/// Use [FlowShowcaseTarget.getSteps] or [FlowShowcaseController.start] to
/// resolve registered targets into a walkthrough sequence.
///
/// ```dart
/// FlowShowcaseTarget(
///   id: 'profile_avatar',
///   title: 'Your Profile',
///   content: 'Tap here to update your avatar.',
///   child: CircleAvatar(child: Icon(Icons.person)),
/// )
/// ```
class FlowShowcaseTarget extends StatefulWidget {
  const FlowShowcaseTarget({
    super.key,
    required this.id,
    required this.child,
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

  /// Unique identifier used when starting a showcase sequence.
  final String id;

  /// Widget highlighted by the overlay.
  final Widget child;

  /// Optional tooltip title.
  final String? title;

  /// Tooltip body text.
  final String content;

  /// Optional icon shown in the tooltip header for this step.
  final Widget? icon;

  /// When `false`, this target is skipped when resolving [getSteps].
  final bool enabled;

  /// Per-step backdrop tint override.
  final Color? overlayColor;

  /// Per-step spotlight corner radius override.
  final double? spotlightBorderRadius;

  /// Per-step uniform spotlight expansion override.
  final double? spotlightExpand;

  /// Per-step asymmetric spotlight expansion override.
  final EdgeInsets? spotlightInsets;

  /// Per-step gap between target and tooltip arrow override.
  final double? spotlightGap;

  static final Map<String, FlowShowcaseRegistration> _registry = {};

  /// Returns the registration for [id], or `null` if not built yet.
  static FlowShowcaseRegistration? getRegistration(String id) {
    return _registry[id];
  }

  /// Resolves [ids] into [FlowShowcaseStep] instances in order.
  ///
  /// Missing ids are skipped with a debug warning so partial trees do not
  /// crash production apps.
  static List<FlowShowcaseStep> getSteps(List<String> ids) {
    final steps = <FlowShowcaseStep>[];
    for (final id in ids) {
      final registration = _registry[id];
      if (registration != null) {
        if (!registration.enabled) {
          continue;
        }
        steps.add(
          FlowShowcaseStep(
            key: registration.key,
            title: registration.title,
            content: registration.content,
            icon: registration.icon,
            enabled: registration.enabled,
            overlayColor: registration.overlayColor,
            spotlightBorderRadius: registration.spotlightBorderRadius,
            spotlightExpand: registration.spotlightExpand,
            spotlightInsets: registration.spotlightInsets,
            spotlightGap: registration.spotlightGap,
          ),
        );
      } else {
        debugPrint(
          'FlowShowcase: target "$id" is not registered yet. '
          'Ensure the widget is built before starting the showcase.',
        );
      }
    }
    return steps;
  }

  /// Clears all registrations. Useful in tests.
  @visibleForTesting
  static void clearRegistry() => _registry.clear();

  @override
  State<FlowShowcaseTarget> createState() => _FlowShowcaseTargetState();
}

class _FlowShowcaseTargetState extends State<FlowShowcaseTarget> {
  final GlobalKey _targetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _register();
  }

  @override
  void didUpdateWidget(FlowShowcaseTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id ||
        oldWidget.title != widget.title ||
        oldWidget.content != widget.content ||
        oldWidget.icon != widget.icon ||
        oldWidget.enabled != widget.enabled ||
        oldWidget.overlayColor != widget.overlayColor ||
        oldWidget.spotlightBorderRadius != widget.spotlightBorderRadius ||
        oldWidget.spotlightExpand != widget.spotlightExpand ||
        oldWidget.spotlightInsets != widget.spotlightInsets ||
        oldWidget.spotlightGap != widget.spotlightGap) {
      FlowShowcaseTarget._registry.remove(oldWidget.id);
      _register();
    }
  }

  void _register() {
    FlowShowcaseTarget._registry[widget.id] = (
      key: _targetKey,
      title: widget.title,
      content: widget.content,
      icon: widget.icon,
      enabled: widget.enabled,
      overlayColor: widget.overlayColor,
      spotlightBorderRadius: widget.spotlightBorderRadius,
      spotlightExpand: widget.spotlightExpand,
      spotlightInsets: widget.spotlightInsets,
      spotlightGap: widget.spotlightGap,
    );
  }

  @override
  void dispose() {
    FlowShowcaseTarget._registry.remove(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _targetKey,
      child: widget.child,
    );
  }
}
