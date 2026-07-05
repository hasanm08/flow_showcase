import 'package:flutter/widgets.dart';

/// Describes a single step in a [FlowShowcaseController] walkthrough.
class FlowShowcaseStep {
  /// Creates a showcase step bound to a widget [key].
  const FlowShowcaseStep({
    required this.key,
    required this.content,
    this.title,
  });

  /// The [GlobalKey] attached to the target widget via [FlowShowcaseTarget].
  final GlobalKey key;

  /// Optional headline shown above [content].
  final String? title;

  /// Body text explaining the highlighted UI element.
  final String content;

  FlowShowcaseStep copyWith({
    GlobalKey? key,
    String? title,
    String? content,
  }) {
    return FlowShowcaseStep(
      key: key ?? this.key,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

/// Internal registry record for a registered target.
typedef FlowShowcaseRegistration = ({
  GlobalKey key,
  String? title,
  String content,
});
