import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TextFileInformationView extends StatelessWidget {
  final String? title;
  final String? value;
  final Function onTap;
  final Function onClick;

  const TextFileInformationView({
    Key? key,
    required this.title,
    this.value,
    required this.onTap, required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(
                getTitle(title),
                style: TextStyle(color: ColorsUtil.navyBlue),
              )),
          Expanded(
            flex: 2,
            child: value !=null? Row(
              children: [
                Image.asset(whichIconShouldShow(value ?? ''), height: 32 , width: 32,),
                const Spacer(),
                GestureDetector(
                    onTap: (){
                      onClick();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset('images/download_icon.png', height: 24 , width: 24,))),
              ],
            ) : noFileFoundTextWidget(),
          ),
        ],
      ),
    );
  }

  // Design a widget with Row and text that no image found icon
  Widget noFileFoundTextWidget(){
    return Row(
      children: [
        Text('No File Found', style: TextStyle(color: ColorsUtil.navyBlue),),
      ],
    );
  }
}

 String getTitle(String? title){
  if(title !=null && title != ''){
    return title;
  } else{
    return 'N/A';
  }
}

  String whichIconShouldShow(String link) {
    String fileLink = link;
    // find out the extension of the fileLink value
     String value = fileLink.substring(fileLink.lastIndexOf('.') + 1);
    if (value == 'doc' || value == 'docx') {
      return 'images/preview_doc.png';
    } else if (value == 'pdf') {
      return 'images/preview_pdf.png';
    } else if (value == 'png' || value == 'jpg' || value == 'jpeg') {
      return 'images/preview_image.png';
    } else {
      return 'images/approve.png';
    }
  }
