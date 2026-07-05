# Getting Started with flow_showcase

This guide walks you through adding an interactive onboarding tour to a Flutter app in a few minutes.

## 1. Add the dependency

```yaml
dependencies:
  flow_showcase: ^1.0.0
```

Run `flutter pub get`.

## 2. Mark tour targets

Assign a stable string id to every widget you want to spotlight:

```dart
FlowShowcaseTarget(
  id: 'settings_gear',
  title: 'Settings',
  content: 'Configure notifications, theme, and privacy from here.',
  child: IconButton(
    icon: const Icon(Icons.settings),
    onPressed: openSettings,
  ),
),
```

**Tips**

- Use descriptive, stable ids (`nav_profile`, not `step3`).
- Wrap the smallest widget that should be highlighted.
- Titles are optional; a default headline is used when omitted.

## 3. Launch the tour

Always start after the widget tree has laid out targets:

```dart
void _startTour() {
  FlowShowcaseController.start(
    context,
    ids: ['settings_gear', 'fab_create'],
    onComplete: () {
      // Persist onboarding completion, analytics, etc.
    },
  );
}

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _startTour());
}
```

## 4. Customize appearance

Pass a `FlowShowcaseStyle` to match your brand:

```dart
const style = FlowShowcaseStyle(
  overlayColor: Color(0x66000000),
  blurSigma: 4,
  nextButtonLabel: 'Got it',
  skipButtonLabel: 'Skip tour',
  fadeDuration: Duration(milliseconds: 250),
);
```

## 5. Advanced control

For manual control, construct a controller:

```dart
final controller = FlowShowcaseController(
  steps: FlowShowcaseTarget.getSteps(['a', 'b', 'c']),
  onComplete: () {},
);

controller.show(context);   // first step
controller.jumpTo(context, 1); // jump to step 2
controller.skip();          // end tour early
controller.dispose();       // remove overlay without onComplete
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Step missing from tour | Ensure the target is built before calling `show` |
| Tooltip not positioned | Confirm the target has non-zero size after layout |
| Overlay under dialogs | Pass `useRootOverlay: true` on the controller |

## Next steps

- Explore the [example app](../example/lib/main.dart)
- Read the [API reference](https://pub.dev/documentation/flow_showcase/latest/)
- Open an [issue](https://github.com/hasanm08/flow_showcase/issues) for feature requests
