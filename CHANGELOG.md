## 1.1.0

* Full dynamic styling via `FlowShowcaseStyle.copyWith` and expanded properties.
* `enableBlur`, `blurSigma`, and `overlayColor` for backdrop control.
* `spotlightBorderRadius`, `spotlightExpand`, `spotlightInsets`, and `spotlightGap` for hole geometry.
* `tooltipBackgroundColor`, `tooltipArrowColor`, `tooltipBoxShadow`, typography, button styles, and header icon sizing/colors.
* `showTooltipArrow`, `dismissOnBackdropTap`, `fadeCurve`, and step-indicator sizing/colors.
* Per-step spotlight and overlay overrides on `FlowShowcaseTarget` / `FlowShowcaseStep`.
* `spotlightPadding` renamed to `spotlightGap` (deprecated alias retained).

## 1.1.0

* Per-step `icon` on `FlowShowcaseTarget` and `FlowShowcaseStep` for custom tooltip header badges.
* `enabled` flag on targets and steps to dynamically include or skip walkthrough steps.
* `FlowShowcaseStyle` flags: `showStepIndicator`, `showHeaderIcon`, `showSkipButton`.
* `doneButtonLabel` and `defaultIcon` style options for finer control over tooltip chrome.
* Export `ShowcaseStepIndicator` for custom layouts.

## 1.0.2

* Fix README demo visibility on GitHub and pub.dev (animated GIF + screenshot).

## 1.0.1

* added Demo video and enhanced documentations

## 1.0.0

* Initial stable release.
* `FlowShowcaseTarget` for declarative tour target registration.
* `FlowShowcaseController` for multi-step overlay walkthroughs.
* `FlowShowcaseStyle` for theming and behavior customization.
* Adaptive tooltip positioning with spotlight cutout and backdrop blur.
* Built-in step indicator with no third-party dependencies.
* Example app demonstrating navigation and FAB onboarding.
