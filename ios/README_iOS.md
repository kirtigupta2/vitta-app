# Vitta – iOS (SwiftUI) – setup on the Mac

Screens: A01 Home, A02 long-press ring, A03 suggestions (tap "Best fit for me"
or type and send), A04 building recommendation, A05 card intro.

1. Xcode > File > New > Project > iOS > App. Name: Vitta, Interface: SwiftUI,
   Language: Swift. Minimum iOS: 16.0 (Target > General > Minimum Deployments).
2. In the project navigator delete the generated `VittaApp.swift` (or
   `<Name>App.swift`) and `ContentView.swift` (Move to Trash). Also delete the
   generated `Assets.xcassets`.
3. Drag the whole `Vitta` folder contents (the .swift files AND `Assets.xcassets`)
   into the project. Tick "Copy items if needed" and your app target.
4. Run on an iPhone simulator (iPhone 15 or newer).

Images and icons are already inside `Assets.xcassets` with the same names as the
Android app. `qa_statement` (Statement icon) was never provided, so an SF Symbol
is used until you add `qa_statement.svg` as a new image set named `qa_statement`.
Missing images fall back to placeholders, so the app never crashes.

If Xcode shows errors, send me a screenshot or the text of the red error.
