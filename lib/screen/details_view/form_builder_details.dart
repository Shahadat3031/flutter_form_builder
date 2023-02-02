import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/demo_model.dart';
import 'package:open_filex/open_filex.dart';
import 'package:page_transition/page_transition.dart';

import '../edit_view/additional_info_edit_view.dart';
import '../widgets/edit_additional_information_button.dart';
import '../widgets/show_image_from_url.dart';
import '../widgets/text_file_view.dart';
import '../widgets/text_info_view.dart';
import 'form_view_details_controller.dart';

class FormBuilderDetails extends StatefulWidget {
  const FormBuilderDetails({Key? key}) : super(key: key);

  @override
  State<FormBuilderDetails> createState() => _FormBuilderDetailsState();
}

class _FormBuilderDetailsState extends State<FormBuilderDetails> {

  AdditionalInformationDetailsModel detailsModel = AdditionalInformationDetailsModel();
  final FormViewDetailsController _con = FormViewDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder Details'),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 32),
          child: _additionalData(detailsModel)),
    );
  }

  @override
  void initState() {
    super.initState();
    //input some demo data to the demo_model.dart file AdditionalInformationDetailsModel class
    detailsModel = AdditionalInformationDetailsModel(
      code: 200,
      message: 'Success',
      data: [
        Data(
          id: 1,
          type: 'string',
          key: 'name',
          label: 'Name',
          rules: null,
          value: 'Shahadat Hossain',
          displayValue: 'Shahadat Hossain',
        ),
        Data(
            id: 2,
            type: "string",
            key: "sadat",
            label: "Name",
            rules: null,
            value: 'Sadat Hossain',
            displayValue: 'Sadat Hossain'),
        Data(
            id: 3,
            type: "file",
            key: "upload_image",
            label: "First Image",
            rules: Rules(extensions: ["png", "jpeg", "jpg", "docx", "pdf"]),
            value:
                "https://s3.ap-south-1.amazonaws.com/cdn-shebadev/uploads/business/member/additional/1674708640_ms._tisha_khatunsda_upload_image.jpeg",
            displayValue:
                "https://s3.ap-south-1.amazonaws.com/cdn-shebadev/uploads/business/member/additional/1674708640_ms._tisha_khatunsda_upload_image.jpeg"),
        Data(
            id: 4,
            type: "file",
            key: "second_image",
            label: "Second Image",
            rules: Rules(extensions: ["png", "jpeg", "jpg", "docx", "pdf"]),
            value:
                "https://s3.ap-south-1.amazonaws.com/cdn-shebadev/uploads/business/member/additional/1674708647_ms._tisha_khatunsda_second_image.pdf",
            displayValue:
                "https://s3.ap-south-1.amazonaws.com/cdn-shebadev/uploads/business/member/additional/1674708647_ms._tisha_khatunsda_second_image.pdf")
      ],
    );
  }

  Widget _additionalData(AdditionalInformationDetailsModel data){
    return Stack(
      children: [
        ListView.builder(
            itemCount: detailsModel.data?.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Visibility(
                      visible: _con.isShowTextField(detailsModel.data![index].type),
                      child: showText(index)),
                  Visibility(
                      visible: _con.isFileShow(detailsModel.data![index].type),
                      child: showFilePreview(index)),
                  // Show a SizeBox if the data is not the last one with 100 height
                  Visibility(
                      visible: index == detailsModel.data!.length - 1,
                      child: const SizedBox(height: 80))
                ],
              );
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: EditAdditionalInfoButton(context: context,title: 'Edit Additional Info',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                  AdditionalInfoEditView(
                    additionalData: detailsModel,
                    tabsId: 1,
                  )),
                );
              },),
          ),
        )
      ],
    );
  }

  Widget showText(int index){
    return Column(
      children: [
        Container(
          padding:  const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: TextFieldInformationView(
            title: detailsModel.data![index].label,
            value: _con.getValueFromKey(detailsModel.data![index].rules?.possibleValues,
                detailsModel.data![index].value.toString(), detailsModel.data![index].type),
          ),
        ),
        Visibility(
          visible: _con.isDividerShow(detailsModel.data?.length ?? 0, index),
          child: const Divider(
            height: 1,
          ),
        ),

      ],
    );
  }

  Widget showFilePreview(int index){
    return Column(
      children: [
        Container(
          padding:  const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: TextFileInformationView(
            title: detailsModel.data![index].label,
            value: detailsModel.data![index].value,
            onTap: () {
              //Image Showing
              String? value, link;
              link = detailsModel.data![index].value;

              //TODO create another function for this
              if( link != null){
                value = link.substring(link.lastIndexOf('.') + 1);
              }
              if(value == 'png' || value == 'jpg' || value == 'jpeg')
              {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ImageDetails(detailsModel.data![index].value.toString()),
                  ),
                );
              } else{
                OpenFilex.open(detailsModel.data![index].value.toString());
              }
            },
            onClick: (){
              //File Download
              if(detailsModel.data![index].value != null){
                _con.downloadFileFromAdditionalInformation(
                    detailsModel.data![index].value.toString(),
                    'File',
                    context
                );
              } else{
               print('No file found');
              }
            },
          ),
        ),
        Visibility(
          visible: _con.isDividerShow(detailsModel.data?.length ?? 0, index),
          child: const Divider(
            height: 1,
          ),
        ),
      ],
    );
  }

}
