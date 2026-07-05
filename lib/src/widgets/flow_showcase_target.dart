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
  });

  /// Unique identifier used when starting a showcase sequence.
  final String id;

  /// Widget highlighted by the overlay.
  final Widget child;

  /// Optional tooltip title.
  final String? title;

  /// Tooltip body text.
  final String content;

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
        steps.add(
          FlowShowcaseStep(
            key: registration.key,
            title: registration.title,
            content: registration.content,
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
        oldWidget.content != widget.content) {
      FlowShowcaseTarget._registry.remove(oldWidget.id);
      _register();
    }
  }

  void _register() {
    FlowShowcaseTarget._registry[widget.id] = (
      key: _targetKey,
      title: widget.title,
      content: widget.content,
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
