class PictureProcessResponseDto {
  String percentage;
  String imageUrl;
  String message;
  bool approved;
  dynamic error;

  PictureProcessResponseDto(error) {
    error = error;
  }

  PictureProcessResponseDto.fromJson(Map json) {
    percentage = json['percentage'].toString();
    message = json['message'];
    imageUrl = json['path'];
  }

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['percentage'] = percentage;
    json['path'] = imageUrl;
    json['message'] = message;
    return json;
  }
}
