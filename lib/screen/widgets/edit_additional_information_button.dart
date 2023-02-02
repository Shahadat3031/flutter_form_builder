import 'package:flutter/material.dart';
import 'raised_button_with_widgets.dart';
import 'package:flutter_form_builder/utils/colors.dart';

class EditAdditionalInfoButton extends StatelessWidget {
  const EditAdditionalInfoButton({
    Key? key,
    required this.context,
    required this.onPressed,
    this.title,
  })  : super(key: key);

  final BuildContext context;
  final Function() onPressed;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: RaisedButtonWithWidget(
        enable: true,
        widget: Text(title ?? 'Edit',
            style: TextStyle(
                color: ColorsUtil.appColor,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        shadowColor: const Color(0xFFE6E6E6),
        textColor: ColorsUtil.appColor,
        onTap: () {
          onPressed();
        },
        disableColor: ColorsUtil.disableButtonColor,
      ),
    );
  }
}
