import 'dart:convert';
import 'dart:io';

class PictureProcessRequestDto {
  double percentage;
  File file;

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['percentage'] = this.percentage;
    json['file'] =
        "data:image/jpeg;base64," + base64Encode(file.readAsBytesSync());
    return json;
  }
}
