import 'package:flutter/material.dart';
import 'package:flutter_form_builder/utils/common_methos.dart';
import '../../utils/colors.dart';

class DynamicTextField extends StatelessWidget {

  final String? title;
  final String? value;
  final String? hints;
  final TextInputType? textInputType;
  final Function(String search) onChange;

  const DynamicTextField({
    Key? key,
    required this.title, this.value,
    this.hints, this.textInputType,required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'N/A',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorsUtil.softBlue,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: CommonMethods.instance.getValidatedString(hints),
         onChanged: (value){
           onChange(value);
         },
          keyboardType: textInputType,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsUtil.textFieldBorderBlue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
            const EdgeInsets.only(top: 13, bottom: 15, left: 24),
            filled: true,
            fillColor: ColorsUtil.lightGrey,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            hintText: hints ?? 'Please input information',
            isDense: false,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}