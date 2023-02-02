class AdditionalInformationDetailsModel {
  int? code;
  String? message;
  List<Data>? data;

  AdditionalInformationDetailsModel({this.code, this.message, this.data});

  AdditionalInformationDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? key;
  String? label;
  Rules? rules;
  String? value;
  String? displayValue;

  Data(
      {this.id,
        this.type,
        this.key,
        this.label,
        this.rules,
        this.value,
        this.displayValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    key = json['key'];
    label = json['label'];
    rules = json['rules'] != null ? Rules.fromJson(json['rules']) : null;
    value = json['value'];
    displayValue = json['display_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['key'] = key;
    data['label'] = label;
    if (rules != null) {
      data['rules'] = rules!.toJson();
    }
    data['value'] = value;
    data['display_value'] = displayValue;
    return data;
  }
}

class Rules {
  List<PossibleValues>? possibleValues;
  List<String>? extensions;

  Rules({this.possibleValues, this.extensions});

  Rules.fromJson(Map<String, dynamic> json) {
    if (json['possible_values'] != null) {
      possibleValues = <PossibleValues>[];
      json['possible_values'].forEach((v) {
        possibleValues!.add(PossibleValues.fromJson(v));
      });
    }

    if(json['extensions'] != null) {
      extensions = json['extensions'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (possibleValues != null) {
      data['possible_values'] =
          possibleValues!.map((v) => v.toJson()).toList();
    }
    data['extensions'] = extensions;
    return data;
  }
}

class PossibleValues {
  String? key;
  String? label;
  bool? isChecked;

  PossibleValues({this.key, this.label, this.isChecked});

  PossibleValues.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['label'] = label;
    data['is_checked'] = isChecked;
    return data;
  }
}
