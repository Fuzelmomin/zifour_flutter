import 'package:dio/dio.dart';
import 'package:zifour_sourcecode/core/api_client/api_constans.dart';
import 'package:zifour_sourcecode/core/api_client/dio_client.dart';
import 'package:zifour_sourcecode/features/multimedia_library/model/multimedia_videos_model.dart';

class MultimediaVideosRepository {
  final DioClient _dioClient = DioClient();

  Future<MultimediaVideosModel> fetchMultimediaVideos(String mulibId) async {
    try {
      final response = await _dioClient.getDio().get(
        APIConstants.getMultiMediaVideos,
        queryParameters: {'mulib_id': mulibId},
      );
      
      if (response.statusCode == 200) {
        return MultimediaVideosModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load multimedia videos');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load multimedia videos');
    } catch (e) {
      throw Exception('Failed to load multimedia videos: $e');
    }
  }
}
