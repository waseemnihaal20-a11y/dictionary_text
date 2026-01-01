import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that provides tap animation effects for text.
///
/// Animates the child widget when tapped or long-pressed, providing
/// visual feedback with scale, color, and shadow effects.
class AnimatedTextWrapper extends StatefulWidget {
  /// Creates an [AnimatedTextWrapper] instance.
  const AnimatedTextWrapper({
    required this.child,
    required this.onTrigger,
    super.key,
    this.triggerOnTap = true,
    this.selectedColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.enableHapticFeedback = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// Callback when the trigger gesture is detected.
  final VoidCallback onTrigger;

  /// Whether to trigger on tap (true) or long press (false).
  final bool triggerOnTap;

  /// Color to apply when selected.
  final Color? selectedColor;

  /// Duration of the animation.
  final Duration animationDuration;

  /// Curve for the animation.
  final Curve animationCurve;

  /// Whether to provide haptic feedback.
  final bool enableHapticFeedback;

  @override
  State<AnimatedTextWrapper> createState() => _AnimatedTextWrapperState();
}

class _AnimatedTextWrapperState extends State<AnimatedTextWrapper>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.triggerOnTap) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      widget.onTrigger();
    }
  }

  void _handleLongPress() {
    if (!widget.triggerOnTap) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      widget.onTrigger();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = widget.selectedColor ?? theme.primaryColor;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: widget.animationCurve,
              decoration: BoxDecoration(
                color: _isPressed
                    ? selectedColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: selectedColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
