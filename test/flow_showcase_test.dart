import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow_showcase/flow_showcase.dart';

void main() {
  tearDown(FlowShowcaseTarget.clearRegistry);

  testWidgets('registers targets and resolves ordered steps', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              FlowShowcaseTarget(
                id: 'first',
                title: 'First',
                content: 'First body',
                icon: const Icon(Icons.star),
                child: const Text('One'),
              ),
              FlowShowcaseTarget(
                id: 'second',
                content: 'Second body',
                child: const Text('Two'),
              ),
              FlowShowcaseTarget(
                id: 'disabled',
                content: 'Skipped',
                enabled: false,
                child: const Text('Three'),
              ),
            ],
          ),
        ),
      ),
    );

    final steps = FlowShowcaseTarget.getSteps(
      ['first', 'second', 'missing', 'disabled'],
    );
    expect(steps, hasLength(2));
    expect(steps[0].title, 'First');
    expect(steps[0].content, 'First body');
    expect(steps[0].icon, isA<Icon>());
    expect(steps[1].title, isNull);
    expect(steps[1].content, 'Second body');
    expect(steps[0].key.currentContext, isNotNull);
  });

  testWidgets('controller omits disabled steps', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  FlowShowcaseController(
                    steps: [
                      FlowShowcaseStep(
                        key: GlobalKey(),
                        content: 'Active',
                        enabled: true,
                      ),
                      FlowShowcaseStep(
                        key: GlobalKey(),
                        content: 'Inactive',
                        enabled: false,
                      ),
                    ],
                  );
                },
                child: const Text('Go'),
              ),
            );
          },
        ),
      ),
    );

    final controller = FlowShowcaseController(
      steps: [
        FlowShowcaseStep(
          key: GlobalKey(),
          content: 'Active',
        ),
        FlowShowcaseStep(
          key: GlobalKey(),
          content: 'Inactive',
          enabled: false,
        ),
      ],
    );
    expect(controller.steps, hasLength(1));
    expect(controller.steps.first.content, 'Active');
  });

  test('FlowShowcaseStep copyWith preserves unspecified fields', () {
    final step = FlowShowcaseStep(
      key: GlobalKey(),
      title: 'A',
      content: 'B',
    );

    final copy = step.copyWith(content: 'C');
    expect(copy.title, 'A');
    expect(copy.content, 'C');
  });

  test('FlowShowcaseStyle exposes stable defaults', () {
    const style = FlowShowcaseStyle();
    expect(style.nextButtonLabel, 'Next');
    expect(style.doneButtonLabel, 'Done');
    expect(style.enableBlur, isTrue);
    expect(style.spotlightBorderRadius, 8);
    expect(style.spotlightGap, 4);
    expect(style.showStepIndicator, isTrue);
    expect(style.showHeaderIcon, isTrue);
    expect(style.showSkipButton, isTrue);
    expect(style.showTooltipArrow, isTrue);
    expect(style.dismissOnBackdropTap, isTrue);
    expect(style.fadeDuration, const Duration(milliseconds: 350));
    expect(style.fadeCurve, Curves.easeOut);
  });

  test('FlowShowcaseStyle copyWith overrides selected fields', () {
    const style = FlowShowcaseStyle();
    final updated = style.copyWith(
      enableBlur: false,
      overlayColor: Color(0x80000000),
      spotlightBorderRadius: 16,
    );
    expect(updated.enableBlur, isFalse);
    expect(updated.overlayColor, const Color(0x80000000));
    expect(updated.spotlightBorderRadius, 16);
    expect(updated.nextButtonLabel, 'Next');
  });

  test('FlowShowcaseStep resolves per-step spotlight geometry', () {
    const style = FlowShowcaseStyle(
      spotlightBorderRadius: 8,
      spotlightExpand: 2,
      spotlightGap: 4,
    );
    final step = FlowShowcaseStep(
      key: GlobalKey(),
      content: 'Body',
      spotlightBorderRadius: 20,
      spotlightExpand: 6,
      spotlightGap: 10,
    );

    expect(step.resolveSpotlightBorderRadius(style), 20);
    expect(step.resolveSpotlightExpand(style), 6);
    expect(step.resolveSpotlightGap(style), 10);
    expect(
      step.resolveSpotlightRect(const Rect.fromLTWH(10, 20, 30, 40), style),
      const Rect.fromLTRB(4, 14, 46, 66),
    );
  });
}
