import '../model/form_builder_model.dart';

class CommonMethods{

  // Singleton instance of the class by using factory constructor
  static final CommonMethods _instance = CommonMethods._internal();
  factory CommonMethods() => _instance;
  CommonMethods._internal();

  // Method to get the singleton instance
  static CommonMethods get instance => _instance;

  // Method to get the initial value
  String getValidatedString(String? value){
    if(value !=null && value.isNotEmpty){
      return value;
    } else{
      return 'N/A';
    }
  }

  //
  String? getKeyFromValue(
      List<PossibleValues>? possibleValues, String? newValue) {
    String? key;
    for (var element in possibleValues!) {
      if (element.label == newValue) {
        key = element.key;
      }
    }
    return key;
  }
  
  
}