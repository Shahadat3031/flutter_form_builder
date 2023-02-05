import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class RaisedButtonWithCustomShadow extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
  final Color? disableColor;
  final Color? disableBorderColor;
  final VoidCallback onTap;
  final bool? enable;

  const RaisedButtonWithCustomShadow(
      {Key? key,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      required this.shadowColor,
      this.enable,
      this.disableColor,
      this.disableBorderColor,
      required this.onTap})
      : super(key: key);

  @override
  State<RaisedButtonWithCustomShadow> createState() =>
      _RaisedButtonWithCustomShadowState();
}

class _RaisedButtonWithCustomShadowState
    extends State<RaisedButtonWithCustomShadow> {
  bool inPress = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.enable ?? true) {
          inPress = true;
          if (mounted) {
            setState(() {});
          }
          Future.delayed(const Duration(milliseconds: 150)).then((value) {
            inPress = false;
            if (mounted) {
              setState(() {});
            }
          });
          widget.onTap();
        }
      },
      onTapDown: (value) {
        if (widget.enable ?? true) {
          inPress = true;
          if (mounted) {
            setState(() {});
          }
        }
      },
      onLongPress: () {
        if (widget.enable ?? true) {
          inPress = true;
          if (mounted) {
            setState(() {});
          }
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            inPress = false;
            if (mounted) {
              setState(() {});
            }
          });
          widget.onTap();
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.zero,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getBackgroundColor(widget.enable ?? true,
                widget.backgroundColor, widget.disableColor),
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: getBorderColor(
                      widget.enable ?? true,
                      inPress,
                      widget.shadowColor,
                      widget.backgroundColor,
                      widget.disableColor ?? ColorsUtil.disableColor,
                      widget.disableBorderColor ?? ColorsUtil.disableColor),
                  offset: const Offset(0, 4)),
              BoxShadow(
                  color: Colors.grey.withOpacity(.05),
                  offset: const Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 3)
            ],
          ),
          child: Text(
            widget.title,
            style: TextStyle(
                color: widget.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Color getBackgroundColor(
      bool isEnable, Color backgroundColor, Color? disableColor) {
    if (isEnable) {
      return backgroundColor;
    } else {
      return disableColor ?? ColorsUtil.disableButtonColor;
    }
  }

  Color getBorderColor(bool isEnable, bool isPress, Color borderColor,
      Color backgroundColor, Color disableColor, Color? disableShadowColor) {
    if (isEnable) {
      if (isPress) {
        return backgroundColor;
      } else {
        return borderColor;
      }
    } else {
      return disableShadowColor ?? ColorsUtil.disableButtonShadowColor;
    }
  }
}
