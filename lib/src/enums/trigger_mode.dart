/// Defines the gesture that triggers the dictionary lookup.
///
/// Choose between a tap or long-press gesture.
enum TriggerMode {
  /// Trigger dictionary lookup on a single tap.
  ///
  /// This is the default mode for quick access.
  tap,

  /// Trigger dictionary lookup on a long press.
  ///
  /// Use this to avoid accidental triggers during scrolling.
  longPress,
}
