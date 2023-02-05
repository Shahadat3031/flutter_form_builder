import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/form_builder_model.dart';
import 'package:flutter_form_builder/utils/common_methos.dart';
import 'package:flutter_form_builder/utils/snackbar_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:page_transition/page_transition.dart';

import '../edit_view/additional_info_edit_view.dart';
import '../widgets/buttons/edit_additional_information_button.dart';
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
  AdditionalInformationDetailsModel detailsModel =
      AdditionalInformationDetailsModel();
  final FormViewDetailsController _con = FormViewDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text('Form Builder Details',
            style: TextStyle(color: Colors.black)),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 32),
          child: _additionalData(detailsModel)),
    );
  }

  @override
  void initState() {
    super.initState();
    detailsModel = _con.getDetailsModelData();
  }

  Widget _additionalData(AdditionalInformationDetailsModel data) {
    return Stack(
      children: [
        ListView.builder(
            itemCount: detailsModel.data?.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Visibility(
                      visible:
                          _con.isShowTextField(detailsModel.data![index].type),
                      child: showText(index)),
                  Visibility(
                      visible: _con.isFileShow(detailsModel.data![index].type),
                      child: showFilePreview(index)),
                  Visibility(
                      visible: index == detailsModel.data!.length - 1,
                      child: const SizedBox(height: 80))
                ],
              );
            }),
        bottomSaveButtonWidget()
      ],
    );
  }

  Widget bottomSaveButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: EditAdditionalInfoButton(
          context: context,
          title: 'Edit Additional Info',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdditionalInfoEditView(
                        additionalData: detailsModel,
                        tabsId: 1,)
              ),
            );
          },
        ),
      ),
    );
  }

  Widget showText(int index) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: TextFieldInformationView(
            title: detailsModel.data![index].label,
            value: _con.getValueFromKey(
                detailsModel.data![index].rules?.possibleValues,
                detailsModel.data![index].value.toString(),
                detailsModel.data![index].type),
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

  Widget showFilePreview(int index) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: TextFileInformationView(
            title: detailsModel.data![index].label,
            value: detailsModel.data![index].value,
            onTap: () {
              processFile(index);
            },
            onClick: () {
              //File Download
              if (detailsModel.data![index].value != null) {
                _con.downloadFileFromAdditionalInformation(
                    detailsModel.data![index].value.toString(),
                    'File',
                    context);
              } else {
                SnackBarUtils.instance.showSnackBar(context, 'File not found', duration: 3);
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

  void processFile(int index) {
    String? extension = CommonMethods.instance
        .getFileExtension(index, detailsModel.data![index].value);
    if( extension !=null){
      if (extension == 'png' ||
          extension == 'jpg' ||
          extension == 'jpeg' ||
          extension == 'gif' ||
          extension == 'bmp' ||
          extension == 'webp' ||
          extension == 'svg' ||
          extension == 'tiff') {
        gotoEditAdditionalScreen(index);
      } else {
        OpenFilex.open(detailsModel.data![index].value.toString());
      }
    } else {
      SnackBarUtils.instance.showSnackBar(context, 'File not found', duration: 3);
    }
  }

  void gotoEditAdditionalScreen(int index) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ImageDetails(detailsModel.data![index].value.toString()),
      ),
    );
  }
}
