import 'package:biometricas/modules/camera/dto/pictureProcessRequestDto.dart';
import 'package:biometricas/modules/camera/dto/pictureProcessResponseDto.dart';
import 'package:dio/dio.dart';

class CameraRepository {
  Future<PictureProcessResponseDto> process(
      PictureProcessRequestDto dto) async {
    try {
      final response = await Dio().post(
          'https://biometricas-api.herokuapp.com/process',
          data: dto.toJson());
      return PictureProcessResponseDto.fromJson(response.data);
    } catch (e) {
      final response = new PictureProcessResponseDto(e);
      return response;
    }
  }
}
