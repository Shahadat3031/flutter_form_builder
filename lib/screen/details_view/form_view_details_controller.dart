import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/demo_model.dart';

class FormViewDetailsController {
  bool isShowTextField(String? type) {
    if (type == 'checkbox' ||
        type == 'dropdown' ||
        type == 'string' ||
        type == 'number' ||
        type == 'radio') {
      return true;
    } else {
      return false;
    }
  }

  bool isFileShow(String? type) {
    if (type == 'file') {
      return true;
    } else {
      return false;
    }
  }

  String getValueFromKey(
      List<PossibleValues>? list, String? key, String? type) {
    String? value;
    if (type == 'radio' || type == 'dropdown') {
      if (list != null && key != 'null') {
        for (int i = 0; i < list.length; i++) {
          if (list[i].key == key) {
            value = list[i].label;
            break;
          }
        }
      }
      return value ?? 'N/A';
    } else if (type == 'checkbox') {
      String possibleValue = '';
      String? value;

      //key.contains(list[i].key.toString()) --> No need to match keys
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i].isChecked == true) {
            possibleValue = possibleValue + ', ' + list[i].label.toString();
          }
        }
      }

      //remove comma from the first from the possibleValue
      if (possibleValue != 'null' && possibleValue.isNotEmpty) {
        possibleValue = possibleValue.substring(2);
      }

      if (possibleValue != 'null' && possibleValue.isNotEmpty) {
        value = possibleValue;
      } else {
        value = 'N/A';
      }

      return value;
    } else if (type == 'string' || type == 'number') {
      if (key != null && key != 'null') {
        return key;
      } else {
        return 'N/A';
      }
    } else {
      return 'N/A';
    }
  }

  bool isDividerShow(int length, int index) {
    if (length > (index + 1)) {
      return true;
    } else {
      return false;
    }
  }


  void downloadFileFromAdditionalInformation(
      String? url, String? dialogMessage, BuildContext context) async {
    // await launch(url!);
    String? nameOFTheFile;
    Dio dio = Dio();

    // request for storage permission if not granted
    if (Platform.isAndroid) {
      Permission permission = Permission.storage;
      if (await permission.isGranted) {
        // permission is granted
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        print(statuses[Permission.storage]);
      }
    }

    EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false);

    try {
      if (url != null) {
        String? path;
        if (Platform.isAndroid) {
          Future<Directory?> downloadsDirectory =
              DownloadsPathProvider.downloadsDirectory;
          path = (await downloadsDirectory)?.path;
        } else if (Platform.isIOS) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          path = appDocDir.path;
        } else {
          print('Platform is not supported');

          /* ToastUtils.instance
              .showInfo('Please use Android/IOS to download payslip');*/
        }

        var completeUrl = url;
        nameOFTheFile = (completeUrl.split('/').last);

        String fullPath = '$path/$nameOFTheFile';

        await Future.delayed(const Duration(milliseconds: 500));
        EasyLoading.show(
            status: 'Downloading...',
            maskType: EasyLoadingMaskType.custom,
            dismissOnTap: false);

        await dio.download(url, fullPath);

        EasyLoading.dismiss();
        await Future.delayed(const Duration(milliseconds: 500));
        print('Downloaded successfully!');
        // CommonDialog.createCommonDialog(
        //     text: '$dialogMessage Downloaded successfully!',
        //     positiveButtonTitle: 'OK',
        //     context: context,
        //     image: 'images/checked.png',
        //     callback: () {
        //       // LogDebugger.logger.i(' Path: ' + path.toString());
        //       Navigator.of(context).pop();
        //       //canLaunch('$path');
        //     });
      } else {
        EasyLoading.dismiss();
        print("$nameOFTheFile couldn't found.");
        // ToastUtils.instance.showInfo("$nameOFTheFile couldn't found.");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("$dialogMessage couldn't found");
      // showErrorDialog("$dialogMessage couldn't found", context);
      throw e.toString();
    }
  }

// void showErrorDialog(String alertMessage, BuildContext context) {
//   CommonDialog.errorCommonDialog(
//       text: alertMessage,
//       closeOption: 'Close',
//       context: context,
//       image: 'images/attention.png',
//       callback: () {
//         Navigator.of(context).pop();
//       });
// }
}
