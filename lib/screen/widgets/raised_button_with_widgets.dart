import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class RaisedButtonWithWidget extends StatefulWidget {
  final Widget widget;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
  final Color disableColor;
  final Color? disableBorderColor;
  final VoidCallback onTap;
  final bool? enable;

  const RaisedButtonWithWidget(
      {Key? key,
      required this.widget,
      required this.backgroundColor,
      required this.textColor,
      required this.shadowColor,
      this.enable,
      required this.disableColor,
      this.disableBorderColor,
      required this.onTap})
      : super(key: key);

  @override
  State<RaisedButtonWithWidget> createState() => _RaisedButtonWithWidgetState();
}

class _RaisedButtonWithWidgetState extends State<RaisedButtonWithWidget> {
  bool inPress = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.enable??false) {
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
        if (widget.enable??false) {
          inPress = true;
          if (mounted) {
            setState(() {});
          }
        }
      },
      onLongPress: () {
        if (widget.enable??false) {
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
            color: getBackgroundColor(
                widget.enable??false, widget.backgroundColor, widget.disableColor),
            border: Border.all(
                width: 1,
                color: getBorderColor(
                    widget.enable??false,
                    inPress,
                    widget.shadowColor,
                    widget.backgroundColor,
                    widget.disableColor,
                    widget.disableBorderColor ?? ColorsUtil.disableButtonColor)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: getBorderColor(
                      widget.enable??false,
                      inPress,
                      widget.shadowColor,
                      widget.backgroundColor,
                      widget.disableColor,
                      widget.disableBorderColor ?? ColorsUtil.disableButtonColor),
                  offset: const Offset(0, 4)),
              BoxShadow(
                  color: Colors.grey.withOpacity(.05),
                  offset: const Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 3)
            ],
          ),
          child: widget.widget,
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
