# Vitta app (Flutter)

Flutter version of the five Android screens in the Figma file
"App Interface Design SEM 3" (frames A01 to A05).

## The flow

| Screen | What happens |
|---|---|
| A01 Home | Tap the eye to hide or show the balance. Tap the chevron for balance details. Scroll the offer cards sideways. |
| A02 Long press | Long-press any card (offers, portfolio, payments). A glowing ring appears under your finger. |
| A03 Suggestions | After about a second the screen dims, the card lifts, and three chips appear. Tap a chip to continue. Tap outside to cancel. |
| A04 Building | The agent log runs its five steps one by one, then moves on by itself. Tap the header to collapse it. |
| A05 Card intro | The savings number counts up to $1,200+. Switch between Key benefits and How it works. |

The search box at the bottom works too: the mic turns into a send button when you type.

## Setup (one time)

This repo holds the Dart code only. Generate the Android project files with:

```bash
git clone https://github.com/kirtigupta2/vitta-app.git
cd vitta-app
flutter create . --platforms=android --project-name vitta_app --org com.example
git checkout -- lib pubspec.yaml test analysis_options.yaml .gitignore
flutter pub get
flutter run
```

The `git checkout` line restores any of the project files that `flutter create`
may have replaced with its own starter versions.

## Add the images from Figma

The app runs without any images and shows placeholders. To match the design,
export these from Figma (right-click the layer, then Export, PNG at 3x) and
put them in `assets/images/` with exactly these names:

| File | Figma layer |
|---|---|
| `avatar.png` | Image / Avatar |
| `offer_dining.png` | Image / Offer Illustration (the dining cloche) |
| `offer_concert.png` | Image / Offer Illustration (the concert one) |
| `logo_lcid.png` | Image / Stock Logo - LCID |
| `logo_chrn.png` | Image / Stock Logo - CHRN |
| `logo_sah.png` | Image / Stock Logo - SAH |

Icons use Flutter's built-in Material icons. To use the exact Figma icons
instead, export them as SVG into `assets/icons/`, run
`flutter pub add flutter_svg`, and swap the `Icon(...)` widgets for
`SvgPicture.asset(...)`.

## Build the APK

```bash
flutter build apk --release
```

The file is created at `build/app/outputs/flutter-apk/app-release.apk`.
Copy it to an Android phone and open it to install. You may need to allow
installs from your file manager.

To show "Vitta" as the app name, change `android:label` in
`android/app/src/main/AndroidManifest.xml`.

## Project layout

```
lib/
  main.dart                 app + theme
  theme/tokens.dart         colors, shadows, text helper (from Figma)
  screens/
    home_screen.dart        A01
    vitta_overlay.dart      A02 + A03 (long-press ring, dim, chips)
    vitta_build_screen.dart A04
    card_intro_screen.dart  A05
  widgets/                  shared pieces (search box, agent log, orb, cards)
```

## Things the Figma file does not cover

- The "How it works" tab has no design, so its text is placeholder copy.
- "Get Started", the bottom tabs other than Home, quick actions and
  notifications have no destination screens, so they show a short message.
- The balance details sheet uses made-up demo numbers.
- The agent log says "Agent Actions (6)" in Figma but lists five steps,
  so the app shows the real count (5).
