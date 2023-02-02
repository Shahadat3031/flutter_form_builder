import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class TextFieldInformationView extends StatelessWidget {
  final String? title;
  final String? value;

  const TextFieldInformationView({
    Key? key, required this.title, this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Text(
              getTitle(title),
              style: TextStyle(color: ColorsUtil.navyBlue),
            )),
        Expanded(
          flex: 2,
          child: Text(
            getTitle(value),
            style: TextStyle(
                fontSize: 14, color: ColorsUtil.navyBlue),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String getTitle(String? title){
    if(title !=null && title.isNotEmpty){
      return title;
    } else{
      return 'N/A';
    }
  }
}