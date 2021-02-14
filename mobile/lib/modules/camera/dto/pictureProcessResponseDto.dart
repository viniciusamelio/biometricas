class PictureProcessResponseDto {
  String percentage;
  String imageUrl;
  String message;
  bool approved;
  dynamic error;

  PictureProcessResponseDto(error) {
    error = error;
  }

  PictureProcessResponseDto.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'].toString();
    approved = json['percentage'] > 90;
    message = json['message'];
    imageUrl = json['path'];
  }
}
