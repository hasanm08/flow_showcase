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
                child: const Text('One'),
              ),
              FlowShowcaseTarget(
                id: 'second',
                content: 'Second body',
                child: const Text('Two'),
              ),
            ],
          ),
        ),
      ),
    );

    final steps = FlowShowcaseTarget.getSteps(['first', 'second', 'missing']);
    expect(steps, hasLength(2));
    expect(steps[0].title, 'First');
    expect(steps[0].content, 'First body');
    expect(steps[1].title, isNull);
    expect(steps[1].content, 'Second body');
    expect(steps[0].key.currentContext, isNotNull);
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
    expect(style.fadeDuration, const Duration(milliseconds: 350));
  });
}
