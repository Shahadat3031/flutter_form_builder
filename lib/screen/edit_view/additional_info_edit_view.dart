import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../model/form_builder_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_methos.dart';
import '../widgets/dynamic_text_field.dart';
import '../widgets/buttons/raised_button_with_custom_shadow.dart';
import 'additional_info_edit_controller.dart';

class AdditionalInfoEditView extends StatefulWidget {

  final AdditionalInformationDetailsModel additionalData;
  final int? tabsId;

  const AdditionalInfoEditView({Key? key, required this.additionalData, this.tabsId})
      : super(key: key);

  @override
  State<AdditionalInfoEditView> createState() => _AdditionalInfoEditViewState();
}

class _AdditionalInfoEditViewState extends State<AdditionalInfoEditView> {
  String? selectedValue;
  final AdditionalInfoEditController _con = AdditionalInfoEditController();
  int? tabsId;

  @override
  void initState() {
    super.initState();
    tabsId = widget.tabsId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Additional Information',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          getListView(),
          bottomSaveButton(),
        ],
      ),
    );
  }

  Widget getListView() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: ListView.builder(
        itemCount: widget.additionalData.data?.length ?? 0,
        itemBuilder: (context, index) {
          return getAdditionalInformationView(
              widget.additionalData.data![index], index);
        },
      ),
    );
  }

  Widget getAdditionalInformationView(Data data, int index) {
    if (data.type == 'number' || data.type == 'string') {
      ValueNotifier<String> textNotifier = ValueNotifier(data.value ?? '');
      bool isNumber = (data.type == 'number') ? true : false;
      return ValueListenableBuilder(
          valueListenable: textNotifier,
          builder: (context, textValue, child) {
            return DynamicTextField(
                title: data.label,
                hints: data.value,
                textInputType: isNumber ? TextInputType.number : TextInputType.text,
                onChange: (value) {
                  textValue = value;
                  _con.additionalInfoMap[data.id] = value;
                });
          });
    } else if (data.type == 'dropdown') {
      ValueNotifier<String?> dropdownValueNotifier =
      ValueNotifier<String?>(null);
      selectedValue = getSelectedValue(
          data.rules?.possibleValues, data.value.toString(), data.type);
      dropdownValueNotifier.value = selectedValue;
      final List<String>? options = [];
      for (int i = 0; i < data.rules!.possibleValues!.length; i++) {
        options?.add(data.rules!.possibleValues![i].label!);
      }
      return Visibility(
        visible: data.value != null,
        child: getDropdownList(data, data.label, options!, selectedValue,
            options[0], dropdownValueNotifier),
      );
    } else if (data.type == 'checkbox') {
      ValueNotifier<List<bool>?> checkBoxValueNotifier =
      ValueNotifier<List<bool>?>([]);
      for (int i = 0; i < data.rules!.possibleValues!.length; i++) {
        checkBoxValueNotifier.value
            ?.add(data.rules!.possibleValues![i].isChecked!);
      }

      return getCheckBoxList(
          data.rules?.possibleValues, data, checkBoxValueNotifier);
    } else if (data.type == 'radio') {
      int? selectedItem = getSelectedRadioValue(
          data.rules?.possibleValues, data.value.toString(), data.type);
      ValueNotifier<int?> radioValueNotifier =
      ValueNotifier<int?>(selectedItem);
      return getDynamicRadioButtonList(
          data.rules?.possibleValues, data, radioValueNotifier);
    } else if (data.type == 'file') {
      ValueNotifier<PlatformFile?> fileValueNotifier =
      ValueNotifier<PlatformFile?>(null);
      return getFilePicker(data, fileValueNotifier);
    } else {
      return const Text('N/A');
    }
  }

  Widget getDropdownList(
      Data? data,
      String? title,
      List<String> items,
      String? selectedValue,
      String? hints,
      ValueNotifier<String?> dropdownValueNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'N/A',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorsUtil.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtil.textFieldBorderBlue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.only(left: 24.0),
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
                isDense: false,
              ),
              child: ValueListenableBuilder(
                valueListenable: dropdownValueNotifier,
                builder: (context, value, child) {
                  return Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(hints ?? 'Please select an item'),
                        value: dropdownValueNotifier.value ?? items[0],
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        items: items.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          //find out the key of the selected value
                          String? key = CommonMethods.instance.getKeyFromValue(
                              data?.rules?.possibleValues, newValue);
                          _con.additionalInfoMap[data?.id] = key;
                          dropdownValueNotifier.value = newValue;
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget getCheckBoxList(List<PossibleValues>? list, Data data,
      ValueNotifier<List<bool>?> checkBoxNotifier) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.label ?? 'N/A',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorsUtil.darkBlue,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list?.length ?? 0,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: checkBoxNotifier,
                  builder: (context, List<bool>? value, child) {
                    return GestureDetector(
                      onTap: () {
                        List<String>? selectedKeys = [];
                        checkBoxNotifier.value?[index] =
                        !checkBoxNotifier.value![index];
                        checkBoxNotifier.notifyListeners();
                        for (int i = 0; i < list!.length; i++) {
                          if (checkBoxNotifier.value![i] == true) {
                            //key value pair
                            selectedKeys.add(list[i].key!);
                          } else {
                            selectedKeys.remove(list[i].key!);
                          }
                        }
                        _con.checkboxList[data.id] = selectedKeys;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'images/card_bg_white_pressed.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: value![index],
                                onChanged: (value) {
                                  List<String>? selectedKeys = [];
                                  checkBoxNotifier.value?[index] =
                                  !checkBoxNotifier.value![index];
                                  checkBoxNotifier.notifyListeners();

                                  for (int i = 0; i < list!.length; i++) {
                                    if (checkBoxNotifier.value![i] == true) {
                                      selectedKeys.add(list[i].key!);
                                    } else {
                                      selectedKeys.remove(list[i].key!);
                                    }
                                  }

                                  _con.checkboxList[data.id] = selectedKeys;

                                  /* _con.additionalInfoMap[data.id] =
                                      selectedKeys.toString();*/
                                }),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 16.0, top: 24.0, bottom: 20.0),
                                child: Text(list![index].label ?? 'N/A')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String getSelectedValue(
      List<PossibleValues>? list, String key, String? type) {
    String? value;
    if (type == 'dropdown') {
      if (list != null && key != 'null') {
        for (int i = 0; i < list.length; i++) {
          if (list[i].key == key) {
            value = list[i].label.toString();
            break;
          }
        }
      }
      return value.toString();
    } else {
      return value ?? 'N/A';
    }
  }

  int? getSelectedRadioValue(
      List<PossibleValues>? list, String key, String? type) {
    int? value;
    if (type == 'radio') {
      if (list != null && key != 'null') {
        for (int i = 0; i < list.length; i++) {
          if (list[i].key == key) {
            value = i;
            break;
          }
        }
      }
      return value;
    } else {
      return value ?? 0;
    }
  }

  Widget getDynamicRadioButtonList(List<PossibleValues>? list, Data data,
      ValueNotifier<int?> radioValueNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.label ?? 'N/A',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorsUtil.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: radioValueNotifier,
          builder: (context, groupValue, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list?.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    radioValueNotifier.value = index;
                    _con.additionalInfoMap[data.id] = list![index].key;

                    // radioValueNotifier.notifyListeners();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/card_bg_white_pressed.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: index,
                            groupValue: groupValue,
                            onChanged: (value) {
                              _con.additionalInfoMap[data.id] =
                                  list![index].key;
                              radioValueNotifier.value = value as int?;
                              print(radioValueNotifier.value);
                            }),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 16.0, top: 24.0, bottom: 20.0),
                            child: Text(list![index].label ?? 'N/A')),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget getFilePicker(
      Data data, ValueNotifier<PlatformFile?> fileValueNotifier) {
    return ValueListenableBuilder(
        valueListenable: fileValueNotifier,
        builder: (context, PlatformFile? value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CommonMethods.instance.getValidatedString(data.label),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtil.darkBlue,
                ),
              ),
              // SizedBox(height: 16),
              Visibility(
                visible: value != null,
                child: GestureDetector(
                  onTap: () {
                    OpenFilex.open(value!.path!);
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Image.asset('images/preview_image.png', height: 40),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _pickFile(context, data, fileValueNotifier);
                },
                child: Container(
                  // margin: EdgeInsets.only(right: 24.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/card_bg_white_pressed.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, top: 16.0, bottom: 16.0),
                        child: const Text('Upload File'),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 16.0, top: 16.0, bottom: 16.0),
                        child: const Icon(Icons.file_upload),
                      ),
                    ],
                  ),
                ),
              ),
              /* Container(
          child: Image.asset(whichIconShouldShow(fileValueNotifier.value)),
        ),*/
              const SizedBox(height: 16),
            ],
          );
        });
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
      return 'images/attention.png';
    }
  }

  Future<void> _pickFile(BuildContext context, Data data,
      ValueNotifier<PlatformFile?> valueNotifier) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    String? errorMessage;
    try {
      if (result != null) {
        PlatformFile file = result.files.first;

        //check the file is below 5 MB or not
        if (file.size > 5e+6) {
          errorMessage = 'File size should be less than 5 MB';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
        } else {
          valueNotifier.value = file;
          _con.files[data.id] = file;
          //_con.additionalInfoMap[data.id] = file.path;
        }

        if (_con.files.isEmpty) {
          print('File is not selected');
          // ToastUtils.instance.showInfo(errorMessage ?? 'File is not selected');
        }
      } else {
        // User canceled the picker - do nothing
      }
    } catch (e) {
      print(e);
    }
  }

  Widget bottomSaveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 74,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 10),
          child: RaisedButtonWithCustomShadow(
            enable: true,
            title: 'Save',
            textColor: Colors.white,
            backgroundColor: ColorsUtil.appColor,
            onTap: () {
              // print all the data from _con.additionalInfoMap
              _con.additionalInfoMap.forEach((key, value) {
                print('Key: $key, Value: $value');
              });

              // show a snackBar to show the data is saved
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Data is saved'),
              ));
             // _con.updateExtraData(context, _con.additionalInfoMap);
            },
            shadowColor: const Color(0xFFa2422b),
          )),
    );
  }

}
