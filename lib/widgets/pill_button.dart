import 'package:flutter/material.dart';
class PillButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback? onPressed;
  final double verticalPadding;
  final bool isLoading;

  const PillButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textStyle,
    required this.onPressed,
    this.verticalPadding = 15.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
        elevation: 0,
        shape: const StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textStyle.color ?? Colors.white,
                ),
              ),
            )
          : Text(
              text,
              style: isDisabled
                  ? textStyle.copyWith(
                      color: textStyle.color?.withValues(alpha: 0.7),
                    )
                  : textStyle,
            ),
    );
  }
}