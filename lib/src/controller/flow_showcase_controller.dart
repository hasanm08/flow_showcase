import 'package:flutter/material.dart';

import '../models/flow_showcase_step.dart';
import '../models/flow_showcase_style.dart';
import '../overlay/flow_showcase_overlay.dart';
import '../widgets/flow_showcase_target.dart';

/// Drives a multi-step interactive showcase using overlay entries.
///
/// Prefer [FlowShowcaseController.start] for the common case where targets are
/// registered via [FlowShowcaseTarget].
class FlowShowcaseController {
  FlowShowcaseController({
    required this.steps,
    this.onComplete,
    this.style = const FlowShowcaseStyle(),
    this.useRootOverlay = false,
  });

  final List<FlowShowcaseStep> steps;
  final VoidCallback? onComplete;
  final FlowShowcaseStyle style;

  /// When `true`, inserts into the root navigator overlay instead of the
  /// nearest [Overlay].
  final bool useRootOverlay;

  OverlayEntry? _entry;
  int _index = -1;
  bool _completed = false;

  /// Starts or advances the showcase from [context].
  void show(BuildContext context) {
    if (steps.isEmpty) {
      _finish();
      return;
    }

    _removeEntry();

    if (_index >= steps.length - 1) {
      _finish();
      return;
    }

    _index += 1;
    _insertStep(context, _index);
  }

  /// Jumps directly to [index] and redisplays the overlay.
  void jumpTo(BuildContext context, int index) {
    if (steps.isEmpty || index < 0 || index >= steps.length) {
      return;
    }
    _removeEntry();
    _index = index;
    _insertStep(context, _index);
  }

  /// Skips remaining steps and disposes the overlay.
  void skip() {
    _removeEntry();
    _finish();
  }

  /// Removes the overlay without invoking [onComplete].
  void dispose() {
    _removeEntry();
    _completed = true;
  }

  /// Convenience API: resolves [ids] and starts the walkthrough.
  static FlowShowcaseController start(
    BuildContext context, {
    required List<String> ids,
    VoidCallback? onComplete,
    FlowShowcaseStyle style = const FlowShowcaseStyle(),
    bool useRootOverlay = false,
  }) {
    final controller = FlowShowcaseController(
      steps: FlowShowcaseTarget.getSteps(ids),
      onComplete: onComplete,
      style: style,
      useRootOverlay: useRootOverlay,
    );
    controller.show(context);
    return controller;
  }

  void _insertStep(BuildContext context, int index) {
    final overlayState = _resolveOverlay(context);
    if (overlayState == null) {
      debugPrint('FlowShowcase: no Overlay found in context.');
      return;
    }

    _entry = OverlayEntry(
      builder: (overlayContext) => FlowShowcaseOverlay(
        step: steps[index],
        stepCount: steps.length,
        stepIndex: index,
        style: style,
        onNext: () => show(context),
        onSkip: skip,
        onStepSelected: (selectedIndex) => jumpTo(context, selectedIndex),
      ),
    );

    overlayState.insert(_entry!);
  }

  OverlayState? _resolveOverlay(BuildContext context) {
    if (useRootOverlay) {
      return Overlay.maybeOf(context, rootOverlay: true);
    }
    return Overlay.maybeOf(context);
  }

  void _removeEntry() {
    final entry = _entry;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
    _entry = null;
  }

  void _finish() {
    if (_completed) {
      return;
    }
    _completed = true;
    onComplete?.call();
  }
}
