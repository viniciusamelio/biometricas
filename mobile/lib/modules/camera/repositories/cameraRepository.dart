import 'package:biometricas/modules/camera/dto/pictureProcessRequestDto.dart';
import 'package:biometricas/modules/camera/dto/pictureProcessResponseDto.dart';
import 'package:biometricas/shared/constants.dart';
import 'package:dio/dio.dart';

class CameraRepository {
  Future<PictureProcessResponseDto> process(
      PictureProcessRequestDto dto) async {
    try {
      final response =
          await Dio().post(baseUrl + 'process', data: dto.toJson());
      return PictureProcessResponseDto.fromJson(response.data);
    } catch (e) {
      final response = new PictureProcessResponseDto(e);
      return response;
    }
  }
}
