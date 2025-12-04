import 'package:dio/dio.dart';
import 'package:zifour_sourcecode/core/api_client/api_constans.dart';
import 'package:zifour_sourcecode/core/api_client/dio_client.dart';
import 'package:zifour_sourcecode/features/multimedia_library/model/multimedia_library_model.dart';

class MultimediaLibraryRepository {
  final DioClient _dioClient = DioClient();

  Future<MultimediaLibraryModel> fetchMultimediaLibrary() async {
    try {
      final response = await _dioClient.getDio().get(APIConstants.getMultiMediaLibrary);
      
      if (response.statusCode == 200) {
        return MultimediaLibraryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load multimedia library');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to load multimedia library');
    } catch (e) {
      throw Exception('Failed to load multimedia library: $e');
    }
  }
}
