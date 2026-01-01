/// Defines how the dictionary definition is displayed.
///
/// Choose between a bottom sheet or a dialog presentation.
enum DisplayMode {
  /// Display definitions in a modal bottom sheet.
  ///
  /// This is the default mode and works well on mobile devices.
  bottomSheet,

  /// Display definitions in a centered dialog.
  ///
  /// This works well on larger screens like tablets and desktops.
  dialog,
}
